import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnpsc/core/constant.dart';
import 'package:tnpsc/core/meta.dart';
import 'package:tnpsc/core/tnpsc_Core.dart';
import 'package:tnpsc/core/tnpsc_utils.dart';
import 'package:tnpsc/home/home_page.dart';
import 'package:tnpsc/theme/fonts.dart';
import 'package:tnpsc/theme/styles.dart';

class LoginPage extends StatefulWidget {
   @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _userName;
  late String _password;
  bool checkedValue = false;
  TNPSCUtils util=new TNPSCUtils();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child:
      Center(
        child:
        IntrinsicHeight(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.35)),
              getLogo(),
              getLoginForm(),
              Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: ButtonTheme(
                  height: MediaQuery.of(context).size.height * 0.06,
                minWidth: MediaQuery.of(context).size.width * 0.9,
                 child: RaisedButton(
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                   elevation: 1,
                    color: Colors.green[900],
                    onPressed: () async{
                      debugPrint("service calllllllllllllllll");
                      Map<String,dynamic> userData=new Map<String,dynamic>();
                      userData["username"]=_userName;
                      userData["password"]=_password;
                      bool isNetworkAvailable = await TNPSCUtils().isInternetConnected();
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text(_userName+" "+isNetworkAvailable.toString()),
                      // ));
                      TNPSCService service=new TNPSCService();
                      Meta m=await service.processPostURL(Constants.BaseUrlDev+"/authenticate", userData, "5|4PORSXEyJjjmAD9Tqs0975MzutYzODbK5zCiZxpi");
                      debugPrint("flutteservice callllll"+m.statusCode.toString()+" "+m.statusMsg);
                      if(m.statusCode==200){
                        debugPrint(m.response.toString());
                        Map<String,dynamic> response=m.response;
                        debugPrint(response["status"]);
                        if(response["status"]=="success") {
                          final SharedPreferences prefs = await _prefs;
                          prefs.setString("AUTH_TOKEN", response["access_token"]);
                          prefs.setString("USER_TYPE", response["user_type"]);
                          Constants.CENTER_CODE="";
                          if(response["center_code"]!=null) {
                            prefs.setString(
                                "CENTER_CODE", response["center_code"]);
                            Constants.CENTER_CODE=response["center_code"];
                          }
                          Constants.AUTH_TOKEN=response["access_token"];
                          Constants.USER_TYPE=response["user_type"];
                          if(Constants.CENTER_CODE.startsWith("0101")){
                            Constants.isChennaiCenter=true;
                          }else{
                            Constants.isChennaiCenter=false;
                          }

                          Constants.USER_NAME="";
                          Constants.USER_EMAIL="";
                          Constants.USER_CONTACT="";
                          Constants.USER_DISTRICT="";
                          Constants.USER_CENTER="";
                          Constants.USER_VENUE="";
                          Constants.USER_ADDRESS="";
                          Constants.USER_EXAM_DATE="";
                          Constants.USER_MEETING_DATE="";
                          prefs.setString(
                              "USER_NAME", "");
                          prefs.setString(
                              "USER_EMAIL", "");
                          prefs.setString(
                              "USER_CONTACT", "");
                          prefs.setString(
                              "USER_DISTRICT", "");
                          prefs.setString(
                              "USER_CENTER", "");
                          prefs.setString(
                              "USER_VENUE", "");
                          prefs.setString(
                              "USER_ADDRESS", "");
                          prefs.setString(
                              "USER_EXAM_DATE", "");
                          prefs.setString(
                              "USER_MEETING_DATE", "");

                          if(response["user_data"]!=null) {
                            Constants.USER_NAME=response["user_data"]["name"];
                            Constants.USER_EMAIL=response["user_data"]["mail"]==null?"": response["user_data"]["mail"];
                            Constants.USER_CONTACT=response["user_data"]["contact"]==null?"": response["user_data"]["contact"];
                            prefs.setString(
                                "USER_NAME", Constants.USER_NAME);
                            prefs.setString(
                                "USER_EMAIL",Constants.USER_EMAIL);
                            prefs.setString(
                                "USER_CONTACT",Constants.USER_CONTACT);
                          }

                          if(response["venue_data"]!=null) {
                            Constants.USER_DISTRICT=response["venue_data"]["district"]==null?"":response["venue_data"]["district"];
                            Constants.USER_CENTER=response["venue_data"]["center"]==null?"": response["venue_data"]["center"];
                            Constants.USER_VENUE=response["venue_data"]["venue_name"]==null?"": response["venue_data"]["venue_name"];
                            Constants.USER_ADDRESS=response["venue_data"]["address"]==null?"": response["venue_data"]["address"];
                            prefs.setString(
                                "USER_DISTRICT", Constants.USER_DISTRICT);
                            prefs.setString(
                                "USER_CENTER",Constants.USER_CENTER);
                            prefs.setString(
                                "USER_VENUE",Constants.USER_VENUE);
                            prefs.setString(
                                "USER_ADDRESS",Constants.USER_ADDRESS);

                          }
                          if(response["exam_data"]!=null) {
                            Constants.USER_EXAM_DATE=response["exam_data"]["exam_date"]==null?"":response["exam_data"]["exam_date"];
                            Constants.USER_MEETING_DATE=response["exam_data"]["meeting_date"]==null?"": response["exam_data"]["meeting_date"];
                            prefs.setString(
                                "USER_EXAM_DATE", Constants.USER_EXAM_DATE);
                            prefs.setString(
                                "USER_MEETING_DATE",Constants.USER_MEETING_DATE);
                          }

                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HomePage()));
                        }else{
                          //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Invalid username/password"),
                          ));
                        }
                      }else{
                        Map<String,dynamic> response=jsonDecode(m.statusMsg);
                        //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(response["message"]),
                        ));
                      }
                    },
                    child: Text("LOGIN",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                  )

              )
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                      child: CheckboxListTile(
                        title: Text('Remember me'),
                        value: checkedValue,
                        activeColor: Colors.green[900],
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      ),),
                    TextButton(
                      onPressed: () {},
                      child: Text('Forgot Password?',style: TextStyle(color: Colors.green[900]),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
      )
    );
  }

  Widget getLogo(){
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 7,
          width: MediaQuery.of(context).size.width / 3.0,
          decoration: BoxDecoration(),
          child:Image.asset('assets/images/ems_logo.png'),),
        Padding(
          padding: EdgeInsets.zero,
          child: Text('TNPSC',
            style: TextStyle(
              fontSize: Styles.textSizTwenty,
              fontWeight: FontSizeData.fontWeightValueLarge,
            ),),
        )
      ],
    );
  }

  Widget getLoginForm(){
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Login To Your Account',
                      style: TextStyle(
                        fontSize: Styles.textSizeSeventeen,
                        fontWeight: FontSizeData.fontWeightValueLarge,
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                margin: EdgeInsets.all(20),
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: TextFormField(
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'User Name is Empty';
                      }
                      else{
                        return null;}
                    },
                    onChanged: (value){
                      _userName=value;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'User Name',
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.only(top: 10,left: 15,right: 15),
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is Empty';
                      }
                      else{
                        return null;}
                    },
                    onChanged: (value){
                      _password=value;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      labelText: 'Password',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
