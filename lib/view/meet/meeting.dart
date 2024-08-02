import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnpsc/core/constant.dart';
import 'package:tnpsc/core/meta.dart';
import 'package:tnpsc/core/tnpsc_Core.dart';
import 'package:tnpsc/home/home_page.dart';
import 'package:tnpsc/qr/qrPage.dart';
import 'package:tnpsc/theme/customIcons.dart';
import 'package:tnpsc/theme/fonts.dart';
import 'package:tnpsc/theme/styles.dart';
import 'package:tnpsc/view/exam/alertbox.dart';
import 'package:tnpsc/view/exam/exam.dart';

class MeetingPage extends StatefulWidget {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  List<dynamic> response=[];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: callAsyncMethod(),
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? {};
            }
          }
          if (snapshot.hasData) {
            // if(response!=null &&  response.length==0){
            //   Future(() {
            //     Navigator.pop(context);
            //     Navigator.push(context, MaterialPageRoute(builder: (context) =>
            //         NewMeet(type: 1, returnedQrCode: "",examId: 0,)));
            //   });
            //   return Text("");
            // }else {
              return SafeArea(
                  child:
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          child: Image.asset('assets/images/qr_image.png'),
                        ),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.15),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Welcome to Meeting',
                            style: TextStyle(
                              fontSize: Styles.textSizTwenty,
                              fontWeight: FontSizeData.fontWeightValueLarge,
                            ),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Scan the QR code to register your attendance',
                            style: TextStyle(
                                fontSize: Styles.textSizRegular,
                                color: Colors.grey
                            ),),
                        ),
                        SizedBox(height: 20),
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: ButtonTheme(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.06,
                                minWidth: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.9,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  elevation: 1,
                                  color: Colors.green[900],
                                  onPressed: () {
                                    setState(() {
                                      // if(response["attendance_qr"]!=null &&  response["attendance_qr"]!=""){
                                      //   Navigator.pop(context);
                                      //     Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      //        NewMeet(type: 1, returnedQrCode: "")));
                                      //
                                      // }else {
                                      Navigator.pop(context);
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (context) =>
                                                QrPage(value: 1,examId: 0,type: "meeting-attendance",)));
                                      // }
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => NewMeet()));
                                      // showDialog(
                                      //   barrierColor: Colors.black26,
                                      //   context: context,
                                      //   builder: (context) {
                                      //     return CustomAlertDialog(
                                      //       title: "Thanks for attend the meeting.",
                                      //       description: "Your attendance has been registered.",
                                      //     );
                                      //   },
                                      // );
                                      // Navigator.pop(context);

                                    }
                                    );
                                  },
                                  child: Text("CLICK TO SCAN QR ",
                                    style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),),
                                )

                            )
                        ),
                      ],
                    ),
                  )
              );
            // }
          } else {
            return Text("");
          }
        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Meta m=await service.processGetURL(Constants.BaseUrlDev+"/meeting",Constants.AUTH_TOKEN);
    return m;
  }
}

class MeetingListPage extends StatefulWidget {
  @override
  _MeetingListPageState createState() => _MeetingListPageState();
}

