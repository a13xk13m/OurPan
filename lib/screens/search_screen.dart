import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/utils/search_dao.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchDao dao = SearchDao();
  String searchQuery = '';
  List<RecipeModel> recipes = [];
  List<String> users = [];
  List<String> tags = [];
  TextEditingController searchCon = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Runs a search and updates the results map.
  Future<void> runSearch(String queryString) async {
    setState(() async {
      recipes = await dao.recipeSearch(queryString);
      users = await dao.userSearch(queryString);
      tags = await dao.tagSearch(queryString);
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
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchCon,
                      onChanged: (query) async {
                        // Run search.
                        runSearch(query);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
