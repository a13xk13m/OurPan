import 'package:flutter/material.dart';
import 'package:our_pan/utils/tab_item.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(tabIcon[TabItem.home]),
          label: tabName[TabItem.home],
        ),
        BottomNavigationBarItem(
          icon: Icon(tabIcon[TabItem.search]),
          label: tabName[TabItem.search],
        ),
        BottomNavigationBarItem(
          icon: Icon(tabIcon[TabItem.list]),
          label: tabName[TabItem.list],
        ),
        BottomNavigationBarItem(
          icon: Icon(tabIcon[TabItem.profile]),
          label: tabName[TabItem.profile],
        )
      ],
      onTap: (index) => onSelectTab(
        index,
      ),
      currentIndex: currentTab.index,
      selectedItemColor: Colors.red,
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      icon: Icon(tabIcon[tabItem]),
      label: tabName[tabItem],
    );
  }
}
