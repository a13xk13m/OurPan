import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/widgets/profile_recipe_feed.dart';
import 'package:our_pan/widgets/profile_saved_feed.dart';

// Tab view of a users profile that switches between different tabs.
// Requires UID from firebase to fetch data.
// By default all children are editable.
class ProfileTabView extends StatefulWidget {
  late bool editable;

  ProfileTabView({this.editable = true});
  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool editable;
  static String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    editable = widget.editable;
    _tabController = TabController(vsync: this, length: profileTabs.length);
    views = <Widget>[
      ProfileRecipeFeed(
        uid: uid,
      ),
      ProfileSavedFeed(),
    ];
  }

  static const List<Tab> profileTabs = <Tab>[
    Tab(icon: const Icon(Icons.fastfood, color: CustomColors.bars)),
    Tab(icon: const Icon(Icons.bookmark, color: CustomColors.bars)),
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
          tabs: profileTabs,
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
