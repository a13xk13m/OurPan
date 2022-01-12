// Interface to search for recipes and users.
import 'package:firebase_database/firebase_database.dart';
import 'package:our_pan/utils/recipe_dao.dart';

class SearchDao {
  // Queries recipes specifically.
  // Currently searches exactly the string that is provided.
  // TODO: Create actual search functionality.
  Future<List<RecipeModel>> recipeSearch(String queryString) async {
    List<RecipeModel> recipes = <RecipeModel>[];
    // Query data.
    DatabaseReference ref = FirebaseDatabase.instance.ref('recipes');
    Query query = ref.equalTo(queryString);
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

  // Searches authors.
  // Currently searches exactly the string that is provided.
  // TODO: Transform uids to actual user data.
  Future<List<String>> userSearch(String queryString) async {
    List<String> users = <String>[];
    // Query data.
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    Query query = ref.equalTo(queryString);
    DataSnapshot event = await query.get();
    for (var item in event.children) {
      users.add(item.key!);
    }
    return users;
  }

  // Searches tags.
  // Currently searches exactly the string that is provided.
  // TODO: Pagination, return all tags instead of recipes.
  Future<List<String>> tagSearch(String queryString) async {
    List<String> recipes = <String>[];
    // Query data.
    DatabaseReference ref = FirebaseDatabase.instance.ref('recipes');
    Query query = ref.child('/tags').equalTo(queryString);
    DataSnapshot event = await query.get();
    for (var item in event.children) {
      recipes.add(item.key!);
    }
    return recipes;
  }

  // General search that returns users, tags, and recipes.
  Future<Map<String, List<dynamic>>> generalSearch(String query) async {
    Map<String, List<dynamic>> results = {};
    // Query recipes.
    results['recipes'] = await recipeSearch(query);
    // Query users.
    results['users'] = await userSearch(query);
    // Query tags.
    results['tags'] = await tagSearch(query);
    return results;
  }
}
