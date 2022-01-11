import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/edit_recipe_screen.dart';
import 'package:our_pan/screens/view_recipe_screen.dart';
import 'package:our_pan/utils/recipe_dao.dart';

// Small recipe card to be used in GridView lists.
class SmallRecipeCard extends StatelessWidget {
  late RecipeModel recipe;
  late Function deleteFunc;
  late Function editFunc;
  late int index;
  late ImageProvider prevImage;
  late bool editable;

  SmallRecipeCard(
      {required Key key,
      required this.index,
      required this.recipe,
      required this.deleteFunc,
      required this.editFunc,
      this.editable = true})
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
                        builder: (context) => ViewRecipeScreen(
                            recipe: recipe, editable: editable)),
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
