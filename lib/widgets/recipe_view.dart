import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/home_feed_screen.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/widgets/image_upload_card.dart';
import 'package:our_pan/widgets/image_view_card.dart';
import 'package:our_pan/widgets/ingredients_list.dart';
import 'package:our_pan/widgets/recipe_steps_list.dart';
import 'package:our_pan/widgets/tag_field.dart';

// Recipe view that displays a JSON recipe.
class RecipeView extends StatefulWidget {
  late RecipeModel recipe;
  late bool editable;

  RecipeView({required this.recipe, this.editable = true});

  @override
  State<StatefulWidget> createState() {
    return _RecipeViewState();
  }
}

// TODO: Add support for switching images from urls to paths and vice versa.
class _RecipeViewState extends State<RecipeView> {
  late String title;
  late String about;
  List<IngredientModel> ingredients = <IngredientModel>[];
  List<StepModel> steps = <StepModel>[];
  List<dynamic> images = [null, null, null];
  List<String> menuItems = ['Save', 'Discard'];
  List<String> tags = [];
  late bool editable;

  void initState() {
    super.initState();
    title = widget.recipe.title;
    about = widget.recipe.aboutText;
    about = widget.recipe.aboutText;
    ingredients = widget.recipe.ingredients;
    steps = widget.recipe.steps;
    images = widget.recipe.imagePath;
    tags = widget.recipe.tags;
    editable = widget.editable;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  for (var i = 0; i < images.length; ++i)
                    editable
                        ? ImageUploadCard(
                            Key(i.toString()), () {}, i, false, images[i], true)
                        : ImageViewCard(url: images[i])
                ],
              )),
          Divider(
            height: 20,
            color: Colors.black,
            endIndent: 10,
            indent: 10,
          ),
          Text(
            'About',
            style: TextStyle(color: CustomColors.lightText, fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            about,
            style: TextStyle(color: CustomColors.lightText, fontSize: 16),
          ),
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
            ingredients: ingredients,
            editable: editable,
          ),
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
          StepList(
            steps: steps,
            editable: editable,
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
            editable: false,
          )
        ],
      ),
    ));
  }
}
