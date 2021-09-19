import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_gauge/flutter_gauge.dart';

import 'main_drawer.dart';

class BluetoothStates extends StatefulWidget {
  @override
  _BluetoothStatesState createState() => _BluetoothStatesState();
}

class _BluetoothStatesState extends State<BluetoothStates> {
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
String textHolder = '0';
bool _isButtonUnavailable = false;
var voltage ="";
List<BluetoothDevice> _devicesList = [];
List<String> bluetoothrecieveddata = [];
final reference = FirebaseDatabase.instance.reference().child("Vitamin D values");

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
        child: Text(device.name),
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
void _computeData(){
  List<double> bluetoothrecieveddatalist1 = [];
  double temp = 0;
  for(int i=0;i<9;i++){
    bluetoothrecieveddatalist1.add(double.parse(bluetoothrecieveddata[i]));
    // temp = double.parse(bluetoothrecieveddata.elementAt(0));
    // if(double.parse(bluetoothrecieveddata.elementAt(i+1)) >= temp){
    //   temp = double.parse(bluetoothrecieveddata.elementAt(i+1));
    // }
  }
  //temp = bluetoothrecieveddatalist1.isEmpty ? 0 : bluetoothrecieveddatalist1.reduce(max);
  temp = bluetoothrecieveddatalist1.fold(bluetoothrecieveddatalist1[0],max);
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
      received_data = received_data.trim();
        print(received_data);
        reference.push().set(received_data);
        // show(received_data);
        bluetoothrecieveddata.add(received_data);
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
    print(_messageBuffer);
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        child: Column(
          children:<Widget> [
            Row(
              children: <Widget>[
                Text(
                  'Bluetooth State',
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

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                items: _getDeviceItems(),
                onChanged: (value) =>
                setState(()=> _device = value),
                value: _devicesList.isNotEmpty ? _device : null,
              ),
            ),
            RaisedButton(
              color: Colors.green,
              onPressed: _isButtonUnavailable ? null : _connected ? _disconnect : _connect,
              child: Text(_connected ? 'Disconnect' : 'Connect'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Device Status',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.green[600],
                  onPressed: _connected ? _sendOnMessageToBluetooth:null,child: Text("ON"),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: _connected ? _sendOffMessageToBluetooth:null,child: Text("OFF"),
                ),
              ],
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
                            _computeData();
                          },
                        ),
                      ),

                    ),
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Test Report',
                textAlign: TextAlign.center, 
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FlutterGauge(
                handSize: 25,
                index:double.parse('$textHolder'),
                end: 10,
                number: Number.endAndCenterAndStart,
                circleColor: Color(0xFF47505F),
                secondsMarker:
                SecondsMarker.secondsAndMinute,
                counterStyle: TextStyle(
                  color: Colors.black,fontSize: 20,
                )
            ),
            Container(
                      height: 150,
                      child: ListView.builder(
                          itemCount: bluetoothrecieveddata.length,
                          itemBuilder: (_, index){
                            return Text(bluetoothrecieveddata[index]);
                          }
                      ),
                      // child: ListView(
                      //   children: [
                      //     _dietFoodItem('assets/skintones/alternativemedicine.jpg', 'food 1', '10 mcg'),
                      //     _dietFoodItem('assets/skintones/cardiology.jpg', 'food 2', '10 mcg'),
                      //     _dietFoodItem('assets/skintones/pediatrics.jpg', 'food 3', '10 mcg')
                      //   ]
                      // )
            ),
          ],
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
