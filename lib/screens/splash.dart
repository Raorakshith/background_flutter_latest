import 'package:background_flutter_latest/screens/auth/auth.dart';
import 'package:background_flutter_latest/screens/auth/login1.dart';
import 'package:background_flutter_latest/screens/bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

import 'auth/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watchSignedInUser();
    user.map(
          (value) {
        _navigateToHomeScreen(context);
      },
      empty: (_) {
        _navigateToAuthScreen(context);
      },
      initializing: (_) {},
    );

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SvgPicture.asset('assets/vitamin d logo in svg_new.svg'),

      ),
    );
  }

  void _navigateToAuthScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen1())),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavScreen())),
    );
  }
}