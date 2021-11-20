import 'package:background_flutter_latest/screens/ChatSymptoms.dart';
import 'package:background_flutter_latest/screens/asksymptoms.dart';
import 'package:background_flutter_latest/screens/bluetooth.dart';
import 'package:background_flutter_latest/screens/comparison.dart';
import 'package:background_flutter_latest/screens/my_bottom_nav_bar.dart';
import 'package:background_flutter_latest/screens/navigationspage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants1.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List _screens = [
    NavPages(),
    AskSymptoms(),
    BluetoothStates(),
    Compare()
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
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
              onPressed: () {}, //do your action
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
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index)=> setState(() => _currentIndex = index),
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.grey,
      //   elevation: 0.0,
      //   items: [Icons.home,Icons.assignment_ind,Icons.bluetooth_connected_rounded,Icons.event_note]
      //       .asMap()
      //       .map((key, value) => MapEntry(
      //       key,
      //       BottomNavigationBarItem(
      //     title: Text(''),
      //     icon: Container(
      //       padding: const EdgeInsets.symmetric(
      //         vertical: 6.0,
      //         horizontal: 16.0,
      //       ),
      //       decoration: BoxDecoration(color: _currentIndex == key ? Colors.blue[600]:Colors.transparent,borderRadius: BorderRadius.circular(20.0),),
      //       child: Icon(value),
      //     ),
      //   ),
      //   ))
      //   .values
      //   .toList(),
      //   ),
    );
  }
}
