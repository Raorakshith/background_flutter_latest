
import 'package:background_flutter_latest/screens/asksymptoms.dart';
import 'package:background_flutter_latest/screens/bluetooth.dart';
import 'package:background_flutter_latest/screens/comparison.dart';
import 'package:background_flutter_latest/screens/navigationspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import '../constants1.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({
     Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: kDefaultPadding * 2,
        right: kDefaultPadding * 2,
        bottom: kDefaultPadding,
      ),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -10),
            blurRadius: 35,
            color: kPrimaryColor.withOpacity(0.38),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(3.0),
          child: InkWell(
            customBorder: new CircleBorder(),
            onTap: (){

                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => NavPages(),
                  ),
                  );
                  },
            splashColor: Colors.blue,
            child: IconButton(
              iconSize: 30,
              icon: Image.asset('assets/home.png'),
              onPressed: () {}

            ),
          ),),

          IconButton(
            iconSize: 40,
            icon: Image.asset('assets/reading.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AskSymptoms(),
                ),
              );
            },
          ),
          IconButton(
            iconSize: 40,
            icon: Image.asset('assets/glucose-meter.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BluetoothStates(),
                ),
              );
            },
          ),
          IconButton(
            iconSize: 40,
            icon: Image.asset('assets/evaluation.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Compare(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