class _MeetingListPageState extends State<MeetingListPage> {
  List<dynamic> response= [];
  List<dynamic> attendance= [];
  List<dynamic> completedMeeting=[];
  late Future<Map<String,Meta>> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    Map<String,Meta>? ed;
    _future.then((value){
      ed=value;
      if(ed!=null) {
        Map<String, Meta>? hm=ed;
        if(hm!=null) {
          Meta? m = hm!['attendance'];
          Meta? m1 = hm!['meeting'];
          Meta? m2 = hm!['completed'];
          if (m?.statusCode == 200) {
            if (m?.response["status"] == "success") {
              attendance = m?.response["data"] ?? [];
            }

          }
          if (m1?.statusCode == 200) {
            if (m1?.response["status"] == "success") {
              response = m1?.response["data"] ?? [];
            }
          }
          if (m2?.statusCode == 200) {
            if (m2?.response["status"] == "success") {
              completedMeeting = m2?.response["data"] ?? [];
            }
          }
        }
      }
      loaded=true;
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,Meta>>(
        future: _future,
        builder: (context, AsyncSnapshot<Map<String,Meta>> snapshot)
        {
          return SafeArea(
            child:
            Center(
              child: snapshot.hasData?Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

        attendance.length==0 || attendance[0]["qr"]==null ||  attendance[0]["qr"]==""?Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.05),
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
                        child: Image.asset('assets/images/qr_image.png'),
                      ),
                      SizedBox(height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.15),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Welcome to Meeting',
                          style: TextStyle(
                            fontSize: Styles.textSizTwenty,
                            fontWeight: FontSizeData.fontWeightValueLarge,
                          ),),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Scan the QR code to register your attendance',
                          style: TextStyle(
                              fontSize: Styles.textSizRegular,
                              color: Colors.grey
                          ),),
                      ),
                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: ButtonTheme(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.06,
                              minWidth: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.9,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 1,
                                color: Colors.green[900],
                                onPressed: () {
                                  setState(() {
                                    // if(response["attendance_qr"]!=null &&  response["attendance_qr"]!=""){
                                    //   Navigator.pop(context);
                                    //     Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    //        NewMeet(type: 1, returnedQrCode: "")));
                                    //
                                    // }else {
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context) =>
                                            QrPage(value: 1,examId: 0,type: "meeting-attendance",)));
                                    // }
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => NewMeet()));
                                    // showDialog(
                                    //   barrierColor: Colors.black26,
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return CustomAlertDialog(
                                    //       title: "Thanks for attend the meeting.",
                                    //       description: "Your attendance has been registered.",
                                    //     );
                                    //   },
                                    // );
                                    // Navigator.pop(context);

                                  }
                                  );
                                },
                                child: Text("CLICK TO SCAN QR ",
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),),
                              )

                          )
                      ),
                    ],
                  ):
                  _tabSection(context)
                ],
              ):CircularProgressIndicator(),
            )
        );
        });
  }
  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.green[900],
            child: TabBar(
                indicatorWeight: 5,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(child:Text("Upcomings",style: TextStyle(backgroundColor: Colors.green[900],color:Colors.white),
                  ),),
                  Tab(child:Text("Completed",style: TextStyle(backgroundColor: Colors.green[900],color:Colors.white)),
                  )]),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height*0.76,
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    child: Column(mainAxisAlignment:MainAxisAlignment.start,children:[getMeetingNotifications()]),
                  ),
                  Container(
                    child: Column(mainAxisAlignment:MainAxisAlignment.start,children:[getCompletedMeetingNotifications()]),
                  )
                ]),
          ),
        ],
      ),
    );
  }
  Future<HashMap<String,Meta> > callAsyncMethod() async{
    HashMap<String,Meta> meetingData= HashMap<String,Meta>();
    TNPSCService service=new TNPSCService();
    Meta m=await service.processGetURL(Constants.BaseUrlDev+"/attendance-qr",Constants.AUTH_TOKEN);
    Meta m1=await service.processGetURL(Constants.BaseUrlDev+"/meeting",Constants.AUTH_TOKEN);
    Meta m2=await service.processGetURL(Constants.BaseUrlDev+"/completed-meeting",Constants.AUTH_TOKEN);

    meetingData['attendance']=m;
    meetingData['meeting']=m1;
    meetingData['completed']=m2;
    return meetingData;
  }
  Widget getMeetingNotifications(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("Notify_PageStorageKey"),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: response.length,
        itemBuilder: (context, j) {

          debugPrint(j.toString());

          return Container(
              padding: EdgeInsets.only(left:10,right:10,top:10),
              child:
              Card(
                child:  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Constants.EXAM_TYPE=response[j]["type"];
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          NewMeet(type: 1, returnedQrCode: "",examId:response[j]["id"],examName: response[j]["exam_name"],)));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,

                      child: Padding(padding:EdgeInsets.only(left: 10,top:10),child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(response[j]["exam_name"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                            Padding(padding:EdgeInsets.only(top:5),child:Text("Notification - "+response[j]["notification"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),)),
                            Padding(padding:EdgeInsets.only(top:5),child:
                            Text("Exam Date : "+response[j]["exam_date"],style: TextStyle(fontSize: 14,color: Colors.green[900],fontWeight: FontWeight.bold)))])),
                    )
                ),
              )
          );}));

  }
  Widget getCompletedMeetingNotifications(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("Notify_PageStorageKey"),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: completedMeeting.length,
        itemBuilder: (context, j) {

          debugPrint(j.toString());

          return Container(
              padding: EdgeInsets.only(left:10,right:10,top:10),
              child:
              Card(
                child:  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          NewMeet(type: 1, returnedQrCode: "",examId:completedMeeting[j]["id"],examName: completedMeeting[j]["exam_name"],)));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,

                      child: Padding(padding:EdgeInsets.only(left: 10,top:10),child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(completedMeeting[j]["exam_name"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                            Padding(padding:EdgeInsets.only(top:5),child:Text("Notification - "+completedMeeting[j]["notification"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),)),
                            Padding(padding:EdgeInsets.only(top:5),child:
                            Text("Exam Date : "+completedMeeting[j]["exam_date"],style: TextStyle(fontSize: 14,color: Colors.green[900],fontWeight: FontWeight.bold)))])),
                    )
                ),
              )
          );}));

  }
}

