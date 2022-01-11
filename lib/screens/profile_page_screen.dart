import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required UserCredential user})
      : _user = user,
        super(key: key);

  final UserCredential _user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> profileTabs = <Tab>[
    Tab(icon: const Icon(Icons.fastfood, color: CustomColors.bars)),
    Tab(icon: const Icon(Icons.text_snippet, color: CustomColors.bars)),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: profileTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (SizedBox(
        height: 200,
        child: Column(
          children: [
            Container(
                child: TabBar(
              controller: _tabController,
              tabs: profileTabs,
            )),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: profileTabs.map((Tab tab) {
                return (tab);
              }).toList(),
            )),
          ],
        )));
  }
}
