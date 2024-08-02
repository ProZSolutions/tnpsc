import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnpsc/core/constant.dart';
import 'package:tnpsc/core/meta.dart';
import 'package:tnpsc/core/tnpsc_Core.dart';
import 'package:tnpsc/home/home_page.dart';
import 'package:tnpsc/login/login_page.dart';
import 'package:tnpsc/theme/customIcons.dart';
import 'package:tnpsc/view/exam/alertbox.dart';

class MorePage extends StatefulWidget {
  String userName="";
  String email="";
  MorePage({Key? key,this.userName="",this.email=""}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  int check1 = 0;
  int check2 = 0;
  int check3 = 0;
  bool checkedValue = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MoreDetailPage( name:'My Profile',)));
                        },
                        child: Container(
                            height: 80,
                            child: Center(
                              child: ListTile(
                                leading: Icon(CustomIcons.female_avatar_and_circle22),
                                title: Text(widget.userName),
                                subtitle: Text(widget.email),
                                trailing:IconButton(
                                  icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                                  onPressed: (){
                                  },
                                )
                              ),
                            )
                        ),
                      )
                  ),
                  Visibility(visible:(Constants.USER_TYPE!="is_vd"),child: Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MoreDetailPage( name:'Venue',)));
                        },
                        child: Container(
                            height: 80,
                            child: Center(
                              child: ListTile(
                                  leading: Icon(Icons.location_on_outlined,color: Colors.green[900]),
                                  title: Text("Venue"),
                                  trailing:IconButton(
                                    icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                                    onPressed: (){
                                    },
                                  )
                              ),
                            )
                        ),
                      )
                  )),
                Card(
                child:  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () async{
                      Map<String, dynamic> userData = new Map<String, dynamic>();
                      TNPSCService service = new TNPSCService();
                      Meta m = await service.processPostURL(
                          Constants.BaseUrlDev + "/logout", userData,
                          Constants.AUTH_TOKEN);
                      if (m.statusCode == 200) {
                        if(m.response["status"]=="success") {
                          final SharedPreferences prefs = await _prefs;
                          prefs.setString("AUTH_TOKEN", "");
                          prefs.setString("USER_TYPE", "");
                          prefs.setString("CENTER_CODE", "");
                          Constants.AUTH_TOKEN = "";
                          Constants.USER_TYPE="";
                          Constants.CENTER_CODE="";
                          Constants.isChennaiCenter=false;
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

                          Navigator.popUntil(context,
                              ModalRoute.withName('/login'));
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginPage()));
                        }
                      }
                    },
                    child:Container(
    height: 80,
    child: Center(
    child: ListTile(
                        leading:Icon(Icons.logout,color: Colors.green[900]),
                        title: Text('Logout'),
                        trailing:IconButton(
                          icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                          onPressed: (){
                            // Navigator.popUntil(context, ModalRoute.withName('/login'));
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                        )
                    ))))
    ),
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                      Visibility(visible:false,child:Center(
                          child: ListTile(
                            leading:Icon(Icons.location_on_outlined,color: Colors.green[900]),
                            title: Text('Venue'),
                            trailing:IconButton(
                              icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewPage( name:'Venue',)));
                              },
                            )
                          ),
                        )),
          Visibility(visible:false,child:Center(
                          child: ListTile(
                            leading:Icon(Icons.people_outline,color: Colors.green[900]),
                            title: Text('Assistant'),
                            trailing:IconButton(
                              icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewPage( name:'Assistant',)));
                              },
                            )
                          ),
                        )),
          Visibility(visible:false,child:Center(
                          child: ListTile(
                            leading:Icon(Icons.people_outline,color: Colors.green[900]),
                            title: Text('Staff'),
                            trailing:IconButton(
                              icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewPage( name:'Staff',)));
                              },
                            )
                          ),
                        )),
                        Visibility(visible:false,child: Center(
                          child: ListTile(
                            leading:Icon(Icons.location_on_outlined,color: Colors.green[900]),
                            title: Text('Scribles'),
                            trailing:IconButton(
                              icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewPage( name:'Scribles',)));
                              },
                            )
                          ),
                        )),
          Visibility(visible:false,child:Center(
                          child: ListTile(
                            leading:Icon(Icons.contact_page_outlined,color: Colors.green[900]),
                            title: Text('Contact'),
                            trailing:IconButton(
                              icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewPage( name:'Scribles',)));
                              },
                            )
                          ),
                        )),
          Visibility(visible:false,child:Center(
                          child: ListTile(
                            leading:Icon(Icons.notifications_none_outlined,color: Colors.green[900]),
                            title: Text('Notification'),
                            trailing:IconButton(
                             icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewPage( name:'Notification',)));
                              },
                            )
                          ),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Visibility(visible:false,child:Padding(
                    padding: EdgeInsets.zero,
                    child: Card(
                        child:  InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            print('User');
                          },
                          child: Container(
                              height: 60,
                              child: Center(
                                child:
                                InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () async{
                                        Map<String, dynamic> userData = new Map<String, dynamic>();
                                        TNPSCService service = new TNPSCService();
                                        Meta m = await service.processPostURL(
                                            Constants.BaseUrlDev + "/logout", userData,
                                            Constants.AUTH_TOKEN);
                                        if (m.statusCode == 200) {
                                          if(m.response["status"]=="success") {
                                            final SharedPreferences prefs = await _prefs;
                                            prefs.setString("AUTH_TOKEN", "");
                                            prefs.setString("USER_TYPE", "");
                                            prefs.setString("CENTER_CODE", "");
                                            Constants.AUTH_TOKEN = "";
                                            Constants.USER_TYPE="";
                                            Constants.CENTER_CODE="";
                                            Constants.isChennaiCenter=false;
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

                                            Navigator.popUntil(context,
                                                ModalRoute.withName('/login'));
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()));                                          }
                                        }
                                      },
                                child: ListTile(
                                  leading:Icon(Icons.logout,color: Colors.green[900]),
                                  title: Text('Logout'),
                                  trailing:IconButton(
                                    icon:  Icon(Icons.arrow_forward_ios_outlined,size: 14,color: Colors.grey,),
                                    onPressed: (){
                                      // Navigator.popUntil(context, ModalRoute.withName('/login'));
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                    },
                                  )
                                )),
                              ),
                          ),
                        )
                    ),
                  ))
                ],
              ),
            )
        )
    );
  }
}

