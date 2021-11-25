import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:background_flutter_latest/config/palette.dart';
import 'package:background_flutter_latest/custom_dialog_box.dart';
import 'package:background_flutter_latest/screens/my_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_gauge/flutter_gauge.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'main_drawer.dart';

class BluetoothStates extends StatefulWidget {
  @override
  _BluetoothStatesState createState() => _BluetoothStatesState();
}

class _BluetoothStatesState extends State<BluetoothStates> {
  TextEditingController _controller = TextEditingController();
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
FlutterBluetoothSerial _bluetoothSerial = FlutterBluetoothSerial.instance;
BluetoothConnection connection;
bool get isConnected => connection != null && connection.isConnected;
int _deviceState;
String _messageBuffer = '';
BluetoothDevice _device;
bool isDisconnecting = false;
bool _connected = false;
String textHolder = "0.0 ng/ml ";
String textholdgauge = "";
bool _isButtonUnavailable = false;
bool _didmanual = false;
var voltage ="";
var tempdata;
List<BluetoothDevice> _devicesList = [];
List<String> bluetoothrecieveddata = [];
final reference = FirebaseDatabase.instance.reference().child("Vitamin D values");
final reference1 = FirebaseDatabase.instance.reference().child("User Data").child(FirebaseAuth.instance.currentUser.uid).child("Test Reports");

@override
  void dispose() {
    // TODO: implement dispose
  if(isConnected){
    isDisconnecting = true;
    connection.dispose();
    connection = null;
  }
    super.dispose();
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("conca"+textHolder.replaceAll("ng/ml", "").replaceAll(">", ""));
    FlutterBluetoothSerial.instance.state.then((state){
      setState(() {
        _bluetoothState = state;
      });
    });
    _deviceState = 0;

    enableBluetooth();
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        getPairedDevices();
      });
    });
  }
  Future<void> enableBluetooth() async {
  _bluetoothState = await FlutterBluetoothSerial.instance.state;
  if(_bluetoothState == BluetoothState.STATE_OFF){
    await FlutterBluetoothSerial.instance.requestEnable();
    await getPairedDevices();
    return true;
  }else{
    await getPairedDevices();
  }
  return false;
  }
  Future<void> getPairedDevices() async{
  List<BluetoothDevice> devices= [];
  try{
    devices = await _bluetoothSerial.getBondedDevices();
  }on PlatformException{
    print("Error");
  }
  if(!mounted){
    return;
  }
  setState(() {
    _devicesList = devices;
  });
  }
List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems(){
  List<DropdownMenuItem<BluetoothDevice>> items = [];
  if(_devicesList.isEmpty){
    items.add(DropdownMenuItem(child: Text('None'),));
  }else{
    _devicesList.forEach((device){
      items.add(DropdownMenuItem(
        child: Text(device.name=="HC-05"?"VitaD":device.name),
        value: device,
      ));
    });
  }
  return items;
}
Future show(
    String message,{
      Duration duration: const Duration(seconds: 3),
})async {
  await new Future.delayed(new Duration(milliseconds: 100));
  _scaffoldkey.currentState.showSnackBar(new SnackBar(
  content: new Text(message,),
  duration: duration,
  ),
  );
}

