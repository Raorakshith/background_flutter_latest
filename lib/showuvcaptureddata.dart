import 'dart:async';

import 'package:background_flutter_latest/screens/SunData.dart';
import 'package:background_flutter_latest/screens/UVdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ShowCapturedUVdata extends StatefulWidget {
  const ShowCapturedUVdata({Key key}) : super(key: key);

  @override
  _ShowCapturedUVdataState createState() => _ShowCapturedUVdataState();
}

class _ShowCapturedUVdataState extends State<ShowCapturedUVdata> {
  List<UVdata> sunlightDataList = [];
  String currentdate;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final reference2 = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("UV INDEX");
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    currentdate = formatter.format(now);
    print(currentdate);
    const oneSecond = const Duration(seconds: 1);
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
        sunlightDataList.add(sunData);
      }
    });
    new Timer.periodic(oneSecond,(Timer t) => setState((){}));
}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: new Text("Today's UV Data"),
        centerTitle: true,
      ),
      body: Container(
      height: MediaQuery.of(context).size.height,
      child: sunlightDataList.length == 0 ? new Text("No Items Added") : new ListView.builder(
          itemCount: sunlightDataList.length,
          itemBuilder: (_, index){
            return PostsUI(sunlightDataList[index].uvindex, sunlightDataList[index].time);
          }
      ),
    ));
  }
  Widget PostsUI( String uvindex, String time)
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
                uvindex,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
              width: MediaQuery.of(context).size.width*0.4,
              height: 20,
            ),
            Container(
              child:  new Text(
                time,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
              width: MediaQuery.of(context).size.width*0.2,
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
}