class MoreDetailPage extends StatefulWidget {
  String name="";
  MoreDetailPage({this.name=""});
  @override
  _MoreDetailPageState createState() => _MoreDetailPageState();
}

class _MoreDetailPageState extends State<MoreDetailPage> {
  Map<String,dynamic> resultData={};

  late Future<Meta> _future;
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    Meta ed;
    _future.then((value){
      ed=value;
      if(ed!=null) {
        Meta m=ed??new Meta();
        if (m.statusCode == 200) {
          setState(() {
            resultData = m.response["data"]??{};
          });

        }
      }

    });
    super.initState();
  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    if(widget.name=="Venue"){
      Meta m = await service.processGetURL(
          Constants.BaseUrlDev + "/venue-profile", Constants.AUTH_TOKEN);
      return m;
    }else {
      Meta m = await service.processGetURL(
          Constants.BaseUrlDev + "/user-details", Constants.AUTH_TOKEN);
      return m;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text(widget.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: Constants.USER_TYPE=="is_vd"?1:3)));
            },
          ),
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: widget.name=="Venue"?Column(
                children: <Widget>[
                  Card(
                     child:Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Center(
                            child: ListTile(
                              leading: Icon(Icons.location_on,color: Colors.green,),
                              title: Text(resultData["district"]!=null?resultData["district"]:""),
                              trailing: Icon(Icons.check,color: Colors.white,),
                            ),
                          )
                      ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    child:Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.location_city,color: Colors.green,),
                            title: Text(resultData["center"]!=null?resultData["center"]:""),
                            trailing: Icon(Icons.check,color: Colors.white,),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    child:Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.home,color: Colors.green,),
                            title: Text(resultData["venue_name"]!=null?resultData["venue_name"]:""),
                            trailing: Icon(Icons.check,color: Colors.white,),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    child:Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.mail,color: Colors.green,),
                            title: Text(resultData["address"]!=null?resultData["address"]:""),
                            trailing: Icon(Icons.check,color: Colors.white,),
                          ),
                        )
                    ),
                  )
                ],
              ):Column(
                children: <Widget>[
                  Card(
                    child:Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.account_circle,color: Colors.green,),
                            title: Text(resultData["name"]!=null?resultData["name"]:""),
                            trailing: Icon(Icons.check,color: Colors.white,),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    child:Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.mail,color: Colors.green,),
                            title: Text(resultData["mail"]!=null?resultData["mail"]:""),
                            trailing: Icon(Icons.check,color: Colors.white,),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    child:Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.local_phone,color: Colors.green,),
                            title: Text(resultData["contact"]!=null?resultData["contact"]:""),
                            trailing: Icon(Icons.check,color: Colors.white,),
                          ),
                        )
                    ),
                  )
                ],
              ),
            )
          //],
          //),
          //)
        ));
  }
}
class NewPage extends StatelessWidget {
  const NewPage({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text("${name}",),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: Constants.USER_TYPE=="is_vd"?1:3)));
            },
          ),
        ),
        body: Container(),
      ),
    );
  }
}
