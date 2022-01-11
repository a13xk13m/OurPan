import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/widgets/small_recipe_card.dart';

// TODO: Implement pagination.
// Feed shows all recipes a user has created in small card form.
class ProfileRecipeFeed extends StatefulWidget {
  late final String uid;

  ProfileRecipeFeed({required this.uid});

  @override
  State<StatefulWidget> createState() {
    return _ProfileRecipeFeedState();
  }
}

class _ProfileRecipeFeedState extends State<ProfileRecipeFeed> {
  late List<RecipeModel> allRecipes = <RecipeModel>[];
  RecipeDao dao = RecipeDao();
  late String uid;
  // Gets the user's recipes.
  Future<void> getRecipes() async {
    List<RecipeModel> res = await dao.getUserRecipes(uid);
    setState(() {
      allRecipes = res;
    });
  }

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    getRecipes();
  }

  // Deletes a recipe by index.
  void recipeDeleteFunc(int index) {
    setState(() {
      allRecipes.removeAt(index);
    });
    // TODO: Delete recipe from dao.
  }

  // Edits a recipe.
  void recipeEditFunc(int index, RecipeModel recipe) {
    setState(() {
      allRecipes[index] = recipe;
    });
    // TODO: Edits recipe.
  }

  @override
  Widget build(BuildContext context) {
    return allRecipes.length > 0
        ? ListView.builder(
            itemCount: allRecipes.length,
            itemBuilder: (context, index) {
              return SmallRecipeCard(
                key: Key(index.toString()),
                index: index,
                recipe: allRecipes[index],
                deleteFunc: recipeDeleteFunc,
                editFunc: recipeEditFunc,
                editable: false,
              );
            })
        : Center(
            child: Text('Create a recipe with the "+" button on the right.',
                style: TextStyle(fontSize: 18, color: CustomColors.darkText)));
  }
}
