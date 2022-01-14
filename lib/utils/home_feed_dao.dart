// TODO: Build home feed interface to generate a feed for the user.
// DAO handling getting pages.
import 'package:firebase_database/firebase_database.dart';
import 'package:our_pan/utils/recipe_dao.dart';

class HomeFeedDao {
  // Reference to all recipes
  final DatabaseReference ref = FirebaseDatabase.instance.ref('/recipes');

  // Gets the first 100 recipes and returns a list of RecipeModels.
  // TODO: implement timestamp based pagination.
  Future<List<RecipeModel>> getRecipeFeed({int length = 100}) async {
    List<RecipeModel> recipes = <RecipeModel>[];
    DatabaseEvent feed = await ref.once();
    DataSnapshot feedData = feed.snapshot;
    // Determine length of feed, if the # of children of snapshot is less than
    // the passed length, use that.
    int lengthFeed =
        feedData.children.length > length ? length : feedData.children.length;
    // Iterate through the first 100 children.
    for (int i = 0; i < lengthFeed; ++i) {
      DataSnapshot item = feedData.children.elementAt(i);
      Map<dynamic, dynamic> json = {};
      for (var i in item.children) {
        json[i.key] = i.value;
      }
      // Add recipeID to json.
      json['recipeID'] = item.key;
      recipes.add(RecipeModel.fromJson(json));
    }
    return recipes;
  }
}
