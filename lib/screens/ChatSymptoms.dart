import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_dialog_box.dart';
import 'ChatList.dart';
import 'my_bottom_nav_bar.dart';
class ChatSymptoms extends StatefulWidget {
  const ChatSymptoms({Key key}) : super(key: key);

  @override
  _ChatSymptomsState createState() => _ChatSymptomsState();
}

class _ChatSymptomsState extends State<ChatSymptoms> {
  var questionindex = 1,chatindex;
  var top1 = 20.0;
  var left1 = 20.0;
  List<ChatList> chatlist = [];
  var count =0;
  bool _btnisavail = false;
  List<String> questionslist = [
    'Do you experience Bone Ache \n Back Aches',
    'Do you experience Chronic Fatigue \n (lack of sleep or excess sleep)',
    'Do you experience Fragile Bones',
    'Do you experience Frequent Cold \n Infections',
    'Do you experience Depressed Mood',
    'Do you experience Slow \nWound Healing',
    'Do you experience Poor \nMuscle Strength ?'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatlist.add(ChatList("image",'Do you experience Bone Ache \n Back Aches', "bot"));
    setState(() {

    });
  }
  void rightanswer(){
    if(questionindex == 6){
      _btnisavail = !_btnisavail;
    }
      chatlist.add(ChatList("value", "Yes", "user"));
    setState(() {

    });
      chatlist.add(ChatList("image", questionslist[questionindex], "bot"));
      questionindex = questionindex + 1;
      count = count + 1;
      print(questionindex);
      setState(() {

      });


  }
  void wronganswer(){
    if(questionindex == 6){
      _btnisavail = !_btnisavail;
    }
      chatlist.add(ChatList("value", "No", "user"));
      setState(() {

      });
      chatlist.add(ChatList("image", questionslist[questionindex], "bot"));
      questionindex = questionindex + 1;
      count = count - 1;
      setState(() {

      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms Assessment'),
        centerTitle: true,
      ),
      bottomNavigationBar: MyBottomNavBar(),
      body:SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF00A8D5),
                const Color(0xFFFFFFFF),

              ],),),
        child:
      Column(
        children:<Widget>[
        Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children: <Widget>[
          SingleChildScrollView(
            reverse: true,
            child: Container(
              height: MediaQuery.of(context).size.height*0.75,
              child: chatlist.length == 0 ? new Text("No Items Added") : new ListView.builder(
                  itemCount: chatlist.length,
                  itemBuilder: (_, index){
                    if(chatlist[index].usertype == 'bot') {
                      return _buildChip(chatlist[index].message, Color(0xFFff6666), "bot");
                    }else{
                      return _buildChip(chatlist[index].message, Color(0xFFff6666), "user");
                    }
                  }
              ),
            ),
          ),

          // Column(
          //   children: <Widget>[
          //     _buildChip('Do you experience Bone Ache \n Back Aches', Color(0xFFff6666)),
          //     _buildChip('Do you experience Chronic Fatigue \n (lack of sleep or excess sleep)', Color(0xFF5f65d3)),
          //     _buildChip('Do you experience Fragile Bones', Color(0xFFff6666)),
          //     _buildChip('Do you experience Frequent Cold \n Infections', Color(0xFF5f65d3)),
          //     _buildChip('Do you experience Depressed Mood', Color(0xFFff6666)),
          //     _buildChip('Do you experience Slow \nWound Healing', Color(0xFF5f65d3)),
          //     _buildChip('Do you experience Poor \nMuscle Strength ?', Color(0xFFff6666)),
          //   ],
          // )

        ],
      ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: (){
                  rightanswer();
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.assignment_turned_in,color: Colors.red,size: 30,),
                    Text('Yes',style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),)
                  ],
                ) ,
              ),

              Spacer(),
              Visibility(
                visible: _btnisavail,
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
               Spacer(),
              InkWell(
                onTap: (){
                  wronganswer();
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.cancel,color: Colors.green,size: 30,),
                    Text('No',style: TextStyle(color: Colors.green,fontSize: 18,fontWeight: FontWeight.bold),)
                  ],
                ),
              )

            ],
          )
      ]
      ),),
      // body: Container(
      //   height: MediaQuery.of(context).size.height,
      //   child: chatlist.length == 0 ? new Text("No Items Added") : new ListView.builder(
      //       itemCount: chatlist.length,
      //       itemBuilder: (_, index){
      //         return PostsUI(chatlist[index].message, chatlist[index].image, chatlist[index].usertype);
      //       }
      //   ),
      // )

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
  Widget _buildChip(String message, Color color,String type) {
if(type == 'user') {
  if(message == 'Yes'){
    return Row(
      children: [
        Spacer(),
        Chip(
          labelPadding: EdgeInsets.all(2.0),
          avatar: CircleAvatar(
            backgroundColor: Colors.white70,
            child: Text(message[0].toUpperCase()),
          ),
          label: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            maxLines: 3,
          ),
          backgroundColor: Colors.green,
          elevation: 6.0,
          shadowColor: Colors.grey[60],
          padding: EdgeInsets.all(8.0),
        )
      ],
    );
  }else{
    return Row(
      children: [
        Spacer(),
        Chip(
          labelPadding: EdgeInsets.all(2.0),
          avatar: CircleAvatar(
            backgroundColor: Colors.white70,
            child: Text(message[0].toUpperCase()),
          ),
          label: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            maxLines: 3,
          ),
          backgroundColor: Colors.redAccent,
          elevation: 6.0,
          shadowColor: Colors.grey[60],
          padding: EdgeInsets.all(8.0),
        )
      ],
    );
  }

}   else{
  return Row(
    children: [
      Chip(
        labelPadding: EdgeInsets.all(2.0),
        avatar: CircleAvatar(
          backgroundColor: Colors.white70,
          child: Text(message[0].toUpperCase()),
        ),
        label: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          maxLines: 3,
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      ),
      Spacer(),
    ],
  );
}

  }


}
