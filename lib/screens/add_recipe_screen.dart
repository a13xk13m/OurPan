import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/recipe_preview_screen.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/widgets/image_upload_card.dart';
import 'package:our_pan/widgets/ingredients_list.dart';
import 'package:our_pan/widgets/recipe_steps_list.dart';
import 'package:our_pan/widgets/tag_field.dart';

// Screen responsible for adding a recipe.
// Takes a GroceryListModel to add ingredients to a grocery list.
class AddRecipeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddRecipeScreenState();
  }
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  List<IngredientModel> ingredients = <IngredientModel>[];
  List<StepModel> steps = <StepModel>[];
  List<XFile?> images = [null, null, null];
  List<String> menuItems = ['Save', 'Discard'];
  TextEditingController aboutCon = TextEditingController();
  TextEditingController titleCon = TextEditingController();
  List<String> tags = [];

  void initState() {
    super.initState();
  }

  void updateImage(XFile? img, int index) {
    setState(() {
      images[index] = img;
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
              IngredientsList(ingredients: ingredients, editable: true),
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
              StepList(
                steps: steps,
                editable: true,
              ),
              Divider(
                height: 20,
                color: Colors.grey,
                endIndent: 10,
                indent: 10,
              ),
              TagField(
                tags: tags,
                limit: 10,
                editable: true,
              ),
              MaterialButton(
                child: Text(
                  'Review Recipe',
                  style: TextStyle(color: CustomColors.lightText, fontSize: 16),
                ),
                color: CustomColors.bars,
                onPressed: () {
                  // Redirect to preview screen with recipe data.
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipePreviewScreen(RecipeModel(
                              title: titleCon.text,
                              aboutText: aboutCon.text,
                              imagePath: images,
                              ingredients: ingredients,
                              steps: steps,
                              tags: tags))));
                },
              ),
            ],
          ),
        )));
  }
}
