// DAO for general user-centric actions.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:our_pan/utils/recipe_dao.dart';

class UserDao {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  late final DatabaseReference ref =
      FirebaseDatabase.instance.ref('users/$uid');

  // Saves a recipe's recipeID into the user's saved list.
  Future<void> saveRecipe(String recipeId) async {
    // Very bad implementation that sets a new child of the ref to
    // have a key that is the id of the recipe.
    final DatabaseReference saveRef =
        FirebaseDatabase.instance.ref('users/$uid/saved');
    await ref.set({recipeId: ''});
  }

  // Gets the user's saved recipe list.
  Future<List<RecipeModel>> getSavedRecipes() async {
    List<RecipeModel> recipes = [];
    DatabaseReference listRef = ref.child('/saved');
    DatabaseEvent event = await listRef.once();
    DatabaseReference searchRef = FirebaseDatabase.instance.ref('recipes');
    DatabaseReference recipeRef;
    DatabaseEvent recipeEvent;
    // Iterate and add all recipes to the list.
    for (var item in event.snapshot.children) {
      // Get each recipe by id.
      recipeRef = searchRef.child('/${item.key.toString()}');
      recipeEvent = await recipeRef.once();
      Map<dynamic, dynamic> json = {};
      for (var i in recipeEvent.snapshot.children) {
        json[i.key] = i.value;
      }
      // Add recipeID to json.
      json['recipeID'] = item.key;
      recipes.add(RecipeModel.fromJson(json));
    }
    return recipes;
  }
}