class NewMeet extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String examName="";
  NewMeet({this.type=1,this.returnedQrCode="",this.examId=0,this.examName="Exam Name"});
  @override
  _NewMeetState createState() => _NewMeetState();
}

class _NewMeetState extends State<NewMeet> {
  int check1 = 0;
  int check2 = 0;
  int check3 = 0;
  bool checkedValue = false;
  Map<String,dynamic> meetingData={};
  TNPSCService service=new TNPSCService();

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<Meta>(
    //     future: callAsyncMethod(),
    //     builder: (context, AsyncSnapshot<Meta> snapshot) {
    //       Meta? m=snapshot.data;
    //       if(m?.statusCode==200){
    //         debugPrint(m?.response.toString());
    //         if(m?.response["status"]=="success") {
    //           meetingData = m?.response["data"] ?? {};
    //         }
    //       }
    //       if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text(widget.examName),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 1)));
                  },
                ),
              ),
              body:  SafeArea(
                  child: Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 20,right: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Visibility(visible:!Constants.isChennaiCenter,child: Card(
                                child:  InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: ()async {
                                    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                    postMeeting["id"] = widget.examId;
                                    postMeeting["type"] = 2;
                                    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/meeting-attendance/details",postMeeting,Constants.AUTH_TOKEN);
                                    List<dynamic> data= m?.response["data"] ?? [];
                                    if(data!=null && data.length>0) {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              ScanListPage(type: 2,
                                                returnedQrCode: "",
                                                examId: widget.examId,notificationName:Constants.EXAM_TYPE=="Objective"?"Question Paper Box QR":"Question Cum Answer Paper Box QR",examName:widget.examName)));
                                    }else{
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              QrPage(value: 2,examId: widget.examId,type: "meeting",notificationName: Constants.EXAM_TYPE=="Objective"?"Question Paper Box QR":"Question Cum Answer Paper Box QR",examName:widget.examName)));
                                    }
                                    // showDialog(
                                    //   barrierColor: Colors.black26,
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return CustomAlertDialog(
                                    //       title: "Question box scanning has been ",
                                    //       description: "successfully verified.",
                                    //     );
                                    //   },
                                    // );
                                    check1 = 1;
                                    print('Scan Question Box');
                                  },
                                  child: Container(
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                          title: Text(Constants.EXAM_TYPE=="Objective"?'Scan Question Paper Box QR':'Scan Question Cum Answer Box QR'),
                                          trailing:Text("")
                                          //(meetingData["attendance_qr"] != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
                                        ),
                                      )
                                  ),
                                )
                            )),
                        Visibility(visible:(!Constants.isChennaiCenter && Constants.EXAM_TYPE=="Objective") ,child:Card(
                                child:  InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: ()async {
                                    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                    postMeeting["id"] = widget.examId;
                                    postMeeting["type"] = 3;
                                    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/meeting-attendance/details",postMeeting,Constants.AUTH_TOKEN);
                                    List<dynamic> data= m?.response["data"] ?? [];
                                    if(data!=null && data.length>0) {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              ScanListPage(type: 3,
                                                returnedQrCode: "",
                                                examId: widget.examId,notificationName: "Answer Packet QR",examName:widget.examName)));
                                    }else{
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              QrPage(value: 3,examId: widget.examId,type: "meeting",notificationName: "Answer Packet QR",examName:widget.examName)));
                                    }
                                    // showDialog(
                                    //   barrierColor: Colors.black26,
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return CustomAlertDialog(
                                    //       title: "Answer sheet box scanning has",
                                    //       description: " been successfully verified.",
                                    //     );
                                    //   },
                                    // );
                                    check2 = 1;
                                    print('Scan Answer Sheet Box');
                                  },
                                  child: Container(
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                          title: Text('Scan Answer Sheet Packet QR'),
                                          trailing:Text("")
                                          // (meetingData["questionbox_qr"] != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
                                        ),
                                      )
                                  ),
                                )
                            )),
                            Card(
                                child:  InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AcknowledgementPage(examId: widget.examId,examName: widget.examName,)));
                                    check3 = 1;
                                    print('Meeting Acknowledgement');
                                  },
                                  child: Container(
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(Icons.checklist,color: Colors.green,),
                                          title: Text('Acknowledgement'),
                                          trailing:Text("")
                                          //(meetingData["acknowledgement"] != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
                                        ),
                                      )
                                  ),
                                )
                            ),
                            Expanded(
                              child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: ButtonTheme(
                                      height: MediaQuery.of(context).size.height * 0.06,
                                      minWidth: MediaQuery.of(context).size.width * 0.9,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        elevation: 1,
                                        color: Colors.green[900] ,
                                        onPressed: ()async{
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(currentIndex: 1,)));
                                        },
                                        child: Text("Submit",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                                      )
                                  )
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      )
                  )
              ),
            );
          // } else {
          //   return Text("");
          // }
        }
    // );

  // }
  // Future<Meta> callAsyncMethod() async{
  //   TNPSCService service=new TNPSCService();
  //   Meta m=await service.processGetURL(Constants.BaseUrlDev+"/meeting-attendance/details",Constants.AUTH_TOKEN);
  //   return m;
  // }
}
class ScanListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String examName="";
  ScanListPage({this.type=1,this.returnedQrCode="",this.examId=0,this.notificationName="",this.examName="Exam Name"});
  @override
  _ScanListPageState createState() => _ScanListPageState();
}

