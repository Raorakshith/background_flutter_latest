import 'dart:async';

import 'package:background_flutter_latest/screens/Posts1.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodData extends StatefulWidget {
  @override
  _FoodDataState createState() => _FoodDataState();
}

class _FoodDataState extends State<FoodData> {
  var screenWidth;
  List<Posts1> foodlist = [];
  List<Posts1> selectedfoodlist = [];
  bool searchstate = false;
  //List<String> columns = ['Flag','Name','Native Name'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final referenceDatabase = FirebaseDatabase.instance;
    final ref = referenceDatabase.reference().child("Food List");
    ref.once().then((DataSnapshot snap) {
      var Keys = snap.value.keys;
      var Data = snap.value;
      //postsList.clear();
      for (var individualkey in Keys) {
        Posts1 posts = new Posts1(
            Data[individualkey]['code'],
            Data[individualkey]['item'],
            Data[individualkey]['vitd'],
            Data[individualkey]['quantity'],
        );
        foodlist.add(posts);
      }
      setState(() {
        print('Length: $foodlist.length');
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: new AppBar(
        title: !searchstate ? new Text('Food Chart'):
                              new TextField(
                                decoration: InputDecoration(icon: Icon(Icons.search,color:Colors.white),
                                  hintText:"Search...",
                                  hintStyle: TextStyle(color:Colors.white),
                                ),
                                style: TextStyle(color: Colors.white),
                                onChanged: (text){
                                  SearchMethod(text);
                                },
                              ),
        centerTitle: true,
        actions: <Widget>[
          !searchstate?IconButton(icon: Icon(Icons.search,color: Colors.white,),onPressed: (){
            setState(() {
              searchstate = !searchstate;
            });
          }):
          IconButton(icon: Icon(Icons.cancel,color: Colors.white,),onPressed: (){
            setState(() {
              searchstate = !searchstate;
            });
          }),
        ],
      ),
      body: foodlist.isEmpty
          ?Center(child: CircularProgressIndicator())
          :Column(
        children: [
          Expanded(child:SingleChildScrollView(child: buildDataTable(),physics: BouncingScrollPhysics(),scrollDirection: Axis.vertical,)) ,
          buildSubmit(),
        ],
      ),
    );
  }

  Widget buildDataTable() {
    final columns = ['Item','Quantity','Vitamin D\n  (mcg)'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(foodlist),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
             label: Text(column),
      )).toList();

  List<DataRow> getRows(List<Posts1> foodlist) => 
    foodlist.map((Posts1 food) => DataRow(
      selected: selectedfoodlist.contains(food),
      onSelectChanged: (isSelected)=> setState((){
        final isAdding = isSelected != null && isSelected;
        isAdding
           ? selectedfoodlist.add(food)
           : selectedfoodlist.remove(food);
      }),
      cells: [
        DataCell(Container(width:screenWidth*0.15, child: Text(food.item))),
        DataCell(Container(width: screenWidth*0.15, child: Text(food.quantity))),
        DataCell(Container(width: screenWidth*0.15, child: Text((double.parse(food.vitd)/1.7).toStringAsFixed(2)))),
      ],
    )).toList();


 Widget buildSubmit() => Container(
   width: double.infinity,
   padding: EdgeInsets.all(12),
   color: Colors.black,
   child: ElevatedButton(
     style: ElevatedButton.styleFrom(
       shape: StadiumBorder(),
       minimumSize: Size.fromHeight(40),
     ),
     child: Text('Select ${selectedfoodlist.length} Food'),
     onPressed: (){
       final foods = selectedfoodlist.map((food) => food.item).join(',');
       for(int i=0;i<selectedfoodlist.length;i++){
         final foodcode = selectedfoodlist.elementAt(i).code;
         final item = selectedfoodlist.elementAt(i).item;
         final vitd = (double.parse(selectedfoodlist.elementAt(i).vitd)/1.7).toStringAsFixed(2);
         final quantity = selectedfoodlist.elementAt(i).quantity;
         final referenceDatabase2 = FirebaseDatabase.instance;
         final ref2 = referenceDatabase2.reference().child("Food List").child(foodcode);
         final ref3 = referenceDatabase2.reference().child("User Data").child("Food Datas").child(foodcode);
         ref3.set({'code':foodcode,'item':item,'vitd':vitd,'quantity':quantity}).whenComplete(() async{
           await Fluttertoast.showToast(msg: foodcode,toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
           //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile2()));
         });
         // ref2.once().then((DataSnapshot data){
         //   ref3.set(data.value);
         // });
         print(foodcode);

       }
       //Fluttertoast.showToast(msg: foods,toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM ,backgroundColor: Colors.grey,textColor: Colors.white);
     },
   ),
 );

  void SearchMethod(String text) {
    DatabaseReference searchRef = FirebaseDatabase.instance.reference().child("Food List");
    searchRef.once().then((DataSnapshot snapshot){
      foodlist.clear();
      var keys = snapshot.value.keys;
      var values = snapshot.value;
      for(var key in keys){
        Posts1 posts = new Posts1(
          values[key]['code'],
          values[key]['item'],
          values[key]['vitd'],
          values[key]['quantity'],
        );
        if(posts.item.toLowerCase().contains(text.toLowerCase())){
          foodlist.add(posts);
        }
      }
      Timer(Duration(seconds: 1),(){
        setState(() {

        });
      });
    });
  }
}
