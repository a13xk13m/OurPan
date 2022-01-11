// Screen that displays an immutable recipe view and allows for the option to
// publish it.
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/home.dart';
import 'package:our_pan/screens/home_feed_screen.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/widgets/recipe_view.dart';

class RecipePreviewScreen extends StatelessWidget {
  final dao = RecipeDao();
  final List<String> menuItems = ['Discard'];
  final RecipeModel recipe;
  RecipePreviewScreen(this.recipe);

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: CustomColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.bars,
        title:
            Text(recipe.title, style: TextStyle(color: CustomColors.lightText)),
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
                case 'Discard':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeFeedScreen()));
                  break;
              }
            },
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RecipeView(
            recipe: recipe,
            editable: false,
          ),
          MaterialButton(
            color: CustomColors.bars,
            child: Text(
              'Publish',
              style: TextStyle(color: CustomColors.lightText, fontSize: 16),
            ),
            onPressed: () async {
              // Submit and upload recipe.
              await dao.uploadRecipe(recipe);
              // Redirect to menu screen.
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          )
        ],
      )),
    ));
  }
}
