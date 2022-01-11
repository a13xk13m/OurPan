import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/recipe_preview_screen.dart';
import 'package:our_pan/screens/user_info_screen.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/widgets/image_upload_card.dart';
import 'package:our_pan/widgets/ingredients_list.dart';
import 'package:our_pan/widgets/recipe_steps_list.dart';
import 'package:our_pan/widgets/tag_field.dart';

// Screen responsible for adding a recipe.
// Takes a GroceryListModel to add ingredients to a grocery list.
class EditRecipeScreen extends StatefulWidget {
  late RecipeModel recipe;

  EditRecipeScreen({required this.recipe});

  @override
  State<StatefulWidget> createState() {
    return _EditRecipeScreenState();
  }
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  late RecipeModel recipe;
  RecipeDao dao = RecipeDao();
  List<String> menuItems = ['Save', 'Discard'];
  TextEditingController aboutCon = TextEditingController();
  TextEditingController titleCon = TextEditingController();

  void initState() {
    recipe = widget.recipe;
    super.initState();
  }

  void updateImage(XFile? img, int index) {
    setState(() {
      recipe.imagePath[index] = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.bars,
          title: Text('Create a Recipe',
              style: TextStyle(color: CustomColors.lightText)),
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
                // TODO: Implement saving and discarding.
                switch (item) {
                  case 'Save':
                    // Upload new recipe.
                    await dao.updateRecipe(recipe);
                    // Return to last page.
                    Navigator.pop(context);
                    break;
                  case 'Discard':
                    Navigator.pop(context);
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
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ImageUploadCard(
                          Key('0'), updateImage, 0, true, null, true),
                      ImageUploadCard(
                          Key('1'), updateImage, 1, true, null, true),
                      ImageUploadCard(
                          Key('2'), updateImage, 2, true, null, true)
                    ],
                  )),
              Divider(
                height: 20,
                color: Colors.black,
                endIndent: 10,
                indent: 10,
              ),
              Text('Name your recipe',
                  style:
                      TextStyle(fontSize: 18, color: CustomColors.lightText)),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    style: TextStyle(color: CustomColors.lightText),
                    cursorColor: CustomColors.lightText,
                    controller: titleCon,
                    maxLength: 20,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.lightText),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.darkText),
                      ),
                    ),
                  )),
              Text(
                'About your recipe',
                style: TextStyle(color: CustomColors.lightText, fontSize: 18),
              ),
              SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    style: TextStyle(color: CustomColors.lightText),
                    cursorColor: CustomColors.darkText,
                    controller: aboutCon,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: 250,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.lightText),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.darkText),
                      ),
                    ),
                  )),
              Divider(
                height: 20,
                color: Colors.grey,
                endIndent: 10,
                indent: 10,
              ),
              Text(
                'Add ingredients',
                style: TextStyle(color: CustomColors.lightText, fontSize: 18),
              ),
              IngredientsList(
                ingredients: recipe.ingredients,
                editable: true,
              ),
              Divider(
                height: 20,
                color: Colors.grey,
                endIndent: 10,
                indent: 10,
              ),
              Text(
                'Add steps',
                style: TextStyle(color: CustomColors.lightText, fontSize: 18),
              ),
              StepList(steps: recipe.steps, editable: true),
              Divider(
                height: 20,
                color: Colors.grey,
                endIndent: 10,
                indent: 10,
              ),
              TagField(
                tags: recipe.tags,
                limit: 10,
                editable: true,
              ),
              MaterialButton(
                child: Text(
                  'Update Recipe',
                  style: TextStyle(color: CustomColors.lightText, fontSize: 16),
                ),
                color: CustomColors.bars,
                onPressed: () async {
                  // Upload new recipe.
                  await dao.updateRecipe(recipe);
                  // Return to last page.
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        )));
  }
}
