import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/utils/user_dao.dart';
import 'package:our_pan/widgets/small_recipe_card.dart';

// TODO: Implement pagination.
// Feed shows all recipes a user has saved in small card form.
class ProfileSavedFeed extends StatefulWidget {
  late final String uid;

  ProfileSavedFeed({required this.uid});

  @override
  State<StatefulWidget> createState() {
    return _ProfileSavedFeedState();
  }
}

class _ProfileSavedFeedState extends State<ProfileSavedFeed> {
  late List<RecipeModel> allRecipes = <RecipeModel>[];
  UserDao dao = UserDao();
  late String uid;
  // Gets the user's recipes.
  Future<void> getRecipes() async {
    List<RecipeModel> res = await dao.getSavedRecipes();
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

  // Filler for feed.
  void recipeDeleteFunc() {}

  // Filler for feed.
  void recipeEditFunc() {}

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
            child: Text('Save a recipe in your feed to see it here.',
                style: TextStyle(fontSize: 18, color: CustomColors.darkText)));
  }
}
