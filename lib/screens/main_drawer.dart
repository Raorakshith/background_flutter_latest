import 'dart:async';

import 'package:background_flutter_latest/screens/FoodData.dart';
import 'package:background_flutter_latest/screens/ProfileScreen.dart';
import 'package:background_flutter_latest/screens/TinderLikeSwipe.dart';
import 'package:background_flutter_latest/screens/asksymptoms.dart';
import 'package:background_flutter_latest/screens/bluetooth.dart';
import 'package:background_flutter_latest/screens/profile1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../showuvcaptureddata.dart';
import 'bottom_nav_screen.dart';
import 'recommendations.dart';

class MainDrawer extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final referenceDatabase = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("Profile");
String imageUrl, username, userdata;
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    referenceDatabase.child("username").once().then((DataSnapshot data){
      username = data.value;
    });
    return Drawer(
      child: SingleChildScrollView(child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    margin: EdgeInsets.only(top: 30,bottom: 10),
                    child: Image.asset('assets/skintones/lg1.jpg'),
                    //child: SvgPicture.asset('assets/vitamin d logo in svg_new.svg'),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,

                      //
                    ),
                  ),
                  Text('VitaD',style: TextStyle(
                    fontSize: 22,
                    color: Colors.deepOrange,
                  ),
                  ),

                ],
              ),
            ),
          ),
          Divider(
            thickness: 20,
            color: Colors.deepOrange,
          ),
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00A8D5),
                const Color(0xFFFFFFFF),
              ],),
            // image: DecorationImage(image: AssetImage('assets/skintones/gradientforfood1.png'),fit: BoxFit.cover)
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.bluetooth_connected_rounded),
                title: Text(
                  'Connect Device',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothStates()));
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment_ind_rounded),
                title: Text(
                  'Assess Yourself',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SwipeSymptomsCard()));
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment_ind_rounded),
                title: Text(
                  'Food Chart',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FoodData()));
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment_ind_rounded),
                title: Text(
                  'Terms and conditions',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => FoodData()));
                },
              ),
            ],
          )
        ),

          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: Text(
          //     'LogOut',
          //     style: TextStyle(
          //       fontSize: 18,
          //     ),
          //   ),
          //   onTap: (){
          //    Navigator.push(context, MaterialPageRoute(builder: (context) => SwipeSymptomsCard()));
          //    //  _signOut();
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: Text(
          //     'Check UV Data',
          //     style: TextStyle(
          //       fontSize: 18,
          //     ),
          //   ),
          //   onTap: (){
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => ShowCapturedUVdata()));
          //     // _signOut();
          //   },
          // ),
        ],
      ),
      ),
    );
  }
}
