
import 'package:background_flutter_latest/screens/ChatSymptoms.dart';
import 'package:background_flutter_latest/screens/asksymptoms.dart';
import 'package:background_flutter_latest/screens/bluetooth.dart';
import 'package:background_flutter_latest/screens/bottom_nav_screen.dart';
import 'package:background_flutter_latest/screens/comparison.dart';
import 'package:background_flutter_latest/screens/navigationspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import '../constants1.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({
     Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: kDefaultPadding * 2,
        right: kDefaultPadding * 2,
        bottom: kDefaultPadding,
      ),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -10),
            blurRadius: 35,
            color: kPrimaryColor.withOpacity(0.38),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           // IconButton(
           //    iconSize: 30,
           //    splashColor: Colors.blue,
           //    icon: Image.asset('assets/home.png'),
           //    onPressed: () {}
           //
           //  ),
          RawMaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavScreen(),
                ),
              );
            }, //do your action
            elevation: 1.0,
            constraints: BoxConstraints(), //removes empty spaces around of icon
            shape: CircleBorder(), //circular button
            fillColor: Colors.white, //background color
            splashColor: Colors.amber,
            highlightColor: Colors.amber,
            child: Image.asset(
              "assets/home.png",
              width: 30,
              height: 30,
            ),
            padding: EdgeInsets.all(8),
          ),
          RawMaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatSymptoms(),
                ),
              );
            }, //do your action
            elevation: 1.0,
            constraints: BoxConstraints(), //removes empty spaces around of icon
            shape: CircleBorder(), //circular button
            fillColor: Colors.white, //background color
            splashColor: Colors.amber,
            highlightColor: Colors.amber,
            child: Image.asset(
              "assets/reading.png",
              width: 40,
              height: 40,
            ),
            padding: EdgeInsets.all(8),
          ),
          RawMaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BluetoothStates(),
                ),
              );
            }, //do your action
            elevation: 1.0,
            constraints: BoxConstraints(), //removes empty spaces around of icon
            shape: CircleBorder(), //circular button
            fillColor: Colors.white, //background color
            splashColor: Colors.amber,
            highlightColor: Colors.amber,
            child: Image.asset(
              "assets/glucose-meter.png",
              width: 40,
              height: 40,
            ),
            padding: EdgeInsets.all(8),
          ),
          RawMaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Compare(),
                ),
              );
            }, //do your action
            elevation: 1.0,
            constraints: BoxConstraints(), //removes empty spaces around of icon
            shape: CircleBorder(), //circular button
            fillColor: Colors.white, //background color
            splashColor: Colors.amber,
            highlightColor: Colors.amber,
            child: Image.asset(
              "assets/evaluation.png",
              width: 40,
              height: 40,
            ),
            padding: EdgeInsets.all(8),
          ),

        ],
      ),
    );
  }
}
