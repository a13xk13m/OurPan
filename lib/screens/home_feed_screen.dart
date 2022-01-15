import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/utils/home_feed_dao.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/widgets/recipe_feed.dart';

class HomeFeedScreen extends StatefulWidget {
  @override
  _HomeFeedScreenState createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  List<RecipeModel> recipes = [];
  HomeFeedDao dao = HomeFeedDao();

  @override
  void initState() {
    super.initState();
    // Get recipes then force a state update to rerender feed.
    // There must be a better way to do this.
    getRecipes();
  }

  Future<void> getRecipes() async {
    recipes = await dao.getRecipeFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.bars,
          title: Text('Home', style: TextStyle(color: CustomColors.lightText))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [RecipeFeed(recipes: recipes)],
          ),
        ),
      ),
    );
  }
}
