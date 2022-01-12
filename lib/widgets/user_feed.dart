import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';

// Feed that displays a list of users.
// TODO: Currently only displays the UID, more data needs to be merged/
// query process fixed.
class UserFeed extends StatefulWidget {
  late final List<String> users;

  UserFeed({required this.users});

  @override
  State<StatefulWidget> createState() {
    return _UserFeedState();
  }
}

class _UserFeedState extends State<UserFeed> {
  late List<String> users = <String>[];

  @override
  void initState() {
    super.initState();
    users = widget.users;
  }

  @override
  Widget build(BuildContext context) {
    return users.length > 0
        ? ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Container(
                  color: CustomColors.bars,
                  child: Text(users[index],
                      style: TextStyle(
                          fontSize: 16, color: CustomColors.lightText)));
            })
        : Center(
            child: Text('Search for a user in the box above.',
                style: TextStyle(fontSize: 18, color: CustomColors.darkText)));
  }
}
