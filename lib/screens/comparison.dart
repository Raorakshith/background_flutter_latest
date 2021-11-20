import 'dart:async';
import 'dart:ffi';
import 'dart:ui';
import 'package:background_flutter_latest/screens/FoodData.dart';
import 'package:background_flutter_latest/screens/Posts1.dart';
import 'package:background_flutter_latest/screens/SunData.dart';
import 'package:background_flutter_latest/screens/UVdatalist.dart';
import 'package:background_flutter_latest/screens/my_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../custom_dialog_box.dart';
import 'UVdata.dart';
import 'main_drawer.dart';
class Compare extends StatefulWidget {
  @override
  _CompareState createState() => _CompareState();
}

class _CompareState extends State<Compare> {
  String textHolder = '0',currentdate;
  final FirebaseAuth auth = FirebaseAuth.instance;
  double count = 0;
  double count1 = 0;
  List<Posts1> postsList = [];
  List<SunData> sunlightDataList = [];
  List<UVdata> uvdata = [];
  List<UVdatalist> uvdatalist = [];
  List<String> time = ['12-1','1-2','2-3','3-4','4-5','5-6','6-7','7-8','8-9','9-10','10-11','11-12'];

  final exposuretime = TextEditingController();
  final exposureduration = TextEditingController();
  final reference = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("Food Datas");
  final reference1 = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("SunTrack Data");
  final reference2 = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("UV INDEX");
  final referenceDatabase = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("Profile");
  final referenceDatabase1 = FirebaseDatabase.instance.reference().child("Sunlight Data");
  final referenceDatabase2 = FirebaseDatabase.instance.reference().child("VitaminD Exposure");
  final reference4 = FirebaseDatabase.instance.reference().child("UVSunData");
  final reference14 = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("Track Reports");
var selected, selectedtime;
  Position _position;
  StreamSubscription<Position> _subscription;
  Address _address;
  var locationMessage = "",skintype="",uvindexstring="";
  var temp="0",result="";
  String lat,long,addressesdes;
  TextEditingController _textFieldController = TextEditingController();
  String _selectedTime,_selectedTime1;


