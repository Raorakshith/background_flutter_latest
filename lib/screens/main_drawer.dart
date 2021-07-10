import 'package:background_flutter_latest/screens/FoodData.dart';
import 'package:background_flutter_latest/screens/asksymptoms.dart';
import 'package:background_flutter_latest/screens/bluetooth.dart';
import 'package:background_flutter_latest/screens/profile1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'bottom_nav_screen.dart';
import 'recommendations.dart';

class MainDrawer extends StatelessWidget {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 30,bottom: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/loginpage-5c70d.appspot.com/o/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png?alt=media&token=a925cb9b-a030-4d29-b581-9edae243a0e8'),
                      fit: BoxFit.fill),
                    ),
                  ),
                  Text('UserName',style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  ),
                  Text('Useremail@gmail.com',style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
                ],
              ),
            ),
          ),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile1()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => AskSymptoms()));
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
            leading: Icon(Icons.logout),
            title: Text(
              'LogOut',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: (){
             // Navigator.push(context, MaterialPageRoute(builder: (context) => Recommend()));
              _signOut();
            },
          ),
        ],
      ),
    );
  }
}
