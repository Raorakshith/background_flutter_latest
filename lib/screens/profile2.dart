import 'package:background_flutter_latest/screens/bottom_nav_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'asksymptoms.dart';
class Profile2 extends StatefulWidget {
  @override
  _Profile2State createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> {
  final referenceDatabase = FirebaseDatabase.instance;
  final formkey = new GlobalKey<FormState>();
  final userhealth = TextEditingController();
  String preg,child,old,kidney,liver;
  void saveToDatabase(){
    final ref = referenceDatabase.reference();
    var data=
    {
      "userhealth" : userhealth.text.toString(),
      "pregnant" : preg,
      "children" : child,
      "oldage" : old,
      "kidneydisease" : kidney,
      "liverdisease" : liver,
    };
    ref.child("User Data").child("Health Data").set(data).whenComplete(() async{
      await Fluttertoast.showToast(msg: "Uploaded successfully",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                child: Text('Let us know more ',style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black) ,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: userhealth,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'General Health',
                    hintText: 'Tell us about your health',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Are you Pregnant ?",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black),),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ToggleSwitch(
                  initialLabelIndex: 1,
                  labels: [
                    'YES',
                    'NO'
                  ],
                  onToggle: (index){
                    if(index == 1){
                      preg = "NO";
                    }else{
                      preg = "YES";
                    }
                    print("Switched to: + $index");
                  },
                  fontSize: 18,
                  minWidth: 130,
                  minHeight: 40,
                  cornerRadius: 30,
                  icons: [
                    Icons.done,
                    Icons.cancel_outlined,
                  ],
                  iconSize: 30,
                  activeBgColors: [
                    Colors.green,
                    Colors.red
                  ],
                  activeFgColor: Colors.white,
                  inactiveFgColor: Colors.indigo,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Children (0 to 5 years) ?",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black),),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ToggleSwitch(
                  initialLabelIndex: 1,
                  labels: [
                    'YES',
                    'NO'
                  ],
                  onToggle: (index){
                    if(index == 1){
                      child = "NO";
                    }else{
                      child = "YES";
                    }
                    print("Switched to: + $index");
                  },
                  fontSize: 18,
                  minWidth: 130,
                  minHeight: 40,
                  cornerRadius: 30,
                  icons: [
                    Icons.done,
                    Icons.cancel_outlined,
                  ],
                  iconSize: 30,
                  activeBgColors: [
                    Colors.green,
                    Colors.red
                  ],
                  activeFgColor: Colors.white,
                  inactiveFgColor: Colors.indigo,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Old Age (Above 60 years) ?",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black),),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ToggleSwitch(
                  initialLabelIndex: 1,
                  labels: [
                    'YES',
                    'NO'
                  ],
                  onToggle: (index){
                    if(index == 1){
                      old = "NO";
                    }else{
                      old = "YES";
                    }
                    print("Switched to: + $index");
                  },
                  fontSize: 18,
                  minWidth: 130,
                  minHeight: 40,
                  cornerRadius: 30,
                  icons: [
                    Icons.done,
                    Icons.cancel_outlined,
                  ],
                  iconSize: 30,
                  activeBgColors: [
                    Colors.green,
                    Colors.red
                  ],
                  activeFgColor: Colors.white,
                  inactiveFgColor: Colors.indigo,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Any Type of Kidney Disease ?",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black),),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ToggleSwitch(
                  initialLabelIndex: 1,
                  labels: [
                    'YES',
                    'NO'
                  ],
                  onToggle: (index){
                    if(index == 1){
                      kidney = "NO";
                    }else{
                      kidney = "YES";
                    }
                    print("Switched to: + $index");
                  },
                  fontSize: 18,
                  minWidth: 130,
                  minHeight: 40,
                  cornerRadius: 30,
                  icons: [
                    Icons.done,
                    Icons.cancel_outlined,
                  ],
                  iconSize: 30,
                  activeBgColors: [
                    Colors.green,
                    Colors.red
                  ],
                  activeFgColor: Colors.white,
                  inactiveFgColor: Colors.indigo,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Any Type of Liver Disease ?",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ToggleSwitch(
                  initialLabelIndex: 1,
                  labels: [
                    'YES',
                    'NO'
                  ],
                  onToggle: (index){
                    if(index == 1){
                      liver = "NO";
                    }else{
                      liver = "YES";
                    }
                    print("Switched to: + $index");
                  },
                  fontSize: 18,
                  minWidth: 130,
                  minHeight: 40,
                  cornerRadius: 30,
                  icons: [
                    Icons.done,
                    Icons.cancel_outlined,
                  ],
                  iconSize: 30,
                  activeBgColors: [
                    Colors.green,
                    Colors.red
                  ],
                  activeFgColor: Colors.white,
                  inactiveFgColor: Colors.indigo,
                ),
              ),
              RaisedButton(
                  child: Text('Update'),
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
            ],
          ),
        ),
      )
    );
  }
}