class _ScanListPageState extends State<ScanListPage> {
  List<dynamic> response=[];

  late Future<Meta> _future;
  bool loaded=false;
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    Meta ed;
    _future.then((value){
      ed=value;
      if(ed!=null) {
        Meta m=ed??new Meta();
        if(m?.statusCode==200){
          debugPrint(m?.response.toString());
          if(m?.response["status"]=="success") {
            response = m?.response["data"] ?? [];
          }
        }
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
      future: _future,
      builder: (context, AsyncSnapshot<Meta> snapshot)
      {
        return Scaffold(
            floatingActionButton: snapshot.hasData?FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) =>
                        QrPage(value: widget.type,examId: widget.examId,type: "meeting",notificationName: widget.notificationName,examName:widget.examName)));
              },
              child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 29,),
              backgroundColor: Colors.green[900],
              tooltip: 'Capture QR',
              elevation: 5,
              splashColor: Colors.green[900],
            ):null,
            appBar: AppBar(
              backgroundColor: Colors.green[900],
              title: Text(widget.notificationName),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NewMeet(examId: widget.examId,type:widget.type,examName: widget.examName,)));
                },
              ),
            ),
            body:SafeArea(
                child:
                Center(
                  child: snapshot.hasData?Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(children:[getScanList()])
                    ],
                  ):CircularProgressIndicator(),
                )
            ));
      });
  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["id"] = widget.examId;
    postMeeting["type"] = widget.type;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/meeting-attendance/details",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getScanList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("Scan_PageStorageKey"),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: response.length,
        itemBuilder: (context, j) {

          // debugPrint(svg);

          return Container(
              padding: EdgeInsets.only(left:10,right:10,top:10),
              child:
              Card(
                child:  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,

                      child: ListTile(
                        leading: Text(""),
                        title: Text(response[j]["qr"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                        trailing: IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["meeting_id"] = widget.examId;
                              userData["type"] = widget.type;
                              userData["data_id"] = response[j]["data_id"];
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                              Constants.BaseUrlDev + "/meeting-attendance/delete", userData,
                              Constants.AUTH_TOKEN);
                              if (m.statusCode == 200) {
                                Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                postMeeting["id"] = widget.examId;
                                postMeeting["type"] = widget.type;
                                Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/meeting-attendance/details",postMeeting,Constants.AUTH_TOKEN);
                                if(m1.statusCode==200){
                                  if(m1.response["status"]=="success") {
                                    setState(() {
                                      response = m1.response["data"] ?? [];
                                    });
                                  }
                                }
                              }
                        },),
                      )
                )),
              )
          );}));

  }
}

