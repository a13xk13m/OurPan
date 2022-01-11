import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_pan/widgets/ingredients_list.dart';
import 'package:our_pan/widgets/recipe_steps_list.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

// Model representing a recipe to be passed to screens or saved in Firebase.
// imageURL is what is stored in Firebase and imagePath
class RecipeModel {
  String title = '';
  String aboutText = '';
  String recipeID = '';
  List<dynamic> imagePath = [];
  List<IngredientModel> ingredients = [];
  List<StepModel> steps = [];
  List<String> tags = [];
  int likes = 0;
  List<CommentModel> comments = [];
  String author = '';

  // Default constructor, every field is required except for
  // image arrays as they change depending on context of use.
  RecipeModel(
      {required this.title,
      required this.aboutText,
      required this.imagePath,
      required this.ingredients,
      required this.steps,
      required this.tags,
      this.author = '',
      this.recipeID = '',
      this.likes = 0,
      this.comments = const []});

  // RecipeID getter.
  String get getRecipeID => recipeID;

  // Constructor from json map.
  // Because images are saved on firebase, imageURL is used.
  RecipeModel.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'] as String;
    aboutText = json['aboutText'] as String;
    if (json['imagePath'] != null) {
      for (var e in json['imagePath']) {
        imagePath.add(e);
      }
    }
    // Parse ingredients list.
    for (var e in json['ingredients']) {
      ingredients.add(IngredientModel.fromJson(e));
    }
    // Parse steps list.
    for (var e in json['steps']) {
      steps.add(StepModel.fromJson(e));
    }
    // Parse tags.
    if (json['tags'] != null) {
      for (var e in json['tags']) {
        tags.add(e);
      }
    }
    likes = json['likes'] as int;
    // Parse comments.
    if (json['comments'] != null) {
      for (var e in json['comments']) {
        comments.add(CommentModel.fromJson(e));
      }
    }
    recipeID = json['recipeID'] as String;
    author = json['author'] as String;
  }

  // Returns a map equivalent to JSON.
  // RecipeID is omitted from toJson() because it is a copy of
  // Firebase's internal id and already exists.
  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> json = {
      'author': author,
      'title': title,
      'aboutText': aboutText,
      'imagePath': imagePath,
      'tags': tags,
      'likes': likes,
      'comments': comments
    };
    // Add ingredients json, steps, and comments json.
    List<Map<dynamic, dynamic>> ingJSON = [];
    for (IngredientModel i in ingredients) ingJSON.add(i.toJson());
    List<Map<dynamic, dynamic>> stepsJSON = [];
    for (StepModel s in steps) stepsJSON.add(s.toJson());
    List<Map<dynamic, dynamic>> commentsJSON = [];
    for (CommentModel c in comments) commentsJSON.add(c.toJson());
    json['ingredients'] = ingJSON;
    json['steps'] = stepsJSON;
    json['comments'] = commentsJSON;
    return json;
  }
}

// Represents a comment on a recipe.
class CommentModel {
  late String text;
  late final String author;
  late DateTime time;
  int likes = 0;

  // Author is string id of user who created comment.
  CommentModel({required this.text, required this.author, this.likes = 0})
      : time = DateTime.now();

  // Returns a map equivalent to JSON.
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'text': text,
        'author': author,
        'time': time.toString(),
        'likes': likes,
      };

  // Creates a CommentModel from JSON
  CommentModel.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'] as String,
        author = json['author'] as String,
        time = json['time'] as DateTime,
        likes = json['likes'] as int;
}

// Data access object for recipes.
class RecipeDao {
  // Initializes storage.
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  late final DatabaseReference ref = FirebaseDatabase.instance.ref('/recipes');

  // Uploads an image from a file path.
  // Returns the url to the file on Firebase.
  Future<String> uploadFile(String filePath) async {
    File file = File(filePath);
    String fileName = basename(filePath);
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('recipe_images/${time + fileName}')
          .putFile(file);
      return await firebase_storage.FirebaseStorage.instance
          .ref('recipe_images/${time + fileName}')
          .getDownloadURL();
    } on Exception catch (e) {
      print(e);
    }
    return '';
  }

  // Uploads a list of images to Firebase Storage.
  // Returns a list of strings corresponding to image urls.
  Future<List<String>> uploadImages(List<XFile?> files) async {
    List<String> urls = [];
    for (XFile? f in files) {
      try {
        if (f != null) {
          String newURL = await uploadFile(f.path);
          urls.add(newURL);
        }
      } on Exception catch (e) {
        print(e);
        // TODO: Error handling.
      }
    }
    return urls;
  }

  // Takes a RecipeModel object and puts into Firebase Realtime Database.
  // Uploads images in the process.
  Future<void> uploadRecipe(RecipeModel recipe) async {
    List<String> images = [];
    if (recipe.imagePath is List<XFile?>) {
      images = await uploadImages(recipe.imagePath as List<XFile?>);
    } else {
      throw ('Cannot upload images. (Check list type)');
    }
    Map<dynamic, dynamic> data = recipe.toJson();
    // Set image paths to data.
    data['imagePath'] = images;
    // Add metadata.
    data['author'] = uid;
    // Upload recipe.
    ref.push().set(data);
  }

  // Gets all recipes belonging to the user.
  // TODO: Implement pagination
  Future<List<RecipeModel>> getUserRecipes(String uid) async {
    List<RecipeModel> recipes = <RecipeModel>[];
    // Query data.
    Query query = ref.orderByChild("author").equalTo(uid);
    DataSnapshot event = await query.get();
    for (var item in event.children) {
      Map<dynamic, dynamic> json = {};
      for (var i in item.children) {
        json[i.key] = i.value;
      }
      // Add recipeID to json.
      print(item.key);
      json['recipeID'] = item.key;
      recipes.add(RecipeModel.fromJson(json));
    }
    return recipes;
  }

  // Takes a recipe and updates its reference for a user.
  Future<void> updateRecipe(RecipeModel recipe) async {
    // Get reference to recipe by recipeID.
    DatabaseReference updateRef =
        FirebaseDatabase.instance.ref('/recipes/${recipe.recipeID}');
    await updateRef.set(recipe.toJson());
  }

  // Takes a recipeID and sets the likes.
  Future<void> updateLike(String recipeID, int likes) async {
    // Get reference to recipe by recipeID.
    DatabaseReference updateRef =
        FirebaseDatabase.instance.ref('/recipes/$recipeID');
    await updateRef.set({'likes': likes});
  }

  // Adds a comment to a recipe.
  // TODO: Probably can be improved.
  Future<void> addComment(String recipeID, CommentModel comment) async {
    // Get reference to recipe by recipeID.
    DatabaseReference updateRef =
        FirebaseDatabase.instance.ref('/recipes/$recipeID/comments');
  }
}
