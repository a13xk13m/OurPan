import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/edit_recipe_screen.dart';
import 'package:our_pan/screens/view_recipe_screen.dart';
import 'package:our_pan/utils/recipe_dao.dart';

// View only recipe card.
class SmallRecipeCardView extends StatelessWidget {
  late RecipeModel recipe;
  late int index;

  SmallRecipeCardView(
      {required Key key, required this.index, required this.recipe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: CustomColors.bars,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewRecipeScreen(recipe: recipe, editable: false)),
                  );
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  AspectRatio(
                    aspectRatio: 2,
                    child: Container(
                        decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.center,
                          image: NetworkImage(recipe.imagePath[0])),
                    )),
                  ),
                  Text(recipe.title,
                      style: TextStyle(
                          fontSize: 20, color: CustomColors.darkText)),
                ])),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up_sharp,
                    color: CustomColors.darkText,
                  ),
                  onPressed: () {
                    // TODO: Add like and unlike functionality.
                  },
                ),
                IconButton(
                    icon: Icon(
                      Icons.comment,
                      color: CustomColors.darkText,
                    ),
                    onPressed: () {
                      // TODO: Add comment functionality.
                    }),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: CustomColors.darkText,
                  ),
                  onPressed: () {
                    // TODO: Add more dropdown menu.
                  },
                )
              ],
            )
          ],
        ));
  }
}
