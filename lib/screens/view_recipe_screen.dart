import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/utils/grocery_list_item_dao.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/utils/user_dao.dart';
import 'package:our_pan/widgets/image_view_card.dart';
import 'package:our_pan/widgets/ingredients_list.dart';
import 'package:our_pan/widgets/recipe_interact_ribbon.dart';
import 'package:our_pan/widgets/recipe_steps_list.dart';
import 'package:our_pan/widgets/tag_field.dart';

// Screen that displays a recipe to be used in feeds.
class ViewRecipeScreen extends StatefulWidget {
  late RecipeModel recipe;
  late bool editable;
  ViewRecipeScreen({required this.recipe, this.editable = true});

  @override
  State<StatefulWidget> createState() {
    return _ViewRecipeScreenState();
  }
}

class _ViewRecipeScreenState extends State<ViewRecipeScreen> {
  late RecipeModel recipe;
  late bool editable;
  RecipeDao dao = RecipeDao();
  UserDao userDao = UserDao();
  GroceryListItemDao gliDao = GroceryListItemDao();
  List<String> menuItems = ['Add Ingredients', 'Save'];

  @override
  void initState() {
    recipe = widget.recipe;
    editable = widget.editable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.bars,
          title:
              Text('Recipe', style: TextStyle(color: CustomColors.lightText)),
          actions: <Widget>[
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return menuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    child: Text(choice),
                    value: choice,
                  );
                }).toList();
              },
              onSelected: (item) async {
                switch (item) {
                  case 'Add Ingredients':
                    gliDao.addMultipleItems(recipe.ingredients);
                    break;
                  case 'Save':
                    userDao.saveRecipe(recipe.recipeID);
                    break;
                }
              },
            )
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 200,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (String path in recipe.imagePath)
                        ImageViewCard(url: path)
                    ],
                  )),
              Divider(
                height: 20,
                color: Colors.black,
                endIndent: 10,
                indent: 10,
              ),
              Text(recipe.title,
                  style:
                      TextStyle(fontSize: 18, color: CustomColors.lightText)),
              Text(
                'About',
                style: TextStyle(color: CustomColors.lightText, fontSize: 18),
              ),
              SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Text(
                    recipe.aboutText,
                    style: TextStyle(color: CustomColors.lightText),
                  )),
              Divider(
                height: 20,
                color: Colors.grey,
                endIndent: 10,
                indent: 10,
              ),
              Text(
                'Ingredients',
                style: TextStyle(color: CustomColors.lightText, fontSize: 18),
              ),
              IngredientsList(
                  ingredients: recipe.ingredients, editable: editable),
              Divider(
                height: 20,
                color: Colors.grey,
                endIndent: 10,
                indent: 10,
              ),
              Text(
                'Steps',
                style: TextStyle(color: CustomColors.lightText, fontSize: 18),
              ),
              StepList(steps: recipe.steps, editable: false),
              Divider(
                height: 20,
                color: Colors.grey,
                endIndent: 10,
                indent: 10,
              ),
              TagField(
                tags: recipe.tags,
                limit: 10,
                editable: false,
              ),
              RecipeInteractRibbon(),
            ],
          ),
        )));
  }
}
