import 'dart:async';
import 'dart:ffi';
import 'package:background_flutter_latest/screens/profile2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'main_drawer.dart';
class Profile1 extends StatefulWidget {
  @override
  _Profile1State createState() => _Profile1State();
}

class _Profile1State extends State<Profile1> {
  final referenceDatabase = FirebaseDatabase.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Position _position;
  StreamSubscription<Position> _subscription;
  Address _address;
  var locationMessage = "";
  var temp="";
  String selected;
  List<Map> _myJson = [
    {"id":'1', "image":"assets/skintones/alternativemedicine.jpg","name":"1"},
    {"id":'2', "image":"assets/skintones/cardiology.jpg","name":"2"},
    {"id":'3', "image":"assets/skintones/gastroenterology.jpg","name":"3"},
    {"id":'4', "image":"assets/skintones/pediatrics.jpg","name":"4"},
    {"id":'5', "image":"assets/skintones/alternativemedicine.jpg","name":"5"},
    {"id":'6', "image":"assets/skintones/alternativemedicine.jpg","name":"6"},
  ];
  final username = TextEditingController();
  final userheight = TextEditingController();
  final userweight = TextEditingController();
  //final userbmi = TextEditingController();
  final formkey = new GlobalKey<FormState>();
  String gender;
  String textHolder = 'Know your BMI';
  double bmi;
  String lat,long,addressesdes;
  void calculateBMI(){
    double height = double.parse(userheight.text);
    double weight = double.parse(userweight.text);
    double heightconverted = (height/100);
    bmi = weight/(heightconverted*heightconverted);
    setState(() {
      textHolder = "Your BMI is : "+bmi.toString().substring(0,4);
    });
    // textHolder = bmi as String;
  }
  void saveToDatabase(){
    final User user = auth.currentUser;
    final ref = referenceDatabase.reference();
    var data=
    {
      "username" : username.text.toString(),
      "userheight" : userheight.text.toString(),
      "userweight" : userweight.text.toString(),
      "usergender" : gender,
      "skin complexion" : selected,
      "latitude" : lat,
      "longitude" : long,
      "address" : addressesdes,
      "uvindex" : temp,
    };
    ref.child("User Data").child(user.uid).child("Profile").set(data).whenComplete(() async{
      await Fluttertoast.showToast(msg: "Uploaded successfully",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile2()));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Profile"),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body:SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),

        child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Tell us About Yourself ',style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black) ,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: username,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        'Select your Gender',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget> [

                      Radio(
                        value: 'Male',
                        groupValue: gender,
                        onChanged: (val){
                          gender = val;
                          setState(() {

                          });
                        },
                      ),
                      Text('Male'
                          ,style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children:<Widget> [

                      Radio(
                        value: 'Female',
                        groupValue: gender,
                        onChanged: (val){
                          gender = val;
                          setState(() {

                          });
                        },
                      ),
                      Text('Female'
                          ,style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: userheight,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Height',
                    hintText: 'Enter height (in cm)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: userweight,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Weight',
                    hintText: 'Enter weight (in Kg)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  children: [
                    Text('$textHolder',
                    style: TextStyle(fontSize: 20),),
                    Spacer(),
                    Container(
                      height: 50.0,
                      width: 50.0,
                      child: FittedBox(
                        child: FloatingActionButton(
                            heroTag: 'btn1',
                            child: Icon(Icons.autorenew),
                            onPressed:(){
                              calculateBMI();
                            },
                      ),
                    ),

                    ),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isDense: true,
                                hint: new Text('Select Skin Complexion'),
                                value: selected,
                                onChanged: (String newValue){
                                  setState(() {
                                    selected = newValue;
                                  });
                                  print (selected);
                                },
                                items: _myJson.map((Map map){
                                  return new DropdownMenuItem<String>(
                                    value: map["name"].toString(),
                                    child: Row(

                                      children: <Widget>[
                                        Image.asset(
                                          map["image"],
                                          width: 25,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(map["name"]),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Addresses ${_address?.addressLine?? '-'}",),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text("UV index"),
                  trailing: Text('$temp'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RaisedButton(
                    child: Center(
                      child: ListTile(
                        leading: FaIcon(FontAwesomeIcons.upload),
                        title: Text('Save'),
                      ),
                    ),
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  splashColor: Colors.deepOrange,
                  padding: EdgeInsets.all(8.0),
                  onPressed: (){
                    if(formkey.currentState.validate()){
                      saveToDatabase();
                    }
                    //formkey.currentState.validate();
                    //getCurrentLocation();
                  },
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: productcategory,
              //     validator: (String value){
              //       if(value.isEmpty){
              //         return 'This field cannot be empty';
              //       }
              //       return null;
              //     },
              //     decoration: InputDecoration(
              //       labelText: 'Product Category',
              //       hintText: 'Enter Product Category',
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(20.0)
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),


    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    const oneSecond = const Duration(seconds: 1);
    var locationoptions = LocationOptions(accuracy: LocationAccuracy.high,distanceFilter: 10);
    _subscription = Geolocator().getPositionStream(locationoptions).listen((Position position) {
      setState(() {
        print(position);
        _position = position;
        lat = position.latitude.toString();
        long = position.longitude.toString();
        getUVIndex(position.latitude.toString(), position.longitude.toString());
        final coordinates = new Coordinates(position.latitude,position.longitude);
        convertCoordinatesToAddress(coordinates).then((value)=> _address=value);
      });
    });
    new Timer.periodic(oneSecond,(Timer t) => setState((){}));
  }

  convertCoordinatesToAddress(Coordinates coordinates) async{
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var result = addresses.first;
    addressesdes = result.toString();
    print(result);
    return result;
  }
  Future getUVIndex(String lats, String longs) async{
    Response response = await get('https://api.weatherbit.io/v2.0/current?lat='+lats+'&lon='+longs+'&key=ac09fe29ca4b4e82875275042501e5d7');
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['data'][0]['uv'].toString();
      print(temp);
    });

  }
}
