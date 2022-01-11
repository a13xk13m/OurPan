import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/grocery_list_screen.dart';
import 'package:our_pan/screens/home_feed_screen.dart';
import 'package:our_pan/screens/search_screen.dart';
import 'package:our_pan/screens/user_info_screen.dart';
import 'package:our_pan/widgets/fab.dart';

// WARNING: The order of TabItems is important for navigation in this
// widget, always pay attention and don't mess with order.

class Home extends StatefulWidget {
  @override
  State createState() {
    return _HomeState();
  }
}

class _HomeState extends State {
  int _currentIndex = 0;
  static GroceryListModel listModel = GroceryListModel();

  final List _children = [
    HomeFeedScreen(),
    SearchScreen(),
    GroceryListScreen(list: listModel),
    UserInfoScreen(user: FirebaseAuth.instance.currentUser)
  ];

  void onTabTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        floatingActionButton: FAB(
          groceryListModel: listModel,
        ),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: CustomColors.bars,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: CustomColors.lightText,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.yellow))),
          child: BottomNavigationBar(
            onTap: onTabTap,
            currentIndex:
                _currentIndex, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile')
            ],
          ),
        ));
  }
}
