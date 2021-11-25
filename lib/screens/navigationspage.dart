import 'package:background_flutter_latest/config/palette.dart';
import 'package:background_flutter_latest/config/styles.dart';
import 'package:background_flutter_latest/data/data.dart';
import 'package:background_flutter_latest/screens/asksymptoms.dart';
import 'package:background_flutter_latest/screens/bluetooth.dart';
import 'package:background_flutter_latest/screens/comparison.dart';
import 'package:background_flutter_latest/screens/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class NavPages extends StatefulWidget {
  @override
  _NavPagesState createState() => _NavPagesState();
}

class _NavPagesState extends State<NavPages> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: MainDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF00A8D5),
              const Color(0xFFFFFFFF),

            ],),),
      child: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(screenHeight),
          _buildPreventionTips(screenHeight),
          _buildYourOwnTest(screenHeight),
        ],
      ),
      ),
    );
  }
  SliverToBoxAdapter _buildHeader(double screenHeight){
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Palette.darkBlue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Vit- D',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ],
            ),
            SizedBox(height: screenHeight*0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Are you feeling uncomfortable?',style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
                ),
                SizedBox(height: screenHeight*0.01),
                Text("If you feel uncomfortable with any VITAMIN-D deficiency symptoms, please assess yourself with our starter kit and get the details",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: screenHeight*0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Compare()));
                      },
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.assignment_ind,
                        color: Colors.white,
                      ),
                      label: Text('Assess Now',style: Styles.buttonTextstyle,
                      ),
                      textColor: Colors.white,
                    ),
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AskSymptoms()));
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                          Icons.chat,
                          color: Colors.white,
                      ),
                      label: Text('Chat Now',style: Styles.buttonTextstyle,
                      ),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  SliverToBoxAdapter _buildPreventionTips(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        child: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [
        const Color(0xFF00A8D5),
    const Color(0xFFFFFFFF),

    ],),),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Prevention Tips',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22.0,
            ),
            ),
            const SizedBox(height: 20.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: prevention.map((e) => Column(children: <Widget>[
                  Image.asset(
                    e.keys.first,
                    height: screenHeight*0.12,
                  ),
                  SizedBox(height: screenHeight*0.015),
                  Text(
                    e.values.first,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
                ),
                )
                    .toList(),
              ) ,
            ),

          ],
        ),
      ),
    ));
  }
  SliverToBoxAdapter _buildYourOwnTest(double screenHeight){
    return SliverToBoxAdapter(

      child: new GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothStates()));
        },
    child:new Container(

        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.all(10.0),

        height: screenHeight*0.15,
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
                Text('Do your own test',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(height: screenHeight*0.001),
                Text('Follow the instructions  \n to do your own test.',
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
    );
  }
}

