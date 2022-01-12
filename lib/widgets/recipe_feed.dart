import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/widgets/small_recipe_card.dart';
import 'package:our_pan/widgets/small_recipe_card_view.dart';

// TODO: Implement pagination.
// Feed shows all recipes a user has created in small card form.
class RecipeFeed extends StatefulWidget {
  late final List<RecipeModel> recipes;

  RecipeFeed({required this.recipes});

  @override
  State<StatefulWidget> createState() {
    return _RecipeFeedState();
  }
}

class _RecipeFeedState extends State<RecipeFeed> {
  late List<RecipeModel> recipes = <RecipeModel>[];

  @override
  void initState() {
    super.initState();
    recipes = widget.recipes;
  }

  @override
  Widget build(BuildContext context) {
    return recipes.length > 0
        ? ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return SmallRecipeCardView(
                key: Key(index.toString()),
                index: index,
                recipe: recipes[index],
              );
            })
        : Center(
            child: Text('Search for a recipe in the box above.',
                style: TextStyle(fontSize: 18, color: CustomColors.darkText)));
  }
}
