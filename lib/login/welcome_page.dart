
import 'package:flutter/material.dart';
import 'package:tnpsc/theme/fonts.dart';
import 'package:tnpsc/theme/styles.dart';

class WelcomePage extends StatefulWidget {
   @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
            child: Text('Welcome to TNPSC',
              style: TextStyle(
                color:Colors.green[900],
                fontSize: 30,
                fontWeight: FontSizeData.fontWeightValueLarge,
              ),),
          ),

        ],
      ) )
    )
    );
  }
}
