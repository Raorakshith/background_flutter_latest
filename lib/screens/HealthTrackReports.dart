import 'dart:ui';

import 'package:background_flutter_latest/screens/PojoClass/CardsData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../constants1.dart';
class ShowMoreCards1 extends StatefulWidget {
  const ShowMoreCards1({Key key}) : super(key: key);

  @override
  ShowMoreCards1State createState() => ShowMoreCards1State();
}

class ShowMoreCards1State extends State<ShowMoreCards1> {
  List<CardsData> postsList = [];
  final reference = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("Track Reports");
  bool checkboxValueCity = false;
  List<String> allCities = ['Alpha', 'Beta', 'Gamma'];
  List<String> selectedCities = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reference.onValue.listen((event) {
      var snap = event.snapshot;
      var Keys = snap.value.keys;
      var Data = snap.value;
      postsList.clear();
      for(var individualkey in Keys)
      {
        CardsData posts = new CardsData(
          Data[individualkey]['date'],
          Data[individualkey]['time'],
          Data[individualkey]['status'],
          Data[individualkey]['testValue'],

        );
        postsList.add(posts);
      }
      setState(() {

      });
      print(postsList);
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Health Track Data"),
        ),

        body:
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: postsList.length == 0 ? new Text("No Data Found",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),) : new ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: postsList.length,
                  itemBuilder: (_, index){
                    var imagepath="";
                    if(postsList[index].status == "Sufficient"){
                      imagepath = "assets/skintones/green.png";
                    }else if(postsList[index].status == "Moderate"){
                      imagepath = "assets/skintones/orange.png";
                    }else{
                      imagepath = "assets/skintones/red.png";
                    }
                    return RecomendPlantCard1(
                      date: postsList[index].date,
                      time: postsList[index].time,
                      status: postsList[index].status,
                      testValue: postsList[index].testValue,
                      image: imagepath,
                    );
                  }
              ),
            ),





      ),
    );
  }
}
class RecomendPlantCard1 extends StatelessWidget {
  const RecomendPlantCard1({
    Key key,
    this.date,
    this.time,
    this.status,
    this.testValue,
    this.image
  }) : super(key: key);

  final String date, time ,status, testValue,image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 10,
      child: Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: 10,
        // bottom: kDefaultPadding * 2.5,
      ),
      width: size.width * 0.9,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('$status',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
              Spacer(),
              Image.asset(image,width: 24,height: 24,)
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              Text('Test Value:    ',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
              Text('$testValue'+' mcg',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Text('Date: '+'$date',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
              Spacer(),
              Text('Time: '+'$time',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
            ],
          ),
        ],
      ),
    ));
  }
}
class _MyDialog extends StatefulWidget {
  _MyDialog({
    this.cities,
    this.selectedCities,
    this.onSelectedCitiesListChanged,
  });

  final List<String> cities;
  final List<String> selectedCities;
  final ValueChanged<List<String>> onSelectedCitiesListChanged;

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<_MyDialog> {
  List<String> _tempSelectedCities = [];

  @override
  void initState() {
    _tempSelectedCities = widget.selectedCities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Filters',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Color(0xFFfab82b),
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.cities.length,
                itemBuilder: (BuildContext context, int index) {
                  final cityName = widget.cities[index];
                  return Container(
                    child: CheckboxListTile(
                        title: Text(cityName),
                        value: _tempSelectedCities.contains(cityName),
                        onChanged: (bool value) {
                          if (value) {
                            if (!_tempSelectedCities.contains(cityName)) {
                              setState(() {
                                _tempSelectedCities.add(cityName);
                              });
                            }
                          } else {
                            if (_tempSelectedCities.contains(cityName)) {
                              setState(() {
                                _tempSelectedCities.removeWhere(
                                        (String city) => city == cityName);
                              });
                            }
                          }
                          widget
                              .onSelectedCitiesListChanged(_tempSelectedCities);
                        }),
                  );
                }),
          ),
        ],
      ),
    );
  }
}