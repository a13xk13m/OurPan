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
  late List<RecipeModel> recipes;
  HomeFeedDao dao = HomeFeedDao();

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    setState(() async {
      recipes = await dao.getRecipeFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background,
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
