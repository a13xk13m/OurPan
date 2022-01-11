import 'package:flutter/material.dart';

enum TabItem { home, search, list, profile }

const Map<TabItem, String> tabName = {
  TabItem.home: 'Home',
  TabItem.search: 'Search',
  TabItem.list: 'Grocery List',
  TabItem.profile: 'Profile',
};

const Map<TabItem, IconData> tabIcon = {
  TabItem.home: Icons.home,
  TabItem.search: Icons.search,
  TabItem.list: Icons.list,
  TabItem.profile: Icons.face,
};