class AcknowledgementPage extends StatefulWidget {
  int examId=0;
  String examName="";
  AcknowledgementPage({this.examId=0,this.examName=""});
  @override
  _AcknowledgementPageState createState() => _AcknowledgementPageState();
}

class _AcknowledgementPageState extends State<AcknowledgementPage> {

  Map<String,dynamic> response={};
  bool appointmentOrder=false;
  bool receivedPacket=false;
  TextEditingController _controller=new TextEditingController(text:"");
  late Future<Meta> _future;
  @override
  void initState() {
    super.initState();
    _future = callAsyncMethod();
    Meta m=new Meta();
     _future.then((value){
        m=value;
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          response = m.response ;
        }
        setState(() {
          if(response!=null && response["data"]!=null && response["data"]!="") {
            if (response["data"]["appoint_order"] ==
                "yes") {
              appointmentOrder = true;
            }
            if (response["data"]["hall_sketch"] ==
                "yes") {
              receivedPacket = true;
            }
            _controller.text =
                response["data"]["amount"] ?? "";
            try{
              int.parse(_controller.text.toString());
            }catch(e){
              _controller.text="";
            }
          }
        });
     });
    }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
            return getAcknowledgement();
        }
    );
  }
    Widget getAcknowledgement(){
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green[900],
            title: Text('Acknowledgement'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> NewMeet(examId: widget.examId,type:4,examName: widget.examName,)));
              },
            ),
          ),
          body: Container(
            color: Colors.grey[100],
            child: Center(
              child: Column(
                children: [
                  CheckboxListTile(
                    title: Text('Received Appointment Letter'),
                    value: appointmentOrder,
                    activeColor: Colors.green[900],
                    onChanged: (newValue) {
                      setState(() {
                        appointmentOrder = newValue??false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),
                  CheckboxListTile(
                    title: Text('Received Packet containing attendance sheet -cum-hall-sketch'),
                    value: receivedPacket?true:false,
                    activeColor: Colors.green[900],
                    onChanged: (newValue) {
                      setState(() {
                        receivedPacket = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20,left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text('Received Rs.',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 50,
                          width : 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white
                          ),
                          child:TextFormField(
                            controller:_controller ,
                            enabled: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelText: "Amount",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: ButtonTheme(
                            height: MediaQuery.of(context).size.height * 0.06,
                            minWidth: MediaQuery.of(context).size.width * 0.9,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 1,
                              color: Colors.green[900],
                              onPressed:() async{
                                showDialog(
                                  barrierColor: Colors.black26,
                                  context: context,
                                  builder: (mcontext) {
                                    return confirmDialog(context,mcontext);
                                  },
                                );
                              },
                              child: Text("Done",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          )
      );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["id"] = widget.examId;
    postMeeting["type"] = 4;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/meeting-attendance/details",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    return Dialog(
        insetPadding: EdgeInsets.all(15.0),
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(RoundedCheckIcon.ok_circled2,size:80,color: Colors.green,),
                  SizedBox(height: 30),
                  Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(child:Text("Whether the name and Address \n of the examination venue printed \n in the Attendance sheet-cum-Hall sketch \n is correct?",textAlign: TextAlign.center,)),
                  SizedBox(height: 50),
              Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: () async{
                                Navigator.pop(buildContext);
                                Map<String, dynamic> userData = new Map<String, dynamic>();
                                userData["id"] = widget.examId;
                                userData["type"] = 4;
                                if(appointmentOrder) {
                                  userData["appoint_order"] = "yes";
                                }else{
                                  userData["appoint_order"] = "no";
                                }
                                if(receivedPacket) {
                                  userData["hall_sketch"] = "yes";
                                }else{
                                  userData["hall_sketch"] = "no";
                                }
                                userData["amount"] = _controller.text.toString();
                                userData["is_ack_correct"]="yes";
                                debugPrint(userData.toString());
                                TNPSCService service = new TNPSCService();
                                Meta m = await service.processPostURL(
                                    Constants.BaseUrlDev + "/meeting", userData,
                                    Constants.AUTH_TOKEN);
                                debugPrint(m.response.toString());
                                if (m.statusCode == 200) {
                                  debugPrint(m.response.toString());
                                  Map<String, dynamic> response = m.response;
                                  if (response["status"] == "success" || response["status"] == "ok") {
                                    Navigator.pop(mcontext);
                                    Navigator.push(mcontext, MaterialPageRoute(builder: (context) =>
                                        NewMeet(type: 4, returnedQrCode:"",examId: widget.examId,examName: widget.examName,)));
                                    ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                      content: Text("Acknowledgement Saved Successfully"),
                                    ));
                                  } else {
                                    //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                    ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                      content: Text("Values not updated"),
                                    ));
                                  }
                                } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
                                  Navigator.pop(mcontext);
                                  Navigator.push(mcontext, MaterialPageRoute(builder: (context) =>
                                      NewMeet(type: 4, returnedQrCode:"",examId: widget.examId,examName: widget.examName,)));
                                  Map<String, dynamic> response = jsonDecode(m.statusMsg);
                                  //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text(response["error"]),
                                  ));
                                } else {
                                  Map<String, dynamic> response = jsonDecode(m.statusMsg);
                                  //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              }
                            ,
                            child: Text("Yes",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: ()async{
                              Navigator.pop(buildContext);
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["id"] = widget.examId;
                              userData["type"] = 4;
                              if(appointmentOrder) {
                                userData["appoint_order"] = "yes";
                              }else{
                                userData["appoint_order"] = "no";
                              }
                              if(receivedPacket) {
                                userData["hall_sketch"] = "yes";
                              }else{
                                userData["hall_sketch"] = "no";
                              }
                              userData["amount"] = _controller.text.toString();
                              userData["is_ack_correct"]="no";
                              debugPrint(userData.toString());
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/meeting", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "ok" || response["status"] == "success") {
                                  Navigator.pop(mcontext);
                                  Navigator.push(mcontext, MaterialPageRoute(builder: (context) =>
                                      NewMeet(type: 4, returnedQrCode:"",examId: widget.examId,examName: widget.examName,)));
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Acknowledgement Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
                                Navigator.pop(mcontext);
                                Navigator.push(mcontext, MaterialPageRoute(builder: (context) =>
                                    NewMeet(type: 4, returnedQrCode:"",examId: widget.examId,examName: widget.examName,)));
                                Map<String, dynamic> response = jsonDecode(m.statusMsg);
                                //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                                ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                  content: Text(response["error"]),
                                ));
                              } else {
                                Map<String, dynamic> response = jsonDecode(m.statusMsg);
                                //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                                ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                  content: Text("Values not updated"),
                                ));
                              }
                            },
                            child: Text("No",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                  SizedBox(height: 20),
                ],
              ),
            )
        )
    );
  }
}


