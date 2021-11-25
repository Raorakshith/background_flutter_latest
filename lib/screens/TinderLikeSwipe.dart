import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../Content.dart';
import '../custom_dialog_box.dart';
import 'main_drawer.dart';
import 'my_bottom_nav_bar.dart';
class SwipeSymptomsCard extends StatefulWidget {

  @override
  _SwipeSymptomsCardState createState() => _SwipeSymptomsCardState();
}

class _SwipeSymptomsCardState extends State<SwipeSymptomsCard> {
  var count =0;
  bool _isavailable= false;
  List<SwipeItem> _swipeItems = List<SwipeItem>();
  MatchEngine _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // List<String> _names = ["Red", "Blue", "Green", "Yellow", "Orange"];
  List<String> _names = [
    'Do you experience Bone Ache , Back Aches ?',
    'Do you experience Chronic Fatigue (lack of sleep or excess sleep) ?',
    'Do you experience Fragile Bones ?',
    'Do you experience Frequent Cold Infections ?',
    'Do you experience Depressed Mood ?',
    'Do you experience Slow Wound Healing ?',
    'Do you experience Poor Muscle Strength ?'
  ];
  List<String> _images = [
    'https://firebasestorage.googleapis.com/v0/b/loginpage-5c70d.appspot.com/o/boneache.png?alt=media&token=b2f73fd3-b570-40f4-b17e-afa972544f16',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrPy3AFqkboGOolZvwGqY-v7tCji471VXE8A&usqp=CAU',
    'https://firebasestorage.googleapis.com/v0/b/loginpage-5c70d.appspot.com/o/boneache.png?alt=media&token=b2f73fd3-b570-40f4-b17e-afa972544f16',
    'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202108/dengue_kid.jpg?hMov.5X_w.xd3NZ26oY6EU2mtyy3bffo&size=770:433',
    'https://firebasestorage.googleapis.com/v0/b/loginpage-5c70d.appspot.com/o/depressedmood.png?alt=media&token=7d1cb18f-920c-4989-811c-6a6159e56de4',
    'https://firebasestorage.googleapis.com/v0/b/loginpage-5c70d.appspot.com/o/slowwoundhealing.png?alt=media&token=bf4f96f4-cc50-455f-aa2f-e02a1b0db721',
    'https://now.tufts.edu/sites/default/files/210209_sarcopenia_fielding_lg.jpg',

  ];
  List<Color> _colors = [
    Color(0xFF00A8D5),
    Color(0xFF00A8D5),
    Color(0xFF00A8D5),
    Color(0xFF00A8D5),
    Color(0xFF00A8D5),
    Color(0xFF00A8D5),
    Color(0xFF00A8D5)
  ];

  @override
  void initState() {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(text: _names[i], color: _colors[i],image: _images[i]),
          likeAction: () {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Liked ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          nopeAction: () {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Nope ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          superlikeAction: () {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Superliked ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Symptoms Assessment'),
        ),
        drawer: MainDrawer(),
        bottomNavigationBar: MyBottomNavBar(),
        body: Container(
            child: Column(children: [
              Container(
                height: 550,
                child: SwipeCards(
                  matchEngine: _matchEngine,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: _swipeItems[index].content.color,
                    child: Center(
                      child: Column(
                        children: [
                          Image.network(_swipeItems[index].content.image,),
                          Text(
                            _swipeItems[index].content.text,
                            style: TextStyle(fontSize: 42,),
                            maxLines: 6,
                          ),
                        ],
                      )
                    ),
                    );
                  },
                  onStackFinished: () {
                    setState(() {
                      // _isavailable = !_isavailable;
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Stack Finished"),
                      duration: Duration(milliseconds: 500),
                    ));
                    if(count >= 3){
                      showDialog(context: context,
                          builder: (BuildContext context){
                            return CustomDialogBox(
                              title: "Chat Result",
                              descriptions: "You have selected some symptoms of Vitamin-D. You can calculate your Vitamin-D and verify for better health",
                              text: "Check Now",
                              img: Image.asset("assets/mid.png"),
                            );
                          }
                      );
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
                    }else{
                      showDialog(context: context,
                          builder: (BuildContext context){
                            return CustomDialogBox(
                              title: "Chat Result",
                              descriptions: "You have not selected any symptoms of Vitamin-D. You can continue your Vitamin-D diet for better health",
                              text: "Check Now",
                              img: Image.asset("assets/mid.png"),
                            );
                          }
                      );
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                  height: 100.0,
                  width: 100.0,
                  child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                      onPressed: () {
                        _matchEngine.currentItem.nope();
                        count = count-1;
                      },
                      child: Column(
                        children: [
                          Icon(Icons.assignment_turned_in, size: 30,),
                          Text('NO',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ],
                      ),
                  ),
                  ),
                  ),
                  // RaisedButton(
                  //     onPressed: () {
                  //       _matchEngine.currentItem.superLike();
                  //     },
                  //     child: Text("Superlike")),
            Container(
                height: 100.0,
                width: 100.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                      onPressed: () {
                        _matchEngine.currentItem.like();
                        count = count+1;
                      },
                    child: Column(
                      children: [
                        Icon(Icons.assignment_late_outlined,size: 30,),
                        Text('YES',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ],
                    ),  ),
                ),),
                ],
              ),
              Visibility(
                visible: _isavailable,
                child: RaisedButton(
                  onPressed: (){

                    if(count >= 3){
                      showDialog(context: context,
                          builder: (BuildContext context){
                            return CustomDialogBox(
                              title: "Chat Result",
                              descriptions: "You have selected some symptoms of Vitamin-D. You can calculate your Vitamin-D and verify for better health",
                              text: "Check Now",
                              img: Image.asset("assets/mid.png"),
                            );
                          }
                      );
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
                    }
                  },
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.pink,Colors.redAccent]
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 100.0,maxHeight: 40.0,),
                      alignment: Alignment.center,
                      child: Text(
                        "Analyze",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ),
                ),),
            ])));
  }
}
