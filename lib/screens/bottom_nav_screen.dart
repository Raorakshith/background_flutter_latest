import 'package:background_flutter_latest/screens/asksymptoms.dart';
import 'package:background_flutter_latest/screens/bluetooth.dart';
import 'package:background_flutter_latest/screens/comparison.dart';
import 'package:background_flutter_latest/screens/navigationspage.dart';
import 'package:flutter/material.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index)=> setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0.0,
        items: [Icons.home,Icons.assignment_ind,Icons.bluetooth_connected_rounded,Icons.event_note]
            .asMap()
            .map((key, value) => MapEntry(
            key,
            BottomNavigationBarItem(
          title: Text(''),
          icon: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(color: _currentIndex == key ? Colors.blue[600]:Colors.transparent,borderRadius: BorderRadius.circular(20.0),),
            child: Icon(value),
          ),
        ),
        ))
        .values
        .toList(),
        ),
    );
  }
}
