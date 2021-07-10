import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Recommend extends StatefulWidget {
  const Recommend({Key key}) : super(key: key);

  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: (){},
                ),
                Container(
                  width: 125.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        color: Colors.white,
                        onPressed: (){},
                      ),
                      IconButton(
                        icon: Icon(Icons.menu),
                        color: Colors.white,
                        onPressed: (){},
                      )
                    ],
                  )
                )
              ]
            )
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Healthy',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0
                )),
                SizedBox(width: 10.0),
                Text('Food',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0
                ))
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 45.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height-300,
                    child: ListView(
                      children: [
                        _dietFoodItem('assets/skintones/alternativemedicine.jpg', 'food 1', '10 mcg'),
                        _dietFoodItem('assets/skintones/cardiology.jpg', 'food 2', '10 mcg'),
                        _dietFoodItem('assets/skintones/pediatrics.jpg', 'food 3', '10 mcg')
                      ]
                    )
                  )
                )
              ],
            ),
          )
        ]
      )
    );
  }
  Widget _dietFoodItem(String imgpath, String foodName, String vitamind){
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: InkWell(
        onTap: (){

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Hero(
                    tag: imgpath,
                    child: Image(
                      image: AssetImage(imgpath),
                      fit: BoxFit.cover,
                      height: 75.0,
                      width: 75.0
                    )
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(foodName,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold
                      )),
                      Text(vitamind,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey
                          ))
                    ]
                  )
                ]
              )
            ),
          ],
        ),
      )
    );
  }
}