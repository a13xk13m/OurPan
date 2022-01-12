import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/utils/recipe_dao.dart';
import 'package:our_pan/widgets/profile_recipe_feed.dart';
import 'package:our_pan/widgets/profile_saved_feed.dart';
import 'package:our_pan/widgets/recipe_feed.dart';
import 'package:our_pan/widgets/tag_feed.dart';
import 'package:our_pan/widgets/user_feed.dart';

// Tab view of a users profile that switches between different tabs.
// Requires UID from firebase to fetch data.
// By default all children are editable.
class SearchTabView extends StatefulWidget {
  late List<RecipeModel> recipes;
  late List<String> users;
  late List<String> tags;
  SearchTabView(
      {required this.recipes, required this.users, required this.tags});

  @override
  State<SearchTabView> createState() => _SearchTabViewState();
}

class _SearchTabViewState extends State<SearchTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<RecipeModel> recipes;
  late List<String> users;
  late List<String> tags;

  @override
  void initState() {
    super.initState();
    recipes = widget.recipes;
    users = widget.users;
    tags = widget.tags;
    _tabController = TabController(vsync: this, length: searchTabs.length);
    views = <Widget>[
      RecipeFeed(
        recipes: recipes,
      ),
      UserFeed(users: users),
      TagFeed(tags: tags)
    ];
  }

  static const List<Tab> searchTabs = <Tab>[
    Tab(icon: const Icon(Icons.fastfood, color: CustomColors.bars)),
    Tab(icon: const Icon(Icons.person, color: CustomColors.bars)),
    Tab(icon: const Icon(Icons.tag, color: CustomColors.bars)),
  ];
  static List<Widget> views = [];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Expanded(
        child: Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: searchTabs,
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: views.map((Widget tab) {
            return (tab);
          }).toList(),
        )),
      ],
    )));
  }
}
