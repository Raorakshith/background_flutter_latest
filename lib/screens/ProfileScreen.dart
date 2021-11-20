import 'dart:async';

import 'package:background_flutter_latest/screens/HealthTrackReports.dart';
import 'package:background_flutter_latest/screens/TestReports.dart';
import 'package:background_flutter_latest/screens/main_drawer.dart';
import 'package:background_flutter_latest/screens/my_bottom_nav_bar.dart';
import 'package:background_flutter_latest/screens/profile1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'asksymptoms.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name="",height="",weight="",gender="";
  double heightconv,weightconv,bmi=0;
  final reference = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("Profile");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const oneSecond = const Duration(seconds: 1);
    reference.once().then((DataSnapshot data){
      name = data.value.username;
      height = data.value.userheight;
      weight = data.value.userweight;
      gender = data.value.usergender;
      heightconv = double.parse(height)/100;
      weightconv = double.parse(weight);
      bmi = weightconv/(heightconv*heightconv);
      print(name);
      Fluttertoast.showToast(msg: (data.value),toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
    }).whenComplete(() => {
    // setState(() {
    //
    // })
    });
    new Timer.periodic(oneSecond,(Timer t) => setState((){}));
  }
  @override
  Widget build(BuildContext context) {
    reference.once().then((DataSnapshot data){
      print(data.value);
      name = data.value['username'];
      height = data.value['userheight'];
      weight = data.value['userweight'];
      gender = data.value['usergender'];
      heightconv = double.parse(height)/100;
      weightconv = double.parse(weight);
      bmi = weightconv/(heightconv*heightconv);
      print(name);
      Fluttertoast.showToast(msg: (data.value),toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
    }).whenComplete(() => {
      // setState(() {
      //
      // })
    });
    return Scaffold(
      drawer: MainDrawer(),
        bottomNavigationBar: MyBottomNavBar(),
        body: SafeArea(
          child: Column(

            children: [

              Container(
                width: double.infinity,
                height: 300,
                child: Image(image: AssetImage('assets/skintones/testimageforprofile1.png'),fit: BoxFit.fill,),
                // child: Container(
                //   width: double.infinity,
                //   height: 200,
                //   child: Container(
                //     alignment: Alignment(0.0,2.5),
                //     child: CircleAvatar(
                //       backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/loginpage-5c70d.appspot.com/o/opaque%20new%20logo%20png.png?alt=media&token=c8210da2-b911-44a9-bcef-d2ba61904d9d'),
                //       radius: 60.0,
                //     ),
                //   ),
                // ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                '$name'
                ,style: TextStyle(
                  fontSize: 25.0,
                  color:Colors.blueGrey,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w400
              ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Bengaluru, India"
                ,style: TextStyle(
                  fontSize: 18.0,
                  color:Colors.black45,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300
              ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Height: "+'$height'+"cm"+"  |  "+"Weight: "+'$weight'+"kg"
                ,style: TextStyle(
                  fontSize: 15.0,
                  color:Colors.black45,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300
              ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile1(),
                    ),
                  );
                },
              child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                  elevation: 2.0,
                  color: Color(0xffe11e2b),
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 30),
                      child: Text("Edit Profile",style: TextStyle(
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),),)
              ),),
              SizedBox(
                height: 15,
              ),
              Text(
                "Gender:  "+'$gender'
                ,style: TextStyle(
                  fontSize: 18.0,
                  color:Colors.black45,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300
              ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("BMI",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600
                              ),),
                            SizedBox(
                              height: 7,
                            ),
                            Text(bmi.toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w300
                              ),)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text("|",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 44.0,
                                  fontWeight: FontWeight.w600
                              ),),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                        Column(
                          children: [
                            Text("Vitamin-D",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600
                              ),),
                            SizedBox(
                              height: 7,
                            ),
                            Text("0 ng/ml",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w300
                              ),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowMoreCards(),
                        ),
                      );
                    },
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.pink,Colors.redAccent]
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 100.0,maxHeight: 40.0,),
                        alignment: Alignment.center,
                        child: Text(
                          "Test Results",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowMoreCards1(),
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CreateCards(),
                      //   ),
                      // );
                    },
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.pink,Colors.redAccent]
                        ),
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 100.0,maxHeight: 40.0,),
                        alignment: Alignment.center,
                        child: Text(
                          "Health Track",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );  }
}