void _connect() async {
  setState(() {
    _isButtonUnavailable = true;
  });
  if(_device == null){
    show('No device selected');
  }else{
    if(!isConnected){
      await BluetoothConnection.toAddress(_device.address).then((_connection)
      {
        print('Connected to the device');
        connection = _connection;

        setState(() {
          _connected = true;
        });

        connection.input.listen(_onDataReceived).onDone(() {
          // print(connection.input.first.toString());
          if(isDisconnecting){
            print('Disconnecting locslly');
          }else{
            print('Disconnecting remotely!');
          }
          if(this.mounted){
            setState(() {

            });
          }
        });
      }).catchError((error){
        print('Cannot connect, exception occurred');
        print(error);
      });
      show('Device connected');
      setState(() => _isButtonUnavailable = false);
    }
    else{
      show('Already Device connected');
    }
  }
}
void _sendOnMessageToBluetooth() async{
  connection.output.add(utf8.encode("1"+"\r\n"));
  await connection.output.allSent;
  show('Device Turned On');
  setState(() {
    _deviceState = 1;
  });
}
void _sendOffMessageToBluetooth() async{
  connection.output.add(utf8.encode("0"+"\r\n"));
  await connection.output.allSent;
  show('Device Turned Off');
  setState(() {
    _deviceState = -1;
  });

}
void saveToDatabase(valuesoftemp,statusvalue){
  var data=
  {
    "testValue": valuesoftemp,
    "status": statusvalue,
    "date": DateFormat('yMd').format(DateTime.now()),
    "time":DateFormat('hh:mm:ss').format(DateTime.now()),
  };
  reference1.child(DateFormat('hh:mm:ss').format(DateTime.now()).toString()).set(data).whenComplete(() async{
    await Fluttertoast.showToast(msg: "Test Report saved",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
  });

}
void _computeData(){
  List<double> bluetoothrecieveddatalist1 = [];
  double temp = 0;
  for(int i=0;i<5;i++){
    bluetoothrecieveddatalist1.add(double.parse(bluetoothrecieveddata[i]));
    // temp = double.parse(bluetoothrecieveddata.elementAt(0));
    // if(double.parse(bluetoothrecieveddata.elementAt(i+1)) >= temp){
    //   temp = double.parse(bluetoothrecieveddata.elementAt(i+1));
    // }
  }
  //temp = bluetoothrecieveddatalist1.isEmpty ? 0 : bluetoothrecieveddatalist1.reduce(max);
  temp = bluetoothrecieveddatalist1.fold(bluetoothrecieveddatalist1[0],max);
  tempdata = temp.toString();
  // if(temp>20){
  //   saveToDatabase(temp.toString(),"Sufficient");
  //   showDialog(context: context,
  //       builder: (BuildContext context){
  //         return CustomDialogBox(
  //           title: "Vitamin D Status",
  //           descriptions: "You have sufficient level of Vitamin-D. Follow your diets regularly",
  //           text: "OK",
  //           img: Image.asset("assets/check.png"),
  //         );
  //       }
  //   );
  // }else if(temp>12.5 && temp<20){
  //   saveToDatabase(temp.toString(),"Moderate");
  //   showDialog(context: context,
  //       builder: (BuildContext context){
  //         return CustomDialogBox(
  //           title: "Vitamin D Status",
  //           descriptions: "You are moderate deficient in Vitamin-D. Please go through our suggestions",
  //           text: "OK",
  //           img: Image.asset("assets/mid.png"),
  //         );
  //       }
  //   );
  // }
  // else{
  //   saveToDatabase(temp.toString(),"Deficient");
  //   showDialog(context: context,
  //       builder: (BuildContext context){
  //         return CustomDialogBox(title: "Vitamin D Status",
  //           descriptions: "You are low deficient in Vitamin-D. Please go through our suggestions",
  //           text: "OK",
  //           img: Image.asset("assets/cancel.png"),
  //         );
  //       }
  //   );
  // }
  setState(() {
    textHolder = temp.toString();
  });

}
void _recieveMessageFromBluetooth() {
  //connection.input.listen((event) {print(event.toString());})
  var data = connection.input.first.toString();
  print(data);
  show(data);
}
void _onDataReceived(Uint8List data) {
  // Allocate buffer for parsed data
  int backspacesCounter = 0;
  //print(data);
  data.forEach((byte) {
    if (byte == 8 || byte == 127) {
      backspacesCounter++;
    }
  });
  Uint8List buffer = Uint8List(data.length - backspacesCounter);
  int bufferIndex = buffer.length;

  // Apply backspace control character
  backspacesCounter = 0;
  for (int i = data.length - 1; i >= 0; i--) {
    if (data[i] == 8 || data[i] == 127) {
      backspacesCounter++;
    }
    else {
      if (backspacesCounter > 0) {
        backspacesCounter--;
      }
      else {
        buffer[--bufferIndex] = data[i];
      }
    }
  }

  // Create message if there is new line character
  String dataString = String.fromCharCodes(buffer);
  //print(dataString);
  //show(dataString);
  int index = buffer.indexOf(13);

  if (~index != 0) { // \r\n
    setState(() {
      String received_data = _messageBuffer + dataString.substring(0, index);
      received_data = received_data.trim()..replaceAll(",", "");
      setState(() {

      });
        // reference.push().set(received_data);
        // show(received_data);

        bluetoothrecieveddata.add( received_data);
        // textHolder = bluetoothrecieveddata[0].toString().split(',').first;
        textHolder = bluetoothrecieveddata[0].toString().substring(0, bluetoothrecieveddata[0].toString().indexOf(','));
        // textholdgauge = textHolder.replaceAll("ng/ml", "");

      // bluetoothrecieveddata.add(received_data.split(',').last);

      voltage = received_data;
//        print(received_data.substring(0, 4));
      // print(received_data.length);

      _messageBuffer = dataString.substring(index);
      print(_messageBuffer);
    });
  }
  else {
    _messageBuffer = (
        backspacesCounter > 0
            ? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter)
            : _messageBuffer
            + dataString
    );
    // print("gf"+_messageBuffer);
  }
}
void _disconnect() async{
  setState(() {
    _isButtonUnavailable = true;
    _deviceState = 0;
  });
  await connection.close();
  show('Device disconnected');
  if(!connection.isConnected){
    setState(() {
      _connected = false;
      _isButtonUnavailable = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: new AppBar(
        title: new Text("Testing"),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      bottomNavigationBar: MyBottomNavBar(),
      body: SingleChildScrollView(

        child: Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
      const Color(0xFF00A8D5),
    const Color(0xFFFFFFFF),

    ],),),
        child: Column(
          children:<Widget> [
            Row(
              children: <Widget>[
                Text(
                  'Turn ON/OFF Bluetooth',
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Switch(
                    value: _bluetoothState.isEnabled,
                    onChanged: (bool value){
                      future() async {
                        if(value){
                          await FlutterBluetoothSerial.instance.requestEnable();
                        }else{
                          await FlutterBluetoothSerial.instance.requestDisable();
                        }
                        await getPairedDevices();
                        _isButtonUnavailable = false;
                        if(_connected){
                          _disconnect();
                        }
                      }
                      future().then((_){
                        setState(() {

                        });
                      });
                    },
                  ),
                ),

              ],
            ),
        Container(

          child: new GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothStates()));
            },
            child:new Container(

              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              padding: const EdgeInsets.all(10.0),

              height: MediaQuery.of(context).size.height*0.22,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFAD9FE4),Palette.primaryColor],
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image.asset('assets/glucose-meter.png'),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Steps to Follow: ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.001),
                      Text('1. Connect the meter to \napp using bluetooth.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),),
                      SizedBox(height: MediaQuery.of(context).size.height*0.001),
                      Text('2. Place blood sample\non the strip.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),),
                      SizedBox(height: MediaQuery.of(context).size.height*0.001),
                      Text('3. Your report will be\ngenerated now',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                isDense: true,
                items: _getDeviceItems(),
                onChanged: (value) =>
                setState(()=> _device = value),
                value: _devicesList.isNotEmpty ? _device : null,
              ),
            ),
            RaisedButton(
              color: Color(0xffe11e2b),
              onPressed: _isButtonUnavailable ? null : _connected ? _disconnect : _connect,
              child: Text(_connected ? 'Disconnect Test Device' : 'Connect Test Device',style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white
              ),),
            ),



            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Vitamin-D Test Report',
                textAlign: TextAlign.center, 
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            FlutterGauge(
                handSize: 25,
                index: 10,
                // index:double.parse('$textHolder'.replaceAll("ng/ml", "").replaceAll(">","")),
                end: 50,
                number: Number.endAndCenterAndStart,
                circleColor: Color(0xFF47505F),
                secondsMarker:
                SecondsMarker.secondsAndMinute,
                counterStyle: TextStyle(
                  color: Colors.white,fontSize: 20,
                )
            ),

            // Container(
            //   padding: EdgeInsets.only(left: 20.0),
            //   height: 40,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: bluetoothrecieveddata.length,
            //     itemBuilder: (_, index)=>
            //         Text(bluetoothrecieveddata[index]+"     ",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            //
            //   ),
            //
            // ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  children: [
                    Text('$textHolder',
                      style: TextStyle(fontSize: 20),),
                    Spacer(),
                    Container(

                      child: FittedBox(
                        child: RaisedButton(
                          color: Colors.orangeAccent,
                          onPressed:(){
                            _computeData();
                          },
                          child: Text('Generate Test Report',style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),),
                        ),
                      ),

                    ),
                  ],
                )
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.5,
                      child: TextFormField(

                        decoration: InputDecoration(
                          labelText: 'Lab Report(ng/ml)',
                          hintText: 'Enter Lab Test Report(ng/ml)',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _controller,
                        enabled: _didmanual,
                      ),
                    ),

                    Spacer(),
                    Container(

                      child: FittedBox(
                        child: RaisedButton(
                          color: Colors.orangeAccent,
                          onPressed:(){
                             tempdata = _controller.text;
                            _didmanual = true;
                            setState(() {
                              _didmanual = true;
                            });

                    },
                          child: Text('Add Lab Report',style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),),
                        ),
                      ),

                    ),
                  ],
                )
            ),


            RaisedButton(
              color: Colors.green,
              onPressed:(){
                // var temp = double.parse(tempdata);
                if(_didmanual) {
                  var temp = double.parse(_controller.text);
                  if (temp > 20) {
                    saveToDatabase(temp.toString(), "Sufficient");
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: "Vitamin D Status",
                            descriptions: "You have sufficient level of Vitamin-D. Follow your diets regularly",
                            text: "OK",
                            img: Image.asset("assets/check.png"),
                          );
                        }
                    );
                  } else if (temp > 12.5 && temp < 20) {
                    saveToDatabase(temp.toString(), "Moderate");
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: "Vitamin D Status",
                            descriptions: "You have insufficient Vitamin-D. Please go through our suggestions",
                            text: "OK",
                            img: Image.asset("assets/mid.png"),
                          );
                        }
                    );
                  }
                  else {
                    saveToDatabase(temp.toString(), "Deficient");
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(title: "Vitamin D Status",
                            descriptions: "You are low deficient in Vitamin-D. Please go through our suggestions",
                            text: "OK",
                            img: Image.asset("assets/cancel.png"),
                          );
                        }
                    );
                  }
                }else{
                  var temp = double.parse(tempdata);
                  if (temp > 20) {
                    saveToDatabase(temp.toString(), "Sufficient");
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: "Vitamin D Status",
                            descriptions: "You have sufficient level of Vitamin-D. Follow your diets regularly",
                            text: "OK",
                            img: Image.asset("assets/check.png"),
                          );
                        }
                    );
                  } else if (temp > 12.5 && temp < 20) {
                    saveToDatabase(temp.toString(), "Moderate");
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: "Vitamin D Status",
                            descriptions: "You are moderate deficient in Vitamin-D. Please go through our suggestions",
                            text: "OK",
                            img: Image.asset("assets/mid.png"),
                          );
                        }
                    );
                  }
                  else {
                    saveToDatabase(temp.toString(), "Deficient");
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(title: "Vitamin D Status",
                            descriptions: "You are low deficient in Vitamin-D. Please go through our suggestions",
                            text: "OK",
                            img: Image.asset("assets/cancel.png"),
                          );
                        }
                    );
                  }
                }
              },
              child: Text('Get Recommendations',style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.white
              ),),
            ),

            Container(
              padding: EdgeInsets.only(left: 20.0),
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bluetoothrecieveddata.length,
                itemBuilder: (_, index)=>
                    Text(bluetoothrecieveddata[index]+"     ",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

              ),

            ),
             Row(
               children: [
                 Spacer(),
                 RaisedButton(
                   color: Colors.grey,
                   onPressed:(){
                     bluetoothrecieveddata.clear();
                     textHolder = '0.0 ng/ml';
                     setState(() {

                     });

                   },
                   child: Text('Clear Values',style: TextStyle(
                     fontSize: 14,
                     fontWeight: FontWeight.bold,
                     fontStyle: FontStyle.normal,
                   ),),
                 ),
               ],
             )

            // Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: new Row(
            //       children: [
            //         TextFormField(
            //
            //           decoration: InputDecoration(
            //             labelText: 'Lab Report(ng/ml)',
            //             hintText: 'Enter Lab Test Report(ng/ml)',
            //             border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(20.0)
            //             ),
            //           ),
            //           maxLength: 10,
            //           keyboardType: TextInputType.number,
            //           controller: _controller,
            //         ),
          //           Spacer(),
          //           Container(
          //
          //             child: FittedBox(
          //               child: RaisedButton(
          //                 color: Colors.orangeAccent,
          //                 onPressed:(){
          //                   var temp = double.parse(_controller.text);
          //                   if(temp>20){
          //                     saveToDatabase(temp.toString(),"Sufficient");
          //                     showDialog(context: context,
          //                         builder: (BuildContext context){
          //                           return CustomDialogBox(
          //                             title: "Vitamin D Status",
          //                             descriptions: "You have sufficient level of Vitamin-D. Follow your diets regularly",
          //                             text: "OK",
          //                             img: Image.asset("assets/check.png"),
          //                           );
          //                         }
          //                     );
          //                   }else if(temp>12.5 && temp<20){
          //                     saveToDatabase(temp.toString(),"Moderate");
          //                     showDialog(context: context,
          //                         builder: (BuildContext context){
          //                           return CustomDialogBox(
          //                             title: "Vitamin D Status",
          //                             descriptions: "You are moderate deficient in Vitamin-D. Please go through our suggestions",
          //                             text: "OK",
          //                             img: Image.asset("assets/mid.png"),
          //                           );
          //                         }
          //                     );
          //                   }
          //                   else{
          //                     saveToDatabase(temp.toString(),"Deficient");
          //                     showDialog(context: context,
          //                         builder: (BuildContext context){
          //                           return CustomDialogBox(title: "Vitamin D Status",
          //                             descriptions: "You are low deficient in Vitamin-D. Please go through our suggestions",
          //                             text: "OK",
          //                             img: Image.asset("assets/cancel.png"),
          //                           );
          //                         }
          //                     );
          //                   }
          //
          //                 },
          //                 child: Text('Check Now',style: TextStyle(
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.bold,
          //                   fontStyle: FontStyle.normal,
          //                 ),),
          //               ),
          //             ),
          //
          //           ),
          //         ],
          //       )
          //   ),
          //
          ],
        ),
      ),
      ),

    );
  }
Widget _bluetoothItem(String bluetoothdata){
  return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: InkWell(
        onTap: (){

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                child: Text(bluetoothdata,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey
                                )),
                      )
                    ]
                )
      )
  );
}
}
