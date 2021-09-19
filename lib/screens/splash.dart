import 'package:background_flutter_latest/screens/auth/auth.dart';
import 'package:background_flutter_latest/screens/auth/login1.dart';
import 'package:background_flutter_latest/screens/bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

import 'auth/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
    builder: (context) => const SplashScreen(),
  );

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

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _navigateToAuthScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen1())),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavScreen())),
    );
  }
}