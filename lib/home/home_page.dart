import 'package:flutter/material.dart';
import 'package:tnpsc/core/SPUtil.dart';
import 'package:tnpsc/core/constant.dart';
import 'package:tnpsc/core/meta.dart';
import 'package:tnpsc/core/tnpsc_Core.dart';
import 'package:tnpsc/theme/fonts.dart';
import 'package:tnpsc/theme/styles.dart';
import 'package:tnpsc/view/exam/exam.dart';
import 'package:tnpsc/view/exam/exam_list.dart';
import 'package:tnpsc/view/meet/meeting.dart';
import 'package:tnpsc/view/more/more.dart';

class HomePage extends StatefulWidget {
  HomePage({this.currentIndex=0});
  int currentIndex;
  @override
  _HomePageState createState() => _HomePageState(currentIndex: currentIndex);
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;
  String centerName=Constants.USER_VENUE;
  String candidates=Constants.USER_NAME;
  String examName="";
  String examDate=Constants.USER_CENTER;
  String mail=Constants.USER_EMAIL;
  var Screens =[

  ];

  late Future<Map<String,Meta>> _future;
  bool loaded=true;
  int meetingEnable=1;
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    Map<String,Meta>? ed;
    _future.then((value){
      ed=value;
      if(ed!=null) {
        Map<String,Meta>? m=ed;
        Meta? user = m!["enablemeeting"];
        // Meta? venue = m!["venue"];
        if (user?.statusCode == 200) {
          debugPrint(user?.response.toString());
          Map<String, dynamic>? response = user?.response;
          if (response?["status"] == "success") {
            if (response?["meeting_enable"] != null) {
              meetingEnable = response?["meeting_enable"] ?? 1;
              // meetingEnable=1;
              // mail = response?["data"]["mail"] ?? "";
            }
          }
        }
        // if (venue?.statusCode == 200) {
        //   debugPrint(venue?.response.toString());
        //   Map<String, dynamic>? response = venue?.response;
        //   if (response?["status"] == "success") {
        //     if (response?["data"]["venue_name"] != null) {
        //       centerName = response?["data"]["venue_name"] ?? "";
        //       examDate = response?["data"]["center"] ?? "";
        //       if(examDate.toLowerCase().contains("chennai")){
        //         Constants.isChennaiCenter=true;
        //       }
        //     }
        //   }
        // }
      }
      loaded=true;
    });
    super.initState();
  }
_HomePageState({this.currentIndex=0});
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<Map<String,Meta>>(
    //     future: _future,
    //     builder: (context, AsyncSnapshot<Map<String,Meta>> snapshot)
    //     {
          if (Constants.USER_TYPE == "is_vd") {
            Screens = [
              ExamIsVdListPage(),
              MorePage(userName: candidates, email: mail,),
            ];
            return DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HomePage(currentIndex: 0)));
                    },
                  ),
                  elevation: (currentIndex == 0) ? 0 : 0,
                  backgroundColor: Colors.green[900],
                  title: Text((currentIndex == 0) ? 'Exam'
                      : 'More'),
                ),
                body: loaded ? Screens[currentIndex] : SafeArea(
                    child: Center(child: CircularProgressIndicator())),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: currentIndex,
                  unselectedItemColor: Colors.grey,
                  showUnselectedLabels: true,
                  onTap: (index) => setState(() => currentIndex = index),
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt_rounded),
                      label: 'Exam',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.more_vert_rounded),
                      label: 'More',
                    ),
                  ],
                  selectedItemColor: Colors.green[900],
                ),
              ),
            );
          } else {
            Screens = [SafeArea(
                child: Center(child: Column(
                  children: [
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 7,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 3.0,
                      decoration: BoxDecoration(),
                      child: Image.asset('assets/images/logo.jpg'),
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.01),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Welcome to TNPSC',
                        style: TextStyle(
                          fontSize: Styles.textSizTwenty,
                          fontWeight: FontSizeData.fontWeightValueLarge,
                        ),),
                    ),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: Card(child: Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.1,
                          child: Center(
                            child: ListTile(
                              leading: Icon(
                                Icons.location_city, color: Colors.green,),
                              title: Text(centerName),
                            ),
                          ),
                        ))),
                    Visibility(visible: examName != "" ? true : false,
                        child: SizedBox(height: 5)),
                    Visibility(
                        visible: examName != "" ? true : false, child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Card(child: Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.1,
                          child: Center(
                            child: ListTile(
                              leading: Icon(
                                Icons.question_answer, color: Colors.green,),
                              title: Text(examName),
                            ),
                          ),
                        )))),
                    SizedBox(height: 5),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: Card(child: Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.1,
                          child: Center(
                            child: ListTile(
                              leading: Icon(Icons.people, color: Colors.green,),
                              title: Text(candidates.toString()),
                            ),
                          ),
                        ))),
                    SizedBox(height: 5),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: Card(child: Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.1,
                          child: Center(
                            child: ListTile(
                              leading: Icon(
                                Icons.location_on, color: Colors.green,),
                              title: Text(examDate.toString()),
                            ),
                          ),
                        ))),
                  ],
                ))),
              meetingEnable==1?MeetingListPage():SafeArea(
                  child:
                  Center(
                    child:  Text('Meeting not scheduled for today',
                                style: TextStyle(
                                  fontSize: Styles.textSizTwenty,
                                  color: Colors.redAccent,
                                  fontWeight: FontSizeData.fontWeightValueLarge,
                                ),),

                  )
              ),
              ExamListPage(),
              MorePage(userName: candidates, email: mail,),
            ];
            return DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HomePage(currentIndex: 0)));
                    },
                  ),
                  elevation: (currentIndex == 0) ? 0 : 0,
                  backgroundColor: Colors.green[900],
                  title: Text((currentIndex == 0) ? 'Dashboard'
                      : (currentIndex == 1) ? 'Meeting' : (currentIndex == 2)
                      ? 'Exam'
                      : 'More'),
                ),
                body: loaded ? Screens[currentIndex] : SafeArea(
                    child: Center(child: CircularProgressIndicator())),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: currentIndex,
                  unselectedItemColor: Colors.grey,
                  showUnselectedLabels: true,
                  onTap: (index) => setState(() => currentIndex = index),
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today_sharp),
                      label: 'Meet',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt_rounded),
                      label: 'Exam',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.more_vert_rounded),
                      label: 'More',
                    ),
                  ],
                  selectedItemColor: Colors.green[900],
                ),
              ),
            );
          }
        // }
    // );
  }
  Future<Map<String,Meta>> callAsyncMethod() async{
    Map<String,Meta> homeResult=new Map<String,Meta>();
    Map<String, dynamic> userData = new Map<String, dynamic>();
    TNPSCService service=new TNPSCService();
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/meeting-enable",userData,Constants.AUTH_TOKEN);
    // Meta m1=await service.processGetURL(Constants.BaseUrlDev+"/venue-profile",Constants.AUTH_TOKEN);
    // homeResult["user"]=m;
    homeResult["enablemeeting"]=m;
    return homeResult;
  }
}