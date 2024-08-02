import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnpsc/core/constant.dart';
import 'package:tnpsc/home/home_page.dart';
import 'package:tnpsc/login/root_alert.dart';
import 'package:tnpsc/login/welcome_page.dart';
import 'login/login_page.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  // await SPUtil?.getInstance();
  // FlutterDownloader.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool deviceRooted=false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:getUserToken(),
    builder: (BuildContext context, AsyncSnapshot<HashMap<String,String>> snapshot) {
          if(snapshot.data!=null) {
            Constants.AUTH_TOKEN = snapshot.data!["token"].toString()!;
            Constants.USER_TYPE = snapshot.data!["type"].toString()!;
            Constants.CENTER_CODE = snapshot.data!["center"].toString()!;
            if(Constants.CENTER_CODE.startsWith("0101")){
              Constants.isChennaiCenter=true;
            }else{
              Constants.isChennaiCenter=false;
            }
            Constants.USER_NAME=snapshot.data!["USER_NAME"].toString()!;
            Constants.USER_EMAIL=snapshot.data!["USER_EMAIL"].toString()!;
            Constants.USER_CONTACT=snapshot.data!["USER_CONTACT"].toString()!;
            Constants.USER_DISTRICT=snapshot.data!["USER_DISTRICT"].toString()!;
            Constants.USER_CENTER=snapshot.data!["USER_CENTER"].toString()!;
            Constants.USER_VENUE=snapshot.data!["USER_VENUE"].toString()!;
            Constants.USER_ADDRESS=snapshot.data!["USER_ADDRESS"].toString()!;
            Constants.USER_EXAM_DATE=snapshot.data!["USER_EXAM_DATE"].toString()!;
            Constants.USER_MEETING_DATE=snapshot.data!["USER_MEETING_DATE"].toString()!;
            deviceRooted= snapshot.data!["ROOTED"].toString()=="true" || snapshot.data!["DEVELOPERMODE"].toString()=="true"?true:false;
          }
      return MaterialApp(
        navigatorKey: navigatorKey, // important
        home: snapshot.hasData? (deviceRooted?RootAlertPage():Constants.AUTH_TOKEN==""?LoginPage():HomePage(currentIndex: 0,)):WelcomePage(),
      debugShowCheckedModeBanner: false,
      );// your widget
    }
    );
  }
  Future<HashMap<String,String>> getUserToken() async {
      HashMap<String,String> userPref=new HashMap<String,String>();
      SharedPreferences pref = await SharedPreferences.getInstance();
      String userToken = pref.getString('AUTH_TOKEN')??"";
      userPref["token"]=userToken;
      String userType = pref.getString('USER_TYPE')??"";
      userPref["type"]=userType;
      String centerCode = pref.getString('CENTER_CODE')??"";
      userPref["center"]=centerCode;
      userPref["USER_NAME"]=pref.getString(
          "USER_NAME")??"";
      userPref["USER_EMAIL"]=pref.getString(
          "USER_EMAIL")??"";
      userPref["USER_CONTACT"]=pref.getString(
          "USER_CONTACT")??"";
      userPref["USER_DISTRICT"]=pref.getString(
          "USER_DISTRICT")??"";
      userPref["USER_CENTER"]=pref.getString(
          "USER_CENTER")??"";
      userPref["USER_VENUE"]=pref.getString(
          "USER_VENUE")??"";
      userPref["USER_ADDRESS"]=pref.getString(
          "USER_ADDRESS")??"";
      userPref["USER_EXAM_DATE"]=pref.getString(
          "USER_EXAM_DATE")??"";
      userPref["USER_MEETING_DATE"]=pref.getString(
          "USER_MEETING_DATE")??"";
      bool jailbroken=false;
      bool developerMode=false;
      // // Platform messages may fail, so we use a try/catch PlatformException.
      // try {
      //   jailbroken = await FlutterJailbreakDetection.jailbroken;
      //   developerMode = await FlutterJailbreakDetection.developerMode;
      //   debugPrint(jailbroken.toString()+" ffffffffffffffffffffffffff "+developerMode.toString());
      // } on PlatformException {
      //   jailbroken = true;
      //   developerMode = true;
      // }
      userPref["ROOTED"]=jailbroken.toString();
      userPref["DEVELOPERMODE"]=developerMode.toString();
      return userPref;
  }

}
