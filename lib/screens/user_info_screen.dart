import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/screens/sign_in_screen.dart';
import 'package:our_pan/utils/authentication.dart';
import 'package:our_pan/widgets/fab.dart';
import 'package:our_pan/widgets/profile_tab_view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User? user})
      : _user = user,
        super(key: key);

  final User? _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User? _user;
  bool _isSigningOut = false;
  var menuItems = <String>['Sign Out'];

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.bars,
        title: Text('You', style: TextStyle(color: CustomColors.lightText)),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return menuItems.map((String choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
            onSelected: (item) async {
              switch (item) {
                case 'Sign Out':
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context).pushReplacement(_routeToSignInScreen());
                  break;
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(children: [
              Container(
                  child: _user?.photoURL != null
                      ? ClipOval(
                          child: Material(
                            color: CustomColors.background.withOpacity(0.3),
                            child: Image.network(
                              _user!.photoURL!,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        )
                      : ClipOval(
                          child: Material(
                            color: CustomColors.background.withOpacity(0.3),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: CustomColors.background,
                              ),
                            ),
                          ),
                        )),
              SizedBox(width: 15),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  'Hello',
                  style: TextStyle(
                    color: CustomColors.background,
                    fontSize: 26,
                  ),
                ),
                Text(
                  _user!.displayName!,
                  style: TextStyle(
                    color: CustomColors.lightText,
                    fontSize: 26,
                  ),
                )
              ])
            ]),
            SizedBox(height: 24.0),
            ProfileTabView(),
          ],
        ),
      ),
    );
  }
}
