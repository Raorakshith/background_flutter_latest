import 'dart:async';
import 'dart:ffi';
import 'package:background_flutter_latest/screens/FoodData.dart';
import 'package:background_flutter_latest/screens/Posts1.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../custom_dialog_box.dart';
import 'main_drawer.dart';
class Compare extends StatefulWidget {
  @override
  _CompareState createState() => _CompareState();
}

class _CompareState extends State<Compare> {
  double count = 0;
  List<Posts1> postsList = [];
  final exposuretime = TextEditingController();
  final exposureduration = TextEditingController();
  final reference = FirebaseDatabase.instance.reference().child("User Data").child("Food Datas");
  final referenceDatabase = FirebaseDatabase.instance.reference().child("User Data").child("Profile");
  final referenceDatabase1 = FirebaseDatabase.instance.reference().child("Sunlight Data");
  Position _position;
  StreamSubscription<Position> _subscription;
  Address _address;
  var locationMessage = "",skintype="",uvindexstring="";
  var temp="0",result="";
  String lat,long,addressesdes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Comparison"),
        centerTitle: true,
      ),
        drawer: MainDrawer(),
    body:SingleChildScrollView(
    padding: EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 10.0,
    ),
    child: Column(
     children:<Widget>[
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
                 title: Text('Add Items'),
               ),
             ),
             color: Colors.white,
             textColor: Colors.black,
             splashColor: Colors.black12,
             padding: EdgeInsets.all(3.0),
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => FoodData()));
             },
           ),
         ),
       ),
       new Container(
         height: 150,
         child: postsList.length == 0 ? new Text("No Items Added") : new ListView.builder(
             itemCount: postsList.length,
             itemBuilder: (_, index){
               return PostsUI(postsList[index].code, postsList[index].item,postsList[index].vitd,postsList[index].quantity);
             }
         ),
       ),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: TextFormField(
           controller: exposuretime,
           validator: (String value){
             if(value.isEmpty){
               return 'This field cannot be empty';
             }
             return null;
           },
           decoration: InputDecoration(
             labelText: 'Sunlight Exposure Time',
             hintText: 'Enter Time (AM/PM)',
             border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(20.0)
             ),
           ),
         ),
       ),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: TextFormField(
           controller: exposureduration,
           validator: (String value){
             if(value.isEmpty){
               return 'This field cannot be empty';
             }
             return null;
           },
           decoration: InputDecoration(
             labelText: 'Sunlight Exposure Duration',
             hintText: 'Enter duration(in minutes)',
             border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(20.0)
             ),
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
                 title: Text('Compute'),
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
    referenceDatabase.child("skin complexion").once().then((DataSnapshot data){
      print(data.value);
      skintype = data.value;
      Fluttertoast.showToast(msg: data.value,toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
    });
    //final ref = referenceDatabase.reference().child("Orders1").child(something).child("Dishes");
    reference.once().then((DataSnapshot snap)
    {
      var Keys = snap.value.keys;
      var Data = snap.value;
      //postsList.clear();
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
    for(int i=0;i<postsList.length;i++){
      double grams = double.parse(postsList.elementAt(i).vitd)/1.7;
      count = count+grams;
    }

    referenceDatabase1.child(skintype).child(uvindexstring).once().then((DataSnapshot data){
      comvalue = double.parse(data.value);
      totals = comvalue+count;
      result = totals.toStringAsFixed(2);
      Fluttertoast.showToast(msg: (data.value)+count.toString(),toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
    }).whenComplete(() =>
        {

          if(totals>15){
      showDialog(context: context,
          builder: (BuildContext context){
            return CustomDialogBox(
              title: "Vitamin D Status",
              descriptions: "You have sufficient level of Vitamin-D. Follow your diets regularly",
              text: "OK",
              img: Image.asset("assets/check.png"),
            );
          }
      )
    }else if(totals>12.5 && totals<15){
            showDialog(context: context,
                builder: (BuildContext context){
                  return CustomDialogBox(
                    title: "Vitamin D Status",
                    descriptions: "You are moderate deficient in Vitamin-D. Please go through our suggestions",
                    text: "OK",
                    img: Image.asset("assets/mid.png"),
                  );
                }
            )
          }
          else{
    showDialog(context: context,
    builder: (BuildContext context){
    return CustomDialogBox(
    title: "Vitamin D Status",
    descriptions: "You are low deficient in Vitamin-D. Please go through our suggestions",
    text: "OK",
      img: Image.asset("assets/cancel.png"),
    );
    }
    )
    }
    });

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
                new Text(
                  item,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                new Text(
                  quantity,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
                Spacer(),
                new Text(
                  vitd.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),

          ],
        ),
      ),
    );
  }
}

