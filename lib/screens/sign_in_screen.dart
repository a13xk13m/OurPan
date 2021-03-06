import 'package:flutter/material.dart';
import 'package:our_pan/res/custom_colors.dart';
import 'package:our_pan/widgets/google_sign_in_button.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                    SizedBox(height: 30),
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/our_pan_logo.png',
                        height: 160,
                      ),
                    ),
                    SizedBox(height: 20),
                    GoogleSignInButton()
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
