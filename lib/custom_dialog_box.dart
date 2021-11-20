import 'dart:ui';
import 'package:background_flutter_latest/constants.dart';
import 'package:background_flutter_latest/screens/comparison.dart';
import 'package:background_flutter_latest/screens/recommendations.dart';
import 'package:background_flutter_latest/screens/recommendationsmoderate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;

  const CustomDialogBox({Key key, this.title, this.descriptions, this.text, this.img}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
              + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(color: Colors.black,offset: Offset(0,10),
              blurRadius: 10
              ),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Text(widget.descriptions,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
              SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: (){
                      if(widget.descriptions.contains("You have sufficient level of Vitamin-D. Follow your diets regularly")) {
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Recommend()));
                      }else if(widget.descriptions.contains("You have insufficient Vitamin-D. Please go through our suggestions")){
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendModerate()));
                      }else if(widget.descriptions.contains("You have selected some symptoms of Vitamin-D. You can calculate your Vitamin-D and verify for better health")){
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Compare()));
                      }
                      else{
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Recommend()));
                      }
                    },
                    child: Text(widget.text,style: TextStyle(fontSize: 18),)),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: widget.img,
              ),
            ),
        ),
      ],
    );
  }
}