  // We don't need to pass a context to the _show() function
  // You can safety use context as below
  Future<void> _show() async {
    final TimeOfDay result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now(), builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      );
    },
    );
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
        exposuretime.text = _selectedTime;
      });
    }
  }
  Future<void> _show1() async {
    final TimeOfDay result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now(),builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      );
    },
    );
    if (result != null) {
      setState(() {
        _selectedTime1 = result.format(context);
        exposureduration.text = _selectedTime1;
      });
    }
  }
  void calculateUV(){
    final startTime = DateTime(10, 30);
    final currentTime = DateTime.now();

    final diff_dy = currentTime.difference(startTime).inDays;
    final diff_hr = currentTime.difference(startTime).inHours;
    final diff_mn = currentTime.difference(startTime).inMinutes;
    final diff_sc = currentTime.difference(startTime).inSeconds;
    print(currentTime.hour);
    for(int i=0;i<uvdata.length;i++){
      print(uvdata[i].time.substring(0,2));
      if(uvdata[i].time.substring(0,2).contains(_selectedTime1.substring(0,2))){
        print("entered");
        setState(() {
          textHolder = uvdata[i].uvindex;
        });
        print(uvdata[i].uvindex);
      }
    }
    print(diff_dy);
    print(diff_hr);
    print(diff_mn);
    print(diff_sc);
  }
  void saveToDatabase(valuesoftemp,statusvalue){
    var data=
    {
      "testValue": valuesoftemp,
      "status": statusvalue,
      "date": DateFormat('yMd').format(DateTime.now()),
      "time":DateFormat('hh:mm:ss').format(DateTime.now()),
    };
    reference14.child(DateFormat('hh:mm:ss').format(DateTime.now()).toString()).set(data).whenComplete(() async{
      await Fluttertoast.showToast(msg: "Test Report saved",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
    });

  }
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context,setState){
                return AlertDialog(
                  title: Text('TextField AlertDemo'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //position
                    mainAxisSize: MainAxisSize.min,
                    // wrap content in flutter
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onTap: _show,
                          controller: exposuretime,
                          validator: (String value){
                            if(value.isEmpty){
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Sunlight Exposure Start Time',
                            hintText: 'Enter Time (AM/PM)',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                        ),
                      ),
                      Icon(Icons.wifi_protected_setup),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onTap: _show1,
                          controller: exposureduration,
                          validator: (String value){
                            if(value.isEmpty){
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Sunlight Exposure End Time',
                            hintText: 'Enter Time',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed:(){ _displayDialogForSkinType(context);},
                          child: Text(
                            'Select Cloud Type',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed:(){ _displayDialogForTime(context);},
                          child: Text(
                            'Select Time',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('UV index',
                              style: TextStyle(fontSize: 20),),
                            Spacer(),
                            Container(
                              height: 50.0,
                              width: 50.0,
                              child: FittedBox(
                                child: FloatingActionButton(
                                  heroTag: 'btn1',
                                  child: Icon(Icons.autorenew),
                                  onPressed:() {
                                    // final startTime = DateTime(10, 30);
                                    // final currentTime = DateTime.now();
                                    //
                                    // final diff_dy = currentTime.difference(startTime).inDays;
                                    // final diff_hr = currentTime.difference(startTime).inHours;
                                    // final diff_mn = currentTime.difference(startTime).inMinutes;
                                    // final diff_sc = currentTime.difference(startTime).inSeconds;
                                    //print(currentTime.hour);
                                    for (int i = 0; i < uvdata.length; i++) {
                                      print(uvdata[i].time.substring(0, 2));
                                      if (uvdata[i].time.substring(0, 2)
                                          .contains(
                                          _selectedTime1.substring(0, 2))) {
                                        print("entered");
                                        setState(() {
                                          textHolder = uvdata[i].uvindex;
                                        });
                                        print(uvdata[i].uvindex);
                                      }
                                    }
                                  }
                                    // print(diff_dy);
                                    // print(diff_hr);
                                    // print(diff_mn);
                                    // print(diff_sc);                                  },
                                ),
                              ),

                            ),
                            Spacer(),
                            Text(textHolder,
                              style: TextStyle(fontSize: 20),)
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('ADD ROUTINE'),
                      onPressed: () {
                        String expdut;
                        var format = DateFormat("HH:mm");
                        var one = format.parse(_selectedTime);
                        var two = format.parse(_selectedTime1);
                        var key = reference1.push().key;
                        String durationexp = "${two.difference(one).inMinutes}";
                        print("${two.difference(one).inMinutes}");
                        referenceDatabase2.child(skintype).child(textHolder.substring(0,1)).once().then((DataSnapshot data){
                           expdut = (double.parse(data.value)*double.parse(durationexp)).toStringAsFixed(2);
                          // totals = comvalue+count;
                          // result = totals.toStringAsFixed(2);
                          Fluttertoast.showToast(msg: (data.value)+count.toString(),toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
                        }).whenComplete(() => {
                        reference1.child(key).set({'starttime':_selectedTime,'endtime':_selectedTime1,'uvindex':textHolder,'exposureduration':durationexp, 'exposurevalue':expdut,'id':key}).whenComplete(() async{
                        await Fluttertoast.showToast(msg: "Added data"+exposuretime.value.toString(),toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile2()));
                        Navigator.of(context).pop();
                        })
                        });
                        // reference1.push().set({'starttime':_selectedTime,'endtime':_selectedTime1,'uvindex':textHolder,'exposure duration':durationexp}).whenComplete(() async{
                        //   await Fluttertoast.showToast(msg: "Added data"+exposuretime.value.toString(),toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
                        //   //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile2()));
                        //   Navigator.of(context).pop();
                        // });

                      },
                    )
                  ],
                );
          });

        });
  }
  _displayDialogTime(BuildContext context) async {
    List<UVdatalist> _tempSelectedCities = [];
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context,setState){
                return AlertDialog(
                  title: Text('TextField AlertDemo'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //position
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              RaisedButton(
                                  onPressed: (){},
                              color: Colors.grey,
                              child: Text('AM',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
                              RaisedButton(
                                onPressed: (){},
                                color: Colors.grey,
                                child: Text('PM',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),)
                            ],
                          ),
                          // Text(
                          //   'Time Select',
                          //   style: TextStyle(fontSize: 18.0, color: Colors.black),
                          //   textAlign: TextAlign.center,
                          // ),
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
                            itemCount: uvdatalist.length,
                            itemBuilder: (BuildContext context, int index) {
                              final cityName = uvdatalist[index].time;
                              return Container(
                                child: CheckboxListTile(
                                    title: Text(cityName),
                                    value: _tempSelectedCities.contains(cityName),
                                    onChanged: (bool value) {
                                      if (value) {
                                        if (!_tempSelectedCities.contains(cityName)) {
                                          setState(() {
                                            _tempSelectedCities.add(uvdatalist[index]);
                                          });
                                        }
                                      } else {
                                        if (_tempSelectedCities.contains(cityName)) {
                                          setState(() {
                                            _tempSelectedCities.removeWhere(
                                                    (UVdatalist city) => city == uvdatalist[index]);
                                          });
                                        }
                                      }
                                      // widget
                                      //     .onSelectedCitiesListChanged(_tempSelectedCities);
                                    }),
                              );
                            }),
                      ),
                    ],
                  ),);
              });

        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        title: new Text("Comparison"),
        centerTitle: true,
      ),
        drawer: MainDrawer(),
    bottomNavigationBar: MyBottomNavBar(),
    body:SingleChildScrollView(
    padding: EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 10.0,
    ),
    child: Column(
     children:<Widget>[
       // Padding(
       //   padding: const EdgeInsets.all(8.0),
       //   child: ListTile(
       //     leading: FaIcon(FontAwesomeIcons.sun),
       //     title: Text("UV index"),
       //     trailing: Text('$temp'),
       //   ),
       // ),

       Container(
         child: Center(
           child: Text(
             'FOOD TRACK DATA',
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
           ),
         ),
       ),
       Padding(padding: EdgeInsets.all(5.0),
         child: Row(
           children: <Widget>[
             Text(
               'Food',
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
             ),
             Spacer(),
             Padding(
                 padding: EdgeInsets.only(left: 10),
             child: Text(
               'Intake(in g)',
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
             ),
             ),
             Spacer(),
             Text(
               'Vitamin D(in mcg)',
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
             )
           ],
         ),),
       new Container(
         height: 150,
         child: postsList.length == 0 ? new Text("No Items Added") : new ListView.builder(
             itemCount: postsList.length,
             itemBuilder: (_, index){
               return PostsUI(postsList[index].code, postsList[index].item,postsList[index].vitd,postsList[index].quantity);
             }
         ),
       ),
       // Padding(
       //   padding: const EdgeInsets.all(8.0),
       //   child: TextFormField(
       //     controller: exposuretime,
       //     validator: (String value){
       //       if(value.isEmpty){
       //         return 'This field cannot be empty';
       //       }
       //       return null;
       //     },
       //     decoration: InputDecoration(
       //       labelText: 'Sunlight Exposure Time',
       //       hintText: 'Enter Time (AM/PM)',
       //       border: OutlineInputBorder(
       //           borderRadius: BorderRadius.circular(20.0)
       //       ),
       //     ),
       //   ),
       // ),
       // Padding(
       //   padding: const EdgeInsets.all(8.0),
       //   child: TextFormField(
       //     controller: exposureduration,
       //     validator: (String value){
       //       if(value.isEmpty){
       //         return 'This field cannot be empty';
       //       }
       //       return null;
       //     },
       //     decoration: InputDecoration(
       //       labelText: 'Sunlight Exposure Duration',
       //       hintText: 'Enter duration(in minutes)',
       //       border: OutlineInputBorder(
       //           borderRadius: BorderRadius.circular(20.0)
       //       ),
       //     ),
       //   ),
       // ),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: Center(
           child: RaisedButton(
             child: Center(
               child: ListTile(
                 leading: FaIcon(FontAwesomeIcons.upload),
                 title: Text('Add Items'),
               ),
             ),
             color: Colors.green,
             textColor: Colors.black,
             splashColor: Colors.black12,
             padding: EdgeInsets.all(3.0),
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => FoodData()));
             },
           ),
         ),
       ),
       Container(
         child: Center(
           child: Text(
             'SUN TRACK DATA',
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
           ),
         ),
       ),
       Padding(padding: EdgeInsets.all(5.0),
       child: Row(
         children: <Widget>[
           Text(
             'Exposure Duration',
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
           ),
           Spacer(),
           Text(
             'UV index',
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
           ),
           Spacer(),
           Text(
             'Vitamin D(in mcg)',
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
           )
         ],
       ),),

       new Container(
         height: 150,
         child: sunlightDataList.length == 0 ? new Text("No Data available") : new ListView.builder(
             itemCount: sunlightDataList.length,
             itemBuilder: (_, index){
               return SunUI(sunlightDataList[index].starttime, sunlightDataList[index].endtime,sunlightDataList[index].uvindex,sunlightDataList[index].exposureduration,sunlightDataList[index].exposurevalue,sunlightDataList[index].id);
             }
         ),
       ),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: Center(
           child: RaisedButton(
             child: Center(
               child: ListTile(
                 leading: FaIcon(FontAwesomeIcons.upload),
                 title: Text('Enter Data Manually'),
               ),
             ),
             color: Colors.yellow,
             textColor: Colors.white,
             splashColor: Colors.deepOrange,
             padding: EdgeInsets.all(8.0),
             onPressed: (){
               _displayDialog(context);
             },
           ),
         ),
       ),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: Center(
           child: RaisedButton(
             child: Center(
               child: ListTile(
                 leading: FaIcon(FontAwesomeIcons.upload),
                 title: Text('Generate Evaluation Report',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),),
               ),
             ),
             color: Colors.deepOrange,
             textColor: Colors.white,
             splashColor: Colors.deepOrange,
             padding: EdgeInsets.all(8.0),
             onPressed: (){
               compute();
             },
           ),
         ),
       ),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: ListTile(
           leading: FaIcon(FontAwesomeIcons.calculator),
           title: Text("Vitamin D calculated"),
           trailing: Text(result),
         ),
         // child: Text(
         //   result,
         //   style: Theme.of(context).textTheme.bodyText1,
         //   textAlign: TextAlign.left,
         // ),
       ),
       ]

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
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    currentdate = formatter.format(now);
    print(currentdate);
    const oneSecond = const Duration(seconds: 1);
    var locationoptions = LocationOptions(accuracy: LocationAccuracy.high,distanceFilter: 10);
    _subscription = Geolocator().getPositionStream(locationoptions).listen((Position position) {
      setState(() {
        print(position);
        _position = position;
        lat = position.latitude.toString();
        long = position.longitude.toString();
        //getUVIndex(position.latitude.toString(), position.longitude.toString());
        final coordinates = new Coordinates(position.latitude,position.longitude);
        convertCoordinatesToAddress(coordinates).then((value)=> _address=value);
      });
    });
    referenceDatabase.child("skin complexion").once().then((DataSnapshot data){
      print(data.value);
      skintype = data.value;

      Fluttertoast.showToast(msg: data.value,toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
    });
    //final ref = referenceDatabase.reference().child("Orders1").child(something).child("Dishes");
    reference.onValue.listen((event) {
      var snap = event.snapshot;
      var Keys = snap.value.keys;
      var Data = snap.value;
      postsList.clear();
      for(var individualkey in Keys)
      {
        Posts1 posts = new Posts1(
          Data[individualkey]['code'],
          Data[individualkey]['item'],
          Data[individualkey]['vitd'],
          Data[individualkey]['quantity'],

        );
        postsList.add(posts);
      }
    });
    reference1.onValue.listen((event) {
      var snap = event.snapshot;
      var Keys = snap.value.keys;
      var Data = snap.value;
      sunlightDataList.clear();
      for(var individualkey in Keys)
      {
        SunData sunData = new SunData(
          Data[individualkey]['starttime'],
          Data[individualkey]['endtime'],
          Data[individualkey]['uvindex'],
          Data[individualkey]['exposureduration'],
          Data[individualkey]['exposurevalue'],
          Data[individualkey]['id'],
        );
        sunlightDataList.add(sunData);
      }
    });
    reference2.child(currentdate).once().then((DataSnapshot snap)
    {
      var Keys = snap.value.keys;
      var Data = snap.value;
      //postsList.clear();
      for(var individualkey in Keys)
      {
        UVdata sunData = new UVdata(

          Data[individualkey]['time'],
          Data[individualkey]['uvindex'],

        );
        uvdata.add(sunData);
      }
    });
    reference4.once().then((DataSnapshot snap){
      var Keys = snap.value.keys;
      var Data = snap.value;
      for(var individualkey in Keys)
      {
        UVdatalist posts = new UVdatalist(
          Data[individualkey]['time'],
          Data[individualkey]['cloud80'],
          Data[individualkey]['cloud90'],
          Data[individualkey]['cloud100'],
          Data[individualkey]['clearcloud'],
          Data[individualkey]['type']
        );
        uvdatalist.add(posts);
        print(uvdatalist);
      }
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
      this.temp = results['data'][0]['uv'].toString().substring(0,1);
      uvindexstring = temp;
      print(temp);
    });

  }
  void compute(){
    double comvalue,totals;
    count =0;
    count1 = 0;
    for(int i=0;i<postsList.length;i++){
      double grams = double.parse(postsList.elementAt(i).vitd);
      count = count+grams;
    }
    for(int i=0;i<sunlightDataList.length;i++){
      double vitd = double.parse(sunlightDataList.elementAt(i).exposurevalue);
      count1 = count1+vitd;
    }
    totals = count+count1;
    result = totals.toStringAsFixed(2);
    Fluttertoast.showToast(msg:count.toString()+":"+count1.toString()+":"+result,toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);

    if(totals>15){
      saveToDatabase(result,"Sufficient");
      showDialog(context: context,
          builder: (BuildContext context){
            return CustomDialogBox(
              title: "Vitamin D Status",
              descriptions: "You have sufficient level of Vitamin-D. Follow your diets regularly",
              text: "OK",
              img: Image.asset("assets/check.png"),
            );
          }
      );
    }else if(totals>12.5 && totals<15){
      saveToDatabase(result,"Moderate");
      showDialog(context: context,
          builder: (BuildContext context){
            return CustomDialogBox(
              title: "Vitamin D Status",
              descriptions: "You are moderate deficient in Vitamin-D. Please go through our suggestions",
              text: "OK",
              img: Image.asset("assets/mid.png"),
            );
          }
      );
    }
    else{
      saveToDatabase(result,"Deficient");
      showDialog(context: context,
          builder: (BuildContext context){
            return CustomDialogBox(title: "Vitamin D Status",
              descriptions: "You are low deficient in Vitamin-D. Please go through our suggestions",
              text: "OK",
              img: Image.asset("assets/cancel.png"),
            );
          }
      );
    }
    // referenceDatabase1.child(skintype).child(uvindexstring).once().then((DataSnapshot data){
    //   comvalue = double.parse(data.value);
    //   totals = comvalue+count;
    //   result = totals.toStringAsFixed(2);
    //   Fluttertoast.showToast(msg: (data.value)+count.toString(),toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
    // }).whenComplete(() =>
    //     {
    //
    //       if(totals>15){
    //   showDialog(context: context,
    //       builder: (BuildContext context){
    //         return CustomDialogBox(
    //           title: "Vitamin D Status",
    //           descriptions: "You have sufficient level of Vitamin-D. Follow your diets regularly",
    //           text: "OK",
    //           img: Image.asset("assets/check.png"),
    //         );
    //       }
    //   )
    // }else if(totals>12.5 && totals<15){
    //         showDialog(context: context,
    //             builder: (BuildContext context){
    //               return CustomDialogBox(
    //                 title: "Vitamin D Status",
    //                 descriptions: "You are moderate deficient in Vitamin-D. Please go through our suggestions",
    //                 text: "OK",
    //                 img: Image.asset("assets/mid.png"),
    //               );
    //             }
    //         )
    //       }
    //       else{
    // showDialog(context: context,
    // builder: (BuildContext context){
    // return CustomDialogBox(title: "Vitamin D Status",
    // descriptions: "You are low deficient in Vitamin-D. Please go through our suggestions",
    // text: "OK",
    //   img: Image.asset("assets/cancel.png"),
    // );
    // }
    // )
    // }
    // });

    // if(count>10){
    //   showDialog(context: context,
    //       builder: (BuildContext context){
    //         return CustomDialogBox(
    //           title: "Vitamin D Status",
    //           descriptions: "You have sufficient level of Vitamin-D. Follow your diets regularly",
    //           text: "OK",
    //         );
    //       }
    //   );
    // }else{
    //   showDialog(context: context,
    //       builder: (BuildContext context){
    //         return CustomDialogBox(
    //           title: "Vitamin D Status",
    //           descriptions: "You are deficient in Vitamin-D. Please go through our suggestions",
    //           text: "OK",
    //         );
    //       }
    //   );
    // }
  }
  Widget PostsUI(String code, String item,String vitd, String quantity)
  {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(5.0),
      child: new Container(
        padding: new EdgeInsets.all(5.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child:  new Text(
                item,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
              width: MediaQuery.of(context).size.width*0.4,
              height: 20,
            ),
            Container(
              child:  new Text(
                quantity,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
              width: MediaQuery.of(context).size.width*0.2,
              height: 20,
            ),
            Container(
              child: new Text(
                vitd.toString(),
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              width: MediaQuery.of(context).size.width*0.2,
              height: 20,
            ),

                SizedBox(
                  child: FlatButton(
                    child: Icon(
                      Icons.cancel,
                      color: Colors.black,
                      size: 16,
                    ),
                    color: Colors.white,
                    shape: CircleBorder(),
                    onPressed: (){
                      reference.child(code).remove();
                    },
                  ),
                  width: MediaQuery.of(context).size.width*0.1,
                  height: 20,
                ),

                // Padding
                //   (
                //    padding: EdgeInsets.all(3.0),
                //    child: IconButton(
                //      icon: Icon(Icons.delete),
                //      iconSize: 16.0,
                //      color: Colors.red,
                //      splashRadius: 16,
                //      onPressed: () {
                //        reference.child(code).remove();
                //      },
                //    ),
                // ),

          ],
        ),
      ),
    );
  }
  Widget SunUI(String starttime, String endtime,String uvindex,String exposureduration, String vitdvalue, String id)
  {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(5.0),
      child: new Container(
        padding: new EdgeInsets.all(5.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            new Text(
              starttime,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(left: 3.0,right: 3.0),
            child:Icon(Icons.wifi_protected_setup,size: 16.0,),
                ),
            new Text(
              endtime+"("+exposureduration+"min"+")",
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
            Spacer(),
            new Padding(padding: EdgeInsets.only(right: 8.0),
              child: Text(
              uvindex,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),

            ),
        Spacer(),
        new Padding(padding: EdgeInsets.only(right: 8.0),
          child: Text(
            vitdvalue,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
            SizedBox(
              child: FlatButton(
                child: Icon(
                  Icons.cancel,
                  color: Colors.black,
                  size: 16,
                ),
                color: Colors.white,
                shape: CircleBorder(),
                onPressed: (){
                 reference1.child(id).remove();
                },
              ),
              width: MediaQuery.of(context).size.width*0.1,
              height: 20,
            ),

          ],
        ),
      ),
    );
  }
  _displayDialogForTime(BuildContext context) async {
    List<String> _tempSelectedCities = [];
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context,setState){
                return AlertDialog(
                    title: Text('Select Sun Data '),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      //position
                      mainAxisSize: MainAxisSize.min,
                      // wrap content in flutter
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            //position
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: (){},
                                        color: Colors.grey,
                                        child: Text('AM',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
                                      RaisedButton(
                                        onPressed: (){},
                                        color: Colors.grey,
                                        child: Text('PM',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),)
                                    ],
                                  ),
                                  // Text(
                                  //   'Time Select',
                                  //   style: TextStyle(fontSize: 18.0, color: Colors.black),
                                  //   textAlign: TextAlign.center,
                                  // ),
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
                                    itemCount: uvdatalist.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final cityName = time[index];
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
                                              // widget
                                              //     .onSelectedCitiesListChanged(_tempSelectedCities);
                                            }
                                        ));
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                );
              });

        });
  }
  _displayDialogForSkinType(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context,setState){
                return AlertDialog(
                    title: Text('Select Sun Data '),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      //position
                      mainAxisSize: MainAxisSize.min,
                      // wrap content in flutter
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.7,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          selected = "1";
                                          setState((){});
                                        }, //do your action
                                        elevation: 1.0,
                                        constraints: BoxConstraints(), //removes empty spaces around of icon
                                        shape: RoundedRectangleBorder(), //circular button
                                        fillColor: Colors.white, //background color
                                        splashColor: Colors.amber,
                                        highlightColor: Colors.amber,
                                        child: Image.asset(
                                          "assets/skintones/clearsky.jpg",
                                          width: MediaQuery.of(context).size.width*0.30,
                                          height: MediaQuery.of(context).size.height*0.25,
                                          fit: BoxFit.cover,
                                        ),
                                        padding: EdgeInsets.all(8),
                                      ),
                                      SizedBox(height: 2,),
                                      Text('Clear Sky',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,),
                                      SizedBox(height: 2,),
                                      Text('Sunny',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          selected = "2";
                                          setState((){});
                                        }, //do your action
                                        elevation: 1.0,
                                        constraints: BoxConstraints(), //removes empty spaces around of icon
                                        shape: RoundedRectangleBorder(), //circular button
                                        fillColor: Colors.white, //background color
                                        splashColor: Colors.amber,
                                        highlightColor: Colors.amber,
                                        child: Image.asset(
                                          "assets/skintones/eightycloud.png",
                                          width: MediaQuery.of(context).size.width*0.30,
                                          height: MediaQuery.of(context).size.height*0.25,
                                            fit: BoxFit.cover,
                                        ),
                                        padding: EdgeInsets.all(8),
                                      ),
                                      SizedBox(height: 2,),
                                      Text('>80%',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,),
                                      SizedBox(height: 2,),
                                      Text('Cloud Coverage',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,),
                                    ],
                                  ),

                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          selected = "3";
                                          setState((){});
                                        }, //do your action
                                        elevation: 1.0,
                                        constraints: BoxConstraints(), //removes empty spaces around of icon
                                        shape: RoundedRectangleBorder(), //circular button
                                        fillColor: Colors.white, //background color
                                        splashColor: Colors.amber,
                                        highlightColor: Colors.amber,
                                        child: Image.asset(
                                          "assets/skintones/ninetycloud.png",
                                          width: MediaQuery.of(context).size.width*0.3,
                                          height: MediaQuery.of(context).size.height*0.25,
                                            fit: BoxFit.cover,
                                        ),
                                        padding: EdgeInsets.all(8),
                                      ),
                                      SizedBox(height: 2,),
                                      Text('> 90%',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,),
                                      SizedBox(height: 2,),
                                      Text('Cloud Coverage',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,),
                                    ],
                                  ),

                                  Spacer(),
                                  Column(
                                    children: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          selected = "4";
                                          setState((){});
                                        }, //do your action
                                        elevation: 1.0,
                                        constraints: BoxConstraints(), //removes empty spaces around of icon
                                        shape: RoundedRectangleBorder(), //circular button
                                        fillColor: Colors.white, //background color
                                        splashColor: Colors.amber,
                                        highlightColor: Colors.amber,
                                        child: Image.asset(
                                          "assets/skintones/cloudy.png",
                                          width: MediaQuery.of(context).size.width*0.3,
                                          height: MediaQuery.of(context).size.height*0.25,
                                            fit: BoxFit.cover,
                                        ),
                                        padding: EdgeInsets.all(8),
                                      ),
                                      SizedBox(height: 2,),
                                      Text('100 %',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,),
                                      SizedBox(height: 2,),
                                      Text('Cloud Coverage',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,),
                                    ],
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     Text('Type '+'$selected', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        //     Spacer(),
                        //     RaisedButton(
                        //       color: Colors.white,
                        //       onPressed: (){
                        //         Navigator.of(context).pop();
                        //       },
                        //       child: Text('OK',style: TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold,
                        //         fontStyle: FontStyle.italic,
                        //       ),),
                        //     ),
                        //   ],
                        // )
                      ],
                    ));
              });

        });
  }
}

