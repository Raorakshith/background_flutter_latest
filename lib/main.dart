import 'dart:io';

import 'package:flutter/material.dart';

import 'package:background_flutter_latest/config/palette.dart';
import 'package:background_flutter_latest/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // Future<void> startServiceInPlatform() async {
  //   if(Platform.isAndroid){
  //     var methodChannel = MethodChannel("my.login_page.vitamind.messages");
  //     String data = await methodChannel.invokeMethod("startService");
  //     debugPrint(data);
  //   }
  // }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LitAuthInit(
      authProviders: AuthProviders(
        emailAndPassword: true, // enabled by default
        google: true,
        apple: true,
        twitter: true,
        github: true,
        anonymous: true,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.muliTextTheme(),
          accentColor: Palette.darkOrange,
          appBarTheme: const AppBarTheme(
            brightness: Brightness.dark,
            color: Palette.darkBlue,
          ),
        ),
        // home: LitAuthState(
        //   authenticated: HomeScreen(),
        //   unauthenticated: AuthScreen(),
        // ),
        home: const SplashScreen(),
      ),
    );
  }
}
