import 'dart:async';
import 'dart:ffi';
import 'package:background_flutter_latest/screens/NextPage.dart';
import 'package:background_flutter_latest/screens/my_bottom_nav_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../custom_dialog_box.dart';
import 'main_drawer.dart';
class AskSymptoms extends StatefulWidget {
  @override
  _AskSymptomsState createState() => _AskSymptomsState();
}

class _AskSymptomsState extends State<AskSymptoms> {
  ScrollController controller = new ScrollController();
  bool _isvisible1 = false;
  bool _isvisible2 = false;
  bool _isvisible3 = false;
  bool _isvisible4 = false;
  bool _isvisible5 = false;
  bool _isvisible6 = false;
  bool _isvisible7 = false;
  bool _isvisible8 = false;

  int count = 0;
  void showopt2(){
    setState(() {
      _isvisible1 = !_isvisible1;
      controller.jumpTo(controller.position.maxScrollExtent);
    });

  }
  void showopt3(){
    setState(() {
      _isvisible2 = !_isvisible2;
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }
  void showopt4(){
    setState(() {
      _isvisible3 = !_isvisible3;
    });
    controller.jumpTo(controller.position.maxScrollExtent);
  }
  void showopt5(){
    setState(() {
      _isvisible4 = !_isvisible4;

    });
    controller.jumpTo(controller.position.maxScrollExtent);
  }
  void showopt6(){
    setState(() {
      _isvisible5 = !_isvisible5;
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }
  void showopt7(){
    setState(() {
      _isvisible6 = !_isvisible6;
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }
  void showopt8(){
    setState(() {
      _isvisible8 = !_isvisible8;
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title:new Text('Ask Symptoms'),
        centerTitle:true,
      ),
      drawer: MainDrawer(),
      bottomNavigationBar: MyBottomNavBar(),
      body: SingleChildScrollView(
        controller: controller,
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),

        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 120.0,
                    width: 230.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      border: Border(
                        left: BorderSide(
                          color: Colors.blue.shade100,
                          width: 15.0,
                        ),
                        top: BorderSide(
                          color: Colors.blue.shade300,
                          width: 10.0,
                        ),
                        right: BorderSide(
                          color: Colors.blue.shade500,
                          width: 5.0,
                        ),
                       bottom: BorderSide(
                         color: Colors.blue.shade800,
                         width: 3.0,
                       ) ,
                      ),
                      //border: Border.all(color: Colors.deepPurple),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text('Do you experience Bone Ache / Back Aches',textAlign: TextAlign.center,),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text('Yes'),
                                onPressed: (){
                                  showopt2();
                                  count++;
                                },
                                textColor: Colors.green,
                                highlightElevation: 10.0,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text('No'),
                                onPressed: (){
                                  showopt2();
                                },
                                textColor: Colors.red,
                                highlightElevation: 10.0,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _isvisible1,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150.0,
                      width: 230.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        border: Border(
                          left: BorderSide(
                            color: Colors.red.shade100,
                            width: 15.0,
                          ),
                          top: BorderSide(
                            color: Colors.red.shade300,
                            width: 10.0,
                          ),
                          right: BorderSide(
                            color: Colors.red.shade500,
                            width: 5.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.red.shade800,
                            width: 3.0,
                          ) ,
                        ),
                        //border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('Do you experience Chronic Fatigue \n (lack of sleep or excess sleep)',textAlign: TextAlign.center,),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    showopt3();
                                    count++;
                                  },
                                  textColor: Colors.green,
                                  highlightElevation: 10.0,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('No'),
                                  onPressed: showopt3,
                                  textColor: Colors.red,
                                  highlightElevation: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isvisible2,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150.0,
                      width: 230.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        border: Border(
                          left: BorderSide(
                            color: Colors.yellow.shade100,
                            width: 15.0,
                          ),
                          top: BorderSide(
                            color: Colors.yellow.shade300,
                            width: 10.0,
                          ),
                          right: BorderSide(
                            color: Colors.yellow.shade500,
                            width: 5.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.yellow.shade800,
                            width: 3.0,
                          ) ,
                        ),
                        //border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('Do you experience Fragile Bones',textAlign: TextAlign.center,),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    showopt4();
                                    count++;
                                  },
                                  textColor: Colors.green,
                                  highlightElevation: 10.0,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('No'),
                                  onPressed: showopt4,
                                  textColor: Colors.red,
                                  highlightElevation: 10.0,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isvisible3,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150.0,
                      width: 230.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        border: Border(
                          left: BorderSide(
                            color: Colors.green.shade100,
                            width: 15.0,
                          ),
                          top: BorderSide(
                            color: Colors.green.shade300,
                            width: 10.0,
                          ),
                          right: BorderSide(
                            color: Colors.green.shade500,
                            width: 5.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.green.shade800,
                            width: 3.0,
                          ) ,
                        ),
                        //border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('Do you experience Frequent Cold / Infections',textAlign: TextAlign.center,),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    showopt5();
                                    count++;
                                  },
                                  textColor: Colors.green,
                                  highlightElevation: 10.0,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('No'),
                                  onPressed: showopt5,
                                  textColor: Colors.red,
                                  highlightElevation: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isvisible4,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150.0,
                      width: 230.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        border: Border(
                          left: BorderSide(
                            color: Colors.purple.shade100,
                            width: 15.0,
                          ),
                          top: BorderSide(
                            color: Colors.purple.shade300,
                            width: 10.0,
                          ),
                          right: BorderSide(
                            color: Colors.purple.shade500,
                            width: 5.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.purple.shade800,
                            width: 3.0,
                          ) ,
                        ),
                        //border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('Do you experience Depressed Mood',textAlign: TextAlign.center,),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    showopt6();
                                    count++;
                                  },
                                  textColor: Colors.green,
                                  highlightElevation: 10.0,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('No'),
                                  onPressed: showopt6,
                                  textColor: Colors.red,
                                  highlightElevation: 10.0,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isvisible5,
              child:  Row(
                children: <Widget>[
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150.0,
                      width: 230.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.brown[100],
                        border: Border(
                          left: BorderSide(
                            color: Colors.brown.shade100,
                            width: 15.0,
                          ),
                          top: BorderSide(
                            color: Colors.brown.shade300,
                            width: 10.0,
                          ),
                          right: BorderSide(
                            color: Colors.brown.shade500,
                            width: 5.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.brown.shade800,
                            width: 3.0,
                          ) ,
                        ),
                        //border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('Do you experience Slow Wound Healing',textAlign: TextAlign.center,),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    showopt7();
                                    count++;
                                  },
                                  textColor: Colors.green,
                                  highlightElevation: 10.0,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: showopt7,
                                  child: Text('No'),
                                  textColor: Colors.red,
                                  highlightElevation: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isvisible6,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150.0,
                      width: 230.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        border: Border(
                          left: BorderSide(
                            color: Colors.indigo.shade100,
                            width: 15.0,
                          ),
                          top: BorderSide(
                            color: Colors.indigo.shade300,
                            width: 10.0,
                          ),
                          right: BorderSide(
                            color: Colors.indigo.shade500,
                            width: 5.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.indigo.shade800,
                            width: 3.0,
                          ) ,
                        ),
                        //border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('Do you experience Poor Muscle Strength ?',textAlign: TextAlign.center,),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    showopt8();
                                    count++;
                                  },
                                  textColor: Colors.green,
                                  highlightElevation: 10.0,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text('No'),
                                  onPressed: showopt8,
                                  textColor: Colors.red,
                                  highlightElevation: 10.0,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isvisible8,
              child:Row(
                children:<Widget>[
                  Spacer(),
                  Container(
                    height: 50.0,
                    width: 50.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        heroTag: 'btn1',
                        child: Icon(Icons.done),
                        onPressed:(){
                          //calculateBMI();
                          if(count >= 3){
                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return CustomDialogBox(
                                    title: "Chat Result",
                                    descriptions: "You have selected some symptoms of Vitamin-D. You can calculate your Vitamin-D and verify for better health",
                                    text: "Check Now",
                                    img: Image.asset("assets/mid.png"),
                                  );
                                }
                            );
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
                          }
                        },
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
