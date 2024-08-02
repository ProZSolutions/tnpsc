
import 'package:flutter/material.dart';
import 'package:tnpsc/theme/fonts.dart';
import 'package:tnpsc/theme/styles.dart';

class RootAlertPage extends StatefulWidget {
   @override
  _RootAlertState createState() => _RootAlertState();
}

class _RootAlertState extends State<RootAlertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:
          Center(

          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top:150)),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(),
            child: Image.asset("assets/images/logo.jpg"),
          ),
          SizedBox(height: MediaQuery
              .of(context)
              .size
              .height * 0.01),
          Padding(
            padding: EdgeInsets.all(10),
            child: Align(alignment:Alignment.center,child:Text('App cannot be accessed from rooted device',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:Colors.green[900],
                fontSize: 30,
                fontWeight: FontSizeData.fontWeightValueLarge,
              ),)),
          ),

        ],
      ) )
    )
    );
  }
}
