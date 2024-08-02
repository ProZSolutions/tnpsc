import 'dart:collection';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnpsc/core/constant.dart';
import 'package:tnpsc/core/datetime_utils.dart';
import 'package:tnpsc/core/meta.dart';
import 'package:tnpsc/core/tnpsc_Core.dart';
import 'package:tnpsc/home/home_page.dart';
import 'package:tnpsc/qr/qrPage.dart';
import 'package:tnpsc/theme/customIcons.dart';

class ExamListPage extends StatefulWidget {
  @override
  _ExamListPageState createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {
  List<dynamic> response= [];
  List<dynamic> completedExam= [];
  late Future<HashMap<String,Meta>> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HashMap<String,Meta>>(
        future: _future,
        builder: (context, AsyncSnapshot<HashMap<String,Meta>> snapshot) {
          HashMap<String, Meta>? hm=snapshot.data;
          if(hm!=null) {
            Meta? m = hm!['exam'];
            Meta? m2 = hm!['completed'];
            if (m?.statusCode == 200) {
              if (m?.response["status"] == "success") {
                response = m?.response["data"] ?? {};
              }
              debugPrint(m?.response.toString());
            }
            if (m2?.statusCode == 200) {
              if (m2?.response["status"] == "success") {
                completedExam = m2?.response["data"] ?? {};
              }
              debugPrint(m2?.response.toString());
            }
          }

              return SafeArea(
                  child:
                  Center(
                    child: snapshot.hasData?Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _tabSection(context)
                      ],
                    ):CircularProgressIndicator(),
                  )
              );

        }
    );

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
                  Tab(child:Text("Assigned",style: TextStyle(backgroundColor: Colors.green[900],color:Colors.white),
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
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,children:[getExamNotifications()]),
                  ),
                  Container(
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,children:[getCompletedExamNotifications()]),
                  )
                ]),
          ),
        ],
      ),
    );
  }
  Future<HashMap<String,Meta> > callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> examData= HashMap<String,Meta>();
    Meta m=await service.processGetURL(Constants.BaseUrlDev+"/examlist",Constants.AUTH_TOKEN);
    Meta m2=await service.processGetURL(Constants.BaseUrlDev+"/completed-exam",Constants.AUTH_TOKEN);
    examData['exam']=m;
    examData['completed']=m2;
    return examData;
  }
  Widget getExamNotifications(){
    Constants.EXAM_TYPE="";
    return Expanded(child: ListView.builder(
        key: PageStorageKey("ExamNotify_PageStorageKey"),
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
                      Navigator.pop(context);
                      Constants.EXAM_TYPE=response[j]["type"];
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          DaysListPage(examId:response[j]["examid"],notificationName:response[j]["notification"] ,)));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.11,

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
  Widget getCompletedExamNotifications(){
    Constants.EXAM_TYPE="";
    return Expanded(child: ListView.builder(
        key: PageStorageKey("ExamNotify_PageStorageKey"),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: completedExam.length,
        itemBuilder: (context, j) {

          // debugPrint(svg);

          return Container(
              padding: EdgeInsets.only(left:10,right:10,top:10),
              child:
              Card(
                child:  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.pop(context);
                      Constants.EXAM_TYPE=completedExam[j]["type"];
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          DaysListPage(examId:completedExam[j]["examid"],notificationName:completedExam[j]["notification"] ,)));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,

                      child: Padding(padding:EdgeInsets.only(left: 10,top:10),child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(completedExam[j]["exam_name"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                            Padding(padding:EdgeInsets.only(top:5),child:Text("Notification - "+completedExam[j]["notification"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),)),
                            Padding(padding:EdgeInsets.only(top:5),child:
                            Text("Exam Date : "+completedExam[j]["exam_date"],style: TextStyle(fontSize: 14,color: Colors.green[900],fontWeight: FontWeight.bold)))])),
                    )
                ),
              )
          );}));

  }
}

class ExamIsVdListPage extends StatefulWidget {
  @override
  _ExamIsVdListPageState createState() => _ExamIsVdListPageState();
}

class _ExamIsVdListPageState extends State<ExamIsVdListPage> {
  List<dynamic> response= [];
  List<dynamic> completedExam= [];
  late Future<HashMap<String,Meta>> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HashMap<String,Meta>>(
        future: _future,
        builder: (context, AsyncSnapshot<HashMap<String,Meta>> snapshot) {
          HashMap<String, Meta>? hm=snapshot.data;
          if(hm!=null) {
            Meta? m = hm!['exam'];
            if (m?.statusCode == 200) {
              if (m?.response["status"] == "success") {
                response = m?.response["data"] ?? {};
              }
              debugPrint(m?.response.toString());
            }

          }
            return SafeArea(
                child:
                Center(
                  child: snapshot.hasData?Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _tabSection(context)
                    ],
                  ):CircularProgressIndicator(),
                )
            );

        }
    );

  }
  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 1,
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
                  Tab(child:Text("Assigned",style: TextStyle(backgroundColor: Colors.green[900],color:Colors.white),
                  ),),
                  ]),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height*0.76,
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,children:[getExamNotifications()]),
                  ),

                ]),
          ),
        ],
      ),
    );
  }
  Future<HashMap<String,Meta> > callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> examData= HashMap<String,Meta>();
    Meta m=await service.processGetURL(Constants.BaseUrlDev+"/mm-upcome-exam-details",Constants.AUTH_TOKEN);
    examData['exam']=m;
    return examData;
  }
  Widget getExamNotifications(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("ExamNotify_PageStorageKey"),
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
                    onTap: ()async {
                      Map<String, dynamic> userData = new Map<String, dynamic>();
                      userData["examid"] = int.parse(response[j]["exam_id"]);
                      TNPSCService service = new TNPSCService();
                      Meta m = await service.processPostURL(
                          Constants.BaseUrlDev + "/select-is-vd-notification", userData,
                          Constants.AUTH_TOKEN);
                      debugPrint(m.response.toString());
                      if (m.statusCode == 200) {
                        debugPrint(m.response.toString());
                        Map<String, dynamic> resp = m.response;
                        if (resp["status"] == "success" || resp["status"] == "ok") {
                          /*Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ISExamListPage(examId:int.parse(response[j]["exam_id"]),notificationName:response[j]["notification"] ,)));*/
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ISDaysListPage(examId:int.parse(response[j]["exam_id"]),notificationName:response[j]["notification"],)));

                        } else {
                          //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Values not updated"),
                          ));
                        }
                      } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
                        Map<String, dynamic> resp = jsonDecode(m.statusMsg);
                        //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(resp["error"]),
                        ));
                      } else {
                        Map<String, dynamic> resp = jsonDecode(m.statusMsg);
                        //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Values not updated"),
                        ));
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.14,

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
}

class DaysListPage extends StatefulWidget {
  int examId=0;
  String notificationName="";
  String examType="";
  DaysListPage({this.examId=0,this.notificationName="",this.examType=""});
  @override
  _DaysListState createState() => _DaysListState();
}

class _DaysListState extends State<DaysListPage> {
  List<dynamic> examData=[];
  TextEditingController _comments=new TextEditingController();
  TNPSCService service=new TNPSCService();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future:_future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              examData = m?.response["data"] ?? [];
            }
          }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text(widget.notificationName),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 2)));
                  },
                ),
              ),
              body:  SafeArea(
                  child: Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 20,right: 20),
                        child: snapshot.hasData?Column(
                          children: [
                            Container(
                                padding: EdgeInsets.only(left:10,right:10,top:10),
                                child:
                                Card(
                                    child:  InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                            ExamPreliminaryPage(
                                              examId: widget.examId,examName:widget.notificationName,notificationName:widget.notificationName,dayId: 0,)));
                                      },
                                      child: Container(
                                          height: MediaQuery.of(context).size.height * 0.1,
                                          child: Center(
                                            child: ListTile(
                                              leading: Icon(Icons.checklist,color: Colors.green,),
                                              title: Text('Preliminary Checklist'),
                                            ),
                                          )
                                      ),
                                    )
                                ),
                            ),
                            getExamDaysList(),
                            Container(
                              padding: EdgeInsets.only(left:10,right:10,top:10),
                              child:

                              Card(
                                  child:  InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          ExamUTCPage(
                                            examId: widget.examId,examName:widget.notificationName,notificationName:widget.notificationName,dayId: 0,)));
                                    },
                                    child: Container(
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        child: Center(
                                          child: ListTile(
                                            leading: Icon(Icons.payments,color: Colors.green,),
                                            title: Text('Utilization Certificate'),
                                            trailing:Icon(Icons.check,color: Colors.white,),
                                          ),
                                        )
                                    ),
                                  )
                              ),

                            ),
                            SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.only(left:10,right:10,top:10),
                        child:

                        Card(
                                child:  InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: ()async {
                                    Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
                                    postExamDetail["examid"] = widget.examId;
                                    // postExamDetail["dayid"] = widget.dayId;
                                    TNPSCService service=new TNPSCService();
                                    HashMap<String,Meta> examData= HashMap<String,Meta>();
                                    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/utc-report",postExamDetail,Constants.AUTH_TOKEN);
                                    if (m.statusCode == 200) {
                                      Map<String,dynamic> reportData={};
                                      reportData = m.response;
                                      if(reportData["status"]=="success") {
                                        try {
                                          await service.checkPermission();
                                          // await service.download2(reportData["report_url"].toString(),"candidate.pdf");
                                          service.downloadFile(
                                              reportData["report_url"].toString(),"utc-report.pdf");
                                        }catch(e){
                                          debugPrint(e.toString());
                                        }
                                      }
                                    }
                                  },
                                  child: Container(
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(Icons.assignment_turned_in,color: Colors.green,),
                                          title: Text('Utilization Certificate Download'),
                                          trailing:Icon(Icons.check,color: Colors.white,),
                                        ),
                                      )
                                  ),
                                )
                            )),
                            Visibility(visible:false,child:Container(
                              padding: EdgeInsets.only(left:10,right:10,top:10),
                              child:
                              Card(
                                  child:  InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    onTap: ()async {
                                      _comments.text="";
                                      Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                      postMeeting["exam_id"] = widget.examId;
                                      Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/commencement/details",postMeeting,Constants.AUTH_TOKEN);
                                      if(m1.statusCode==200){
                                        if(m1.response["status"]=="success") {
                                          if(m1.response["data"]!=null){
                                            setState(() {
                                              _comments.text = m1.response["data"] ?? "";
                                            });
                                          }
                                        }
                                      }
                                      showDialog(
                                        barrierColor: Colors.black26,
                                        context: context,
                                        builder: (mcontext) {
                                          return commencementDialog(context,mcontext);
                                        },
                                      );
                                    },
                                    child: Container(
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        child: Center(
                                          child: ListTile(
                                            leading: Icon(Icons.checklist,color: Colors.green,),
                                            title: Text('Commencement'),
                                          ),
                                        )
                                    ),
                                  )
                              ),
                            ))
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )
              ),
            );

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["examid"] = widget.examId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/days-list-of-exam",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getExamDaysList(){
    return
      //Expanded(child:
    ListView.builder(
        key: PageStorageKey("ExamNotify_PageStorageKey"),
        shrinkWrap: true,
        physics:ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: examData.length,
        itemBuilder: (context, j) {

          // debugPrint(svg);

          return Container(
              padding: EdgeInsets.only(left:10,right:10,top:10),
              height: MediaQuery.of(context).size.height * 0.12,
              child:
              Card(
                child:  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          ExamDetailPage(examId:examData[j]["examid"],dayId:examData[j]["dayid"] ,notificationName: examData[j]["exam_name"].toString(),examName:examData[j]["exam_name"].toString() ,)));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      child:
                      Center(
                      child: ListTile(
                      leading: Icon(Icons.calendar_today,color: Colors.green,),
          title: Text("Date : " +examData[j]["examdate"]),
          trailing:Icon(Icons.check,color: Colors.white,),
          )),
                      // Padding(padding:EdgeInsets.only(left: 10,top:10),child:Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [Text("Date :" +examData[j]["examdate"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                      //       Padding(padding:EdgeInsets.only(top:5),child:
                      //       Text("Exam Name : "+examData[j]["exam_name"],style: TextStyle(fontSize: 14,color: Colors.green[900],fontWeight: FontWeight.bold)))
                      //     ])),
                    )
                ),
              )
          );});
    //);

  }
  Widget commencementDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_comments ,
                        enabled: true,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Comments",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["commencement"]=_comments.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-commencement", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  postMeeting["examid"] = widget.examId;
                                  Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/commencement/details",postMeeting,Constants.AUTH_TOKEN);
                                  if(m1.statusCode==200){
                                    if(m1.response["status"]=="success") {
                                      if(m1.response["data"]!=null){
                                        setState(() {
                                          response = m1.response["data"] ?? [];
                                        });
                                      }
                                    }
                                  }
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Commencement Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class ExamDetailPage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String notificationName="";
  String examName="";
  ExamDetailPage({this.examId=0,this.dayId=0,this.notificationName="",this.examName=""});
  @override
  _ExamDetailPageState createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  Map<String,dynamic> meetingData={};
  int forenoonSessionId=0;
  int afternoonSessionId=0;
  late Future<HashMap<String,Meta>> _future;
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    HashMap<String,Meta> ed=new HashMap<String,Meta>();
    _future.then((value){
      ed=value;
      if(ed["session"]!=null) {
        Meta m=ed["session"]??new Meta();
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          meetingData = m.response;
          setState(() {
            if(meetingData!=null && meetingData["data"]!=null) {
              if(meetingData["data"].where((session) => session["session"] == "FN").toList().length>0) {
                forenoonSessionId =
                meetingData["data"].where((session) => session["session"] == "FN").toList()[0]['sessionid'];
              }
              if(meetingData["data"].where((session) => session["session"] == "AN").toList().length>0) {
                afternoonSessionId =
                meetingData["data"].where((session) => session["session"] == "AN").toList()[0]['sessionid'];
              }
            }
          });

        }
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text(widget.notificationName),
    leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: (){
      Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DaysListPage(examId: widget.examId,notificationName: widget.notificationName,)));
    },
    ),
    ),
    body: SafeArea(
        child:SingleChildScrollView(
          child: Column(
            // children: [
            //   Container(
            //     height: MediaQuery.of(context).size.height*1.20,
            //     margin: EdgeInsets.all(15),
            //     child: ListView(
            children: <Widget>[

                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          ScanExam(type: 2,
                            returnedQrCode: "",
                            examId: widget.examId,examName:widget.examName,dayId: widget.dayId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                title: Text('Scan Exam Material QR'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
              // Card(
              //     child:  InkWell(
              //       splashColor: Colors.blue.withAlpha(30),
              //       onTap: () {
              //         Navigator.push(context, MaterialPageRoute(builder: (context) =>
              //             CandidatePage()));
              //       },
              //       child: Container(
              //           height: MediaQuery.of(context).size.height * 0.1,
              //           child: Center(
              //             child: ListTile(
              //               leading: Icon(Icons.assignment_turned_in,color: Colors.green,),
              //               title: Text('Candidate Attendance'),
              //             ),
              //           )
              //       ),
              //     )
              // ),
              // SizedBox(height: 5),
              // Card(
              //     child:  InkWell(
              //       splashColor: Colors.blue.withAlpha(30),
              //       onTap: () {
              //
              //       },
              //       child: Container(
              //           height: MediaQuery.of(context).size.height * 0.1,
              //           child: Center(
              //             child: ListTile(
              //               leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
              //               title: Text('Staff List'),
              //               trailing:Icon(Icons.check,color: Colors.white,),
              //             ),
              //           )
              //       ),
              //     )
              // ),
              // SizedBox(height: 5),
              // Card(
              //     child:  InkWell(
              //       splashColor: Colors.blue.withAlpha(30),
              //       onTap: () {
              //
              //       },
              //       child: Container(
              //           height: MediaQuery.of(context).size.height * 0.1,
              //           child: Center(
              //             child: ListTile(
              //               leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
              //               title: Text('Assistant List'),
              //               trailing:  Icon(Icons.check,color: Colors.white,),
              //             ),
              //           )
              //       ),
              //     )
              // ),
              // SizedBox(height: 5),
              // Card(
              //     child:  InkWell(
              //       splashColor: Colors.blue.withAlpha(30),
              //       onTap: () {
              //       },
              //       child: Container(
              //           height: MediaQuery.of(context).size.height * 0.1,
              //           child: Center(
              //             child: ListTile(
              //               leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
              //               title: Text('Add Scribe'),
              //               trailing: Icon(Icons.check,color: Colors.white,),
              //             ),
              //           )
              //       ),
              //     )
              // ),
              SizedBox(height: 5),
              Visibility(visible:
              forenoonSessionId>0?true:false
                  ,child:Card(
                  child:  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:forenoonSessionId ,sessionName: "Forenoon (FN)",)));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.wb_twighlight,color: Colors.green,),
                            title: Text('Forenoon (FN)'),
                            trailing:Icon(Icons.check,color: Colors.white,),
                          ),
                        )
                    ),
                  )
              )),
              SizedBox(height: 5),
              Visibility(visible:
              afternoonSessionId>0?true:false
                  ,child:Card(
                  child:  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:afternoonSessionId ,sessionName: "Afternoon (AN)",)));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.wb_sunny,color: Colors.green,),
                            title: Text('Afternoon (AN)'),
                            trailing:Icon(Icons.check,color: Colors.white,),
                          ),
                        )
                    ),
                  )
              )),


              // SizedBox(height: 5),
              // Card(
              //     child:  InkWell(
              //       splashColor: Colors.blue.withAlpha(30),
              //       onTap: () {
              //         Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(value : 6,type:"closing")));
              //         // showDialog(
              //         //   barrierColor: Colors.black26,
              //         //   context: context,
              //         //   builder: (context) {
              //         //     return CustomAlertDialog(
              //         //       title: "Answer sheet box scanning has",
              //         //       description: " been successfully verified.",
              //         //     );
              //         //   },
              //         // );
              //         print('Check Answer Sheet Box');
              //       },
              //       child: Container(
              //           height: MediaQuery.of(context).size.height * 0.1,
              //           child: Center(
              //             child: ListTile(
              //               leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
              //               title: Text('Closing Bundle B'),
              //               trailing: (bundleB != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
              //             ),
              //           )
              //       ),
              //     )
              // ),
              // SizedBox(height: 5),
              // Card(
              //     child:  InkWell(
              //       splashColor: Colors.blue.withAlpha(30),
              //       onTap: () {
              //         Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(value : 7,type:"closing")));
              //         // showDialog(
              //         //   barrierColor: Colors.black26,
              //         //   context: context,
              //         //   builder: (context) {
              //         //     return CustomAlertDialog(
              //         //       title: "Answer sheet box scanning has",
              //         //       description: " been successfully verified.",
              //         //     );
              //         //   },
              //         // );
              //         print('Check Answer Sheet Box');
              //       },
              //       child: Container(
              //           height: MediaQuery.of(context).size.height * 0.1,
              //           child: Center(
              //             child: ListTile(
              //               leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
              //               title: Text('Closing Bundle 1'),
              //               trailing: (bundleI != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
              //             ),
              //           )
              //       ),
              //     )
              // ),

              /*
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Malpractice Updates');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: FlutterLogo(),
                                title: Text('Malpractice Updates'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Q&A Sheet Damage/Shortage');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: FlutterLogo(),
                                title: Text('Q&A Sheet Damage/Shortage'),
                              ),
                            )
                        ),
                      )
                  ),*/
            ],
          ),
        )
      //],
      //),
      //)
    ));
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> examData= HashMap<String,Meta>();
    Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
    postExamDetail["examid"] = widget.examId;
    postExamDetail["dayid"] = widget.dayId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/session-list-of-exam",postExamDetail,Constants.AUTH_TOKEN);
    examData["session"]=m;
    return examData;
  }
}
class ScanExam extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  int dayId=0;
  String examName="";
  ScanExam({this.type=1,this.returnedQrCode="",this.examId=0,this.examName="Exam Name",this.dayId=0});
  @override
  _ScanExamState createState() => _ScanExamState();
}

class _ScanExamState extends State<ScanExam> {
  int check1 = 0;
  int check2 = 0;
  int check3 = 0;
  bool checkedValue = false;
  Map<String,dynamic> totalData={};
  TNPSCService service=new TNPSCService();
  String totalQp="0";
  String totalAns="0";
  TextEditingController _totalqp=new TextEditingController(text:"");
  TextEditingController _totalans=new TextEditingController(text:"");

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
        totalData = m.response ;
      }
      setState(() {
        if(totalData!=null && totalData["data"]!=null && totalData["data"]["tot_qp_box"]!=null) {
          _totalqp.text =
              totalData["data"]["tot_qp_box"].toString();
          totalQp=totalData["data"]["tot_qp_box"].toString();
        }else{
          _totalqp.text ="0";
          totalQp="0";
        }
        if(totalData!=null && totalData["data"]!=null && totalData["data"]["tot_ans_box"]!=null) {
          _totalans.text =
              totalData["data"]["tot_ans_box"].toString();
          totalAns=totalData["data"]["tot_ans_box"].toString();
        }else{
          _totalans.text ="0";
          totalAns="0";
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text("Scan Exam Material QR"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ExamDetailPage(examName: widget.examName,examId: widget.examId,dayId: widget.dayId,notificationName: widget.examName,)));
          },
        ),
      ),
      body:  SafeArea(
          child: Center(
              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Card(
                        child:  InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: ()async {
                            showDialog(
                              barrierColor: Colors.black26,
                              context: context,
                              builder: (mcontext) {
                              return confirmDialogQp(context,mcontext);
                              },
                            );
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Center(
                                child: ListTile(
                                    leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                    title: Text('Total Question Paper Box: '+totalQp+' \nTotal Answer Sheet Box   : '+totalAns),
                                    trailing:Text("")
                                  // (meetingData["questionbox_qr"] != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
                                ),
                              )
                          ),
                        )
                    ),
                    SizedBox(height: 10),
                    Card(
                        child:  InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: ()async {
                            Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                            postMeeting["exam_id"] = widget.examId;
                            postMeeting["dayid"] = widget.dayId;
                            postMeeting["type"] = 2;
                            Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/verify-qa-list",postMeeting,Constants.AUTH_TOKEN);
                            List<dynamic> data= m?.response["data"] ?? [];
                            if(data!=null && data.length>0) {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      ExamScanListPage(type: 2,
                                          returnedQrCode: "",
                                          examId: widget.examId,notificationName: (Constants.EXAM_TYPE=="Descriptive")?"Scan Question Cum Answer QR":"Scan Question Paper Box QR",examName:widget.examName,dayId: widget.dayId,)));
                            }else{
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      QrPage(value: 2,examId: widget.examId,type: "verify-qa-qr",notificationName: (Constants.EXAM_TYPE=="Descriptive")?"Scan Question Cum Answer QR":"Scan Question Paper Box QR",examName:widget.examName,dayId: widget.dayId,)));
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
                                    title: Text((Constants.EXAM_TYPE=="Descriptive")?"Scan Question Cum Answer QR":"Scan Question Paper Box QR"),
                                    trailing:Text("")
                                  //(meetingData["attendance_qr"] != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
                                ),
                              )
                          ),
                        )
                    ),
                    SizedBox(height: 10),
                    Visibility(visible:(Constants.EXAM_TYPE=="Objective"),child:Card(
                        child:  InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: ()async {
                            Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                            postMeeting["exam_id"] = widget.examId;
                            postMeeting["dayid"] = widget.dayId;
                            postMeeting["type"] = 3;
                            Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/verify-qa-list",postMeeting,Constants.AUTH_TOKEN);
                            List<dynamic> data= m?.response["data"] ?? [];
                            if(data!=null && data.length>0) {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      ExamScanListPage(type: 3,
                                          returnedQrCode: "",
                                          examId: widget.examId,notificationName: "Scan Answer Sheet Packet QR",examName:widget.examName,dayId: widget.dayId)));
                            }else{
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      QrPage(value: 3,examId: widget.examId,type: "verify-qa-qr",notificationName: "Scan Answer Sheet Packet QR",examName:widget.examName,dayId: widget.dayId,)));
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
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (mcontext) {
                                      return confirmDialog(context,mcontext);
                                    },
                                  );                                },
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
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/show-total-bundles",postMeeting,Constants.AUTH_TOKEN);
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
                  Center(child:Text("Is the Question paper bundles received were intact without any damage in respect of the seals affixed on them?",textAlign: TextAlign.center,)),
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
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                                userData["without_damage"] = "yes";
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/qp-bundle/without-damage", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(mcontext);
                                  Navigator.push(mcontext, MaterialPageRoute(builder: (context) =>
                                      ExamDetailPage(examName: widget.examName,examId: widget.examId,dayId: widget.dayId,notificationName: widget.examName,)));
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Scan Material Saved Successfully"),
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
                                    ExamDetailPage(examName: widget.examName,examId: widget.examId,dayId: widget.dayId,notificationName: widget.examName,)));
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
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["without_damage"] = "no";
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/qp-bundle/without-damage", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(mcontext);
                                  Navigator.push(mcontext, MaterialPageRoute(builder: (context) =>
                                      ExamDetailPage(examName: widget.examName,examId: widget.examId,dayId: widget.dayId,notificationName: widget.examName,)));
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Scan Material Saved Successfully"),
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
                                    ExamDetailPage(examName: widget.examName,examId: widget.examId,dayId: widget.dayId,notificationName: widget.examName,)));
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
  Widget confirmDialogQp(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_totalqp ,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Total QP Box",
                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,top:20),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_totalans ,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Total Answer Box",
                        )
                    ),
                  ),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      padding: EdgeInsets.only(top:20),
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      padding: EdgeInsets.only(top:20),
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["tot_qp_box"] = _totalqp.text.toString();
                              userData["tot_ans_box"] = _totalans.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-total-bundles", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> sresponse = m.response;
                                if (sresponse["status"] == "success" || sresponse["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  postMeeting["exam_id"] = widget.examId;
                                  postMeeting["dayid"] = widget.dayId;
                                  Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/show-total-bundles",postMeeting,Constants.AUTH_TOKEN);
                                  if(m1.statusCode==200){
                                    if(m1.response["status"]=="success") {
                                      totalData = m1.response ;
                                      setState(() {
                                          if(totalData!=null && totalData["data"]!=null && totalData["data"]["tot_qp_box"]!=null) {
                                            _totalqp.text =
                                            totalData["data"]["tot_qp_box"].toString();
                                            totalQp=totalData["data"]["tot_qp_box"].toString();
                                          }else{
                                            _totalqp.text ="0";
                                            totalQp="0";
                                          }
                                          if(totalData!=null && totalData["data"]!=null && totalData["data"]["tot_ans_box"]!=null) {
                                            _totalans.text =
                                            totalData["data"]["tot_ans_box"].toString();
                                            totalAns=totalData["data"]["tot_ans_box"].toString();
                                          }else{
                                            _totalans.text ="0";
                                            totalAns="0";
                                          }
                                      });
                                    }
                                  }
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Total QP and Answer Box updated successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}
class ExamScanListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String examName="";
  int dayId=0;
  ExamScanListPage({this.type=1,this.returnedQrCode="",this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0});
  @override
  _ExamScanListPageState createState() => _ExamScanListPageState();
}

class _ExamScanListPageState extends State<ExamScanListPage> {
  List<dynamic> response=[];
  String totalCount="";
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
              totalCount=m?.response["total_count"].toString() ?? "";
            }
          }
          return Scaffold(
              floatingActionButton: snapshot.hasData?FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) =>
                          QrPage(value: widget.type,examId: widget.examId,type: "verify-qa-qr",notificationName: widget.notificationName,examName:widget.examName,dayId: widget.dayId,)));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ScanExam(examId: widget.examId,type:widget.type,examName: widget.examName,dayId: widget.dayId,)));
                  },
                ),
              ),
              body:SafeArea(
                  child:
                  Center(
                    child: snapshot.hasData?Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.confirmation_number_outlined,color: Colors.green,),
                                title: Text('Total Count'),
                                trailing:Text(totalCount),
                              ),
                            )),
                        Row(children:[getScanList()])
                      ],
                    ):CircularProgressIndicator(),
                  )
              ));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["type"] = widget.type;
    postMeeting["dayid"] = widget.dayId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/verify-qa-list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getScanList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("ExamScan_PageStorageKey"),
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
                            userData["exam_id"] = widget.examId;
                            userData["type"] = widget.type;
                            userData["dayid"]=widget.dayId;
                            userData["data_id"] = response[j]["data_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/verify-qa-qr/delete", userData,
                                Constants.AUTH_TOKEN);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["exam_id"] = widget.examId;
                              // postMeeting["type"] = widget.type;
                              // postMeeting["dayid"] = widget.dayId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/verify-qa-list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
}
class CandidatePage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String sessionName="";
  String notificationName="";
  String examName="";
  int sessionId=0;
  CandidatePage({this.examId=0,this.dayId=0,this.sessionName="",this.examName="",this.sessionId=0,this.notificationName=""});

  TextEditingController _ccontroller=new TextEditingController(text:"");
  TextEditingController _pcontroller=new TextEditingController(text:"");
  TextEditingController _acontroller=new TextEditingController(text:"");
  @override
  _CandidatePageState createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  Map<String,dynamic> response={};
  bool appointmentOrder=false;
  bool receivedPacket=false;
  int total=0;
  int present=0;
  int absent=0;
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
        if(response!=null && response["candidates"]!=null) {
          widget._ccontroller.text =
              response["candidates"].toString();
          total=response["candidates"];
        }
        if(response!=null && response["present"]!=null) {
          widget._pcontroller.text =
              response["present"].toString();
          present=response["present"];
        }
        if(response!=null && response["absent"]!=null) {
          widget._acontroller.text =
              response["absent"].toString();
          absent=response["absent"];
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          return getCandidatePage();
        }
    );
  }
  Widget getCandidatePage(){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text('Candidate Attendance'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));
            },
          ),
        ),
        body: Container(
          color: Colors.grey[100],
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20,left:20,top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Container(
                        width:MediaQuery.of(context).size.width*0.45,
                        child:Text('Candidates Allotted: ',textAlign: TextAlign.right, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width:MediaQuery.of(context).size.width*0.30,

                        child:Text(total.toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                        // TextFormField(
                        //   controller:widget._ccontroller ,
                        //   enabled: false,
                        //   keyboardType: TextInputType.number,
                        //   textAlign: TextAlign.center,
                        //   decoration: InputDecoration(
                        //     alignLabelWithHint: true,
                        //     labelText: "Total",
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20,left: 20,top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Container(
                          width:MediaQuery.of(context).size.width*0.45,
                          child:Text('Present:',textAlign:TextAlign.right,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),)),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width:MediaQuery.of(context).size.width*0.30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.lightGreen),
                            color: Colors.white
                        ),
                        child:TextFormField(
                          controller:widget._pcontroller ,
                          enabled: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (text){
                            int absent=0;
                            if(text!=""){
                              //present=int.parse(text);
                            }
                            setState(() {
                              //_acontroller.text=(total-present).toString();
                            });
                          },
                          // decoration: InputDecoration(
                          //   alignLabelWithHint: false,
                          //   labelText: "Present",
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(right: 20,left: 20,top:20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children:[
                //       Container(
                //         width:MediaQuery.of(context).size.width*0.35,
                //         child:Text('Absent',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                //       ),
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         height: 50,
                //         width:MediaQuery.of(context).size.width*0.50,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(8),
                //             border: Border.all(color: Colors.grey),
                //             color: Colors.white
                //         ),
                //         child:TextFormField(
                //           controller:widget._acontroller ,
                //           enabled: false,
                //           keyboardType: TextInputType.number,
                //           textAlign: TextAlign.center,
                //           decoration: InputDecoration(
                //             alignLabelWithHint: true,
                //             labelText: "Absent",
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"]=widget.examId;
                              userData["dayid"]=widget.dayId;
                              userData["sessionid"]=widget.sessionId;
                              userData["present"] = widget._pcontroller.text.toString();
                              debugPrint(userData.toString());
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/update-candidate-attendance", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              debugPrint(m.statusMsg.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "ok" || response["status"] == "success") {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));
                                Map<String, dynamic> response = jsonDecode(m.statusMsg);
                                //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(response["error"]),
                                ));
                              } else if (m.statusCode == 422) {
                                // Navigator.pop(context);
                                // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                //     ExamPage()));
                                Map<String, dynamic> response = jsonDecode(m.statusMsg);
                                //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(response["message"]),
                                ));
                              } else {
                                Map<String, dynamic> response = jsonDecode(m.statusMsg);
                                //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Values not updated"),
                                ));
                              }
                            },
                            child: Text("Submit",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
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
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/candidate-attendance-details",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
}

class SessionDetailPage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String sessionName="";
  String notificationName="";
  String examName="";
  int sessionId=0;
  String reasonType="Mobile";
  String answerType="No";
  SessionDetailPage({this.examId=0,this.dayId=0,this.sessionName="",this.examName="",this.sessionId=0,this.notificationName=""});
  @override
  _SessionDetailPageState createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends State<SessionDetailPage> {
  Map<String,dynamic> questionData={};
  Map<String,dynamic> totalStaff={};
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _handleTime=new TextEditingController();
  TextEditingController _distTime=new TextEditingController();
  String totalInvigilators="";
  List<String> handleto=['Mobile','Staff','Officer'];
  List<String> handleToTypes=['Mobile','Staff','Officer'];
  TextEditingController _comments=new TextEditingController();
  List<String> answer=['No','Yes'];
  List<String> answerTypes=['No','Yes'];

  late Future<HashMap<String,Meta>> _future;
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    HashMap<String,Meta> ed;
    _future.then((value){
      ed=value;
      if(ed!=null) {
        Meta m=ed["questionData"]??new Meta();
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          questionData = m.response;
        }
        Meta m1=ed["totalstaff"]??new Meta();
        if (m1.statusCode == 200) {
          debugPrint(m1.response.toString());
          totalStaff = m1.response;
          if(totalStaff["data"]!=null) {
            if(totalStaff["data"]["total_invigilators"]!=null) {
              _candidate.text = totalStaff["data"]["total_invigilators"].toString();
              setState(() {
                totalInvigilators=totalStaff["data"]["total_invigilators"].toString();
              });
            }else{
              totalInvigilators="0";
              _candidate.text="0";
            }
          }
        }
      }

    });
    super.initState();
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> dataSet=new HashMap<String,Meta>();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/material-received/details",postMeeting,Constants.AUTH_TOKEN);
    dataSet["questionData"]=m;
    Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/show-total-invigilators",postMeeting,Constants.AUTH_TOKEN);
    dataSet["totalstaff"]=m1;
    return dataSet;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text(widget.sessionName),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ExamDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,)));
            },
          ),
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: Column(
                // children: [
                //   Container(
                //     height: MediaQuery.of(context).size.height*1.20,
                //     margin: EdgeInsets.all(15),
                //     child: ListView(
                children: <Widget>[
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ExamSessionPreliminaryPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.checklist,color: Colors.green,),
                                title: Text('Session Check List'),
                                trailing: Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (mcontext) {
                              return confirmDialog(context,mcontext);
                            },
                          );
                          },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.people,color: Colors.green,),
                                title: Text('Total Invigilators : '+totalInvigilators),
                                trailing: Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              StaffListPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.people,color: Colors.green,),
                                title: Text('Add Invigilator'),
                                trailing: Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ScribeListPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.people,color: Colors.green,),
                                title: Text('Add Scribe'),
                                trailing: Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              AssistantListPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.people,color: Colors.green,),
                                title: Text('Add CI Assistants'),
                                trailing: Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              StaffAttendanceListPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));

                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Invigilator Attendance'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: ()async {
                          Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
                          postExamDetail["exam_id"] = widget.examId;
                          postExamDetail["dayid"] = widget.dayId;
                          postExamDetail["sessionid"] = widget.sessionId;
                          TNPSCService service=new TNPSCService();
                          HashMap<String,Meta> examData= HashMap<String,Meta>();
                          Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/hall-staff-allocate",postExamDetail,Constants.AUTH_TOKEN);
                          if (m.statusCode == 200) {
                            Map<String,dynamic> reportData={};
                            reportData = m.response;
                            if(reportData["status"]=="ok") {
                              try {
                                if(reportData["data"]=="Success"){
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      HallAllocationListPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Hall allocation not done"),
                                  ));
                                }
                              }catch(e){
                                debugPrint(e.toString());
                              }
                            }else{
                              if(reportData["error"]!=null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(reportData["error"]),
                                    ));
                              }
                            }
                          }

                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Invigilator Allotment'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async{
                          Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          postMeeting["exam_id"] = widget.examId;
                          postMeeting["dayid"] = widget.dayId;
                          postMeeting["sessionid"]=widget.sessionId;
                          TNPSCService service=new TNPSCService();
                          Map<String,dynamic>? response;
                          Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/material-received/details",postMeeting,Constants.AUTH_TOKEN);
                          if(m?.statusCode==200){
                            debugPrint(m?.response.toString());
                            if(m?.response["status"]=="success") {
                              questionData =  m?.response ?? {};
                            }
                          }
                          if(questionData!=null && questionData["data"]!=null && questionData["data"].length>0) {
                              Map<String,dynamic> data=questionData["data"][0];
                              _handleTime.text=data["opening_time"];
                          }
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (mcontext) {
                              return qsnBoxDialog(context,mcontext);
                            },
                          );
                          // if(questionData!=null && questionData["data"]!=null && questionData["data"].length>0) {
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     content: Text((Constants.EXAM_TYPE=="Descriptive")?"Booklet Already Scanned":"QP Box Already scanned "),
                          //   ));
                          // }else{
                          //   Navigator.pop(context);
                          //   Navigator.push(context, MaterialPageRoute(
                          //       builder: (context) =>
                          //           QrPage(value: 1,
                          //               examId: widget.examId,
                          //               type: "add-material-received",
                          //               notificationName: widget
                          //                   .notificationName,
                          //               examName: widget.examName,
                          //               dayId: widget.dayId,
                          //               sessionName: widget.sessionName,
                          //               sessionId: widget.sessionId,
                          //               bundleName: "")));
                          // }
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                title: Text((Constants.EXAM_TYPE=="Descriptive")?'Booklet Open Time':'QP Box Open Time'),
                                trailing:  Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              CandidatePage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Candidate Attendance'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              AdditionalCandidatePage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Additional Candidate'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              SubjectChangePage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Subject Change Candidate List'),
                              ),
                            )
                        ),
                      )
                  ),
                  //Removed on 19.7.2022(SizedBox & Card)
                  // SizedBox(height: 5),
                  // Card(
                  //     child:  InkWell(
                  //       splashColor: Colors.blue.withAlpha(30),
                  //       onTap: () async{
                  //         // Navigator.pop(context);
                  //         // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  //         //     BookletHandlePage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                  //         Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                  //         postMeeting["exam_id"] = widget.examId;
                  //         postMeeting["dayid"] = widget.dayId;
                  //         postMeeting["sessionid"]=widget.sessionId;
                  //         TNPSCService service=new TNPSCService();
                  //         List<dynamic>? response;
                  //         Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/booklet-handle/details",postMeeting,Constants.AUTH_TOKEN);
                  //         if(m?.statusCode==200){
                  //           debugPrint(m?.response.toString());
                  //           if(m?.response["status"]=="success") {
                  //             response = m?.response["data"] ?? [];
                  //           }
                  //         }
                  //         if(response!=null && response.length>0){
                  //           Map<String,dynamic> data=response[0];
                  //           widget.reasonType=data["handle_to"];
                  //           _handleTime.text=data["handle_time"];
                  //         }
                  //         showDialog(
                  //           barrierColor: Colors.black26,
                  //           context: context,
                  //           builder: (mcontext) {
                  //             return bookletHandleDialog(context,mcontext);
                  //           },
                  //         );
                  //       },
                  //       child: Container(
                  //           height: MediaQuery.of(context).size.height * 0.1,
                  //           child: Center(
                  //             child: ListTile(
                  //               leading: Icon(Icons.calendar_today,color: Colors.green,),
                  //               title: Text('Booklet Handover Details'),
                  //             ),
                  //           )
                  //       ),
                  //     )
                  // ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async{
                          // Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          //     QuestionDistributedPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                          Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          postMeeting["exam_id"] = widget.examId;
                          postMeeting["dayid"] = widget.dayId;
                          postMeeting["sessionid"]=widget.sessionId;
                          TNPSCService service=new TNPSCService();
                          List<dynamic>? response;
                          Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/qp-distributed/details",postMeeting,Constants.AUTH_TOKEN);
                          if(m?.statusCode==200){
                            debugPrint(m?.response.toString());
                            if(m?.response["status"]=="success") {
                              response = m?.response["data"] ?? [];
                            }
                          }
                          if(response!=null && response.length>0){
                            Map<String,dynamic> data=response[0];
                            // widget.answerType=data["answer"];
                            // _comments.text=data["remarks"];
                            _distTime.text=data["time"];
                          }else{
                            // widget.answerType="No";
                            // _comments.text="";
                            _distTime.text="";
                          }
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (mcontext) {
                              return qsnDistributionDialog(context,mcontext);
                            },
                          );
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Distribution of Question Paper'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ExamDamageShortagePage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.assignment_turned_in,color: Colors.green,),
                                title: Text((Constants.EXAM_TYPE=="Descriptive")?"Replacement of Booklet":"Replacement of Question Paper/Answer Sheet"),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ExamCandidateRemarksPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.warning,color: Colors.green,),
                                title: Text('Remarks'),
                                trailing:Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async{
                          // Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          //     QuestionDistributedPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                          Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          postMeeting["exam_id"] = widget.examId;
                          postMeeting["dayid"] = widget.dayId;
                          postMeeting["sessionid"]=widget.sessionId;
                          TNPSCService service=new TNPSCService();
                          Map<String,dynamic>? response;
                          Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/show-videograph-packing",postMeeting,Constants.AUTH_TOKEN);
                          if(m?.statusCode==200){
                            debugPrint(m?.response.toString());
                            if(m?.response["status"]=="success") {
                              response = m?.response["data"] ?? {};
                            }
                          }
                          if(response!=null && response.length>0){
                            Map<String,dynamic> data=response;
                            widget.answerType=data["answer"];
                            _comments.text=data["remarks"];
                          }else{
                            widget.answerType="No";
                            _comments.text="";
                          }
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (mcontext) {
                              return videoPackDialog(context,mcontext);
                            },
                          );
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Whether the entire counting and packing activities of all the Bundles A (Covers A1 & A2) & B (Covers B1, B2,B3,B4 & B5 have been completely videographed without any break? '),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async{
                          // Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          //     QuestionDistributedPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                          Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          postMeeting["exam_id"] = widget.examId;
                          postMeeting["dayid"] = widget.dayId;
                          postMeeting["sessionid"]=widget.sessionId;
                          TNPSCService service=new TNPSCService();
                          Map<String,dynamic>? response;
                          Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/show-videograph-rooms",postMeeting,Constants.AUTH_TOKEN);
                          if(m?.statusCode==200){
                            debugPrint(m?.response.toString());
                            if(m?.response["status"]=="success") {
                              response = m?.response["data"] ?? {};
                            }
                          }
                          if(response!=null && response.length>0){
                            Map<String,dynamic> data=response;
                            widget.answerType=data["answer"];
                            _comments.text=data["remarks"];
                          }else{
                            widget.answerType="No";
                            _comments.text="";
                          }
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (mcontext) {
                              return videoRoomDialog(context,mcontext);
                            },
                          );
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Whether the Videographer has video graphed all the exam rooms during the time of examination covering the entrance and the black board in the classroom, where the REGISTER NUMBERS and the seating arrangement are displayed?'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async{
                          // Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          //     QuestionDistributedPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                          Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          postMeeting["exam_id"] = widget.examId;
                          postMeeting["dayid"] = widget.dayId;
                          postMeeting["sessionid"]=widget.sessionId;
                          TNPSCService service=new TNPSCService();
                          Map<String,dynamic>? response;
                          Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/show-declarations",postMeeting,Constants.AUTH_TOKEN);
                          if(m?.statusCode==200){
                            debugPrint(m?.response.toString());
                            if(m?.response["status"]=="success") {
                              response = m?.response["data"] ?? {};
                            }
                          }
                          if(response!=null && response.length>0){
                            Map<String,dynamic> data=response;
                            widget.answerType=data["answer"];
                            _comments.text=data["count"];
                          }else{
                            widget.answerType="No";
                            _comments.text="";
                          }
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (mcontext) {
                              return declarationDialog(context,mcontext);
                            },
                          );
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Whether any declaration from candidates & Scribes obtained, if so, how many?'),
                              ),
                            )
                        ),
                      )
                  ),
                  //Removed on 19.7.2022(SizedBox & Card)
                  // SizedBox(height: 5),
                  // Card(
                  //     child:  InkWell(
                  //       splashColor: Colors.blue.withAlpha(30),
                  //       onTap: () {
                  //         Navigator.pop(context);
                  //         Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  //             DifferentlyAbledListPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                  //       },
                  //       child: Container(
                  //           height: MediaQuery.of(context).size.height * 0.1,
                  //           child: Center(
                  //             child: ListTile(
                  //               leading: Icon(Icons.warning,color: Colors.green,),
                  //               title: Text('Differentlyabled Candidates'),
                  //               trailing:Icon(Icons.check,color: Colors.white,),
                  //             ),
                  //           )
                  //       ),
                  //     )
                  // ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ExamOMRPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));

                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.comment,color: Colors.green,),
                                title: Text((Constants.EXAM_TYPE=="Descriptive")?'Booklet Remarks':'OMR Remarks'),
                                trailing:  Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          ExamBundleScanListPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                title: Text('Bundle Packing'),
                                trailing:  Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ExamSessionCloserPage(
                                examId: widget.examId,examName:widget.examName,notificationName:widget.notificationName,dayId: widget.dayId,sessionId: widget.sessionId,sessionName: widget.sessionName,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.close_rounded,color: Colors.green,),
                                title: Text('Certificate'),
                                trailing: Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: ()async {
                          Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
                          postExamDetail["examid"] = widget.examId;
                          postExamDetail["dayid"] = widget.dayId;
                          postExamDetail["sessionid"] = widget.sessionId;
                          TNPSCService service=new TNPSCService();
                          HashMap<String,Meta> examData= HashMap<String,Meta>();
                          Meta m=await service.processPostURL(Constants.BaseUrlDev+"/closure-report",postExamDetail,Constants.AUTH_TOKEN);
                          if (m.statusCode == 200) {
                            Map<String,dynamic> reportData={};
                            reportData = m.response;
                            if(reportData["status"]=="success") {
                              try {
                                await service.checkPermission();
                                // await service.download2(reportData["report_url"].toString(),"candidate.pdf");
                                service.downloadFile(
                                    reportData["report_url"].toString(),"closure_report.pdf");
                              }catch(e){
                                debugPrint(e.toString());
                              }
                            }
                          }
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.assignment_turned_in,color: Colors.green,),
                                title: Text('Report Download'),
                                trailing:Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  // SizedBox(height: 5),
                  // Card(
                  //     child:  InkWell(
                  //       splashColor: Colors.blue.withAlpha(30),
                  //       onTap: ()async {
                  //         Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
                  //         postExamDetail["examid"] = widget.examId;
                  //         postExamDetail["dayid"] = widget.dayId;
                  //         postExamDetail["sessionid"] = widget.sessionId;
                  //         TNPSCService service=new TNPSCService();
                  //         HashMap<String,Meta> examData= HashMap<String,Meta>();
                  //         Meta m=await service.processPostURL(Constants.BaseUrlDev+"/consolidated-report",postExamDetail,Constants.AUTH_TOKEN);
                  //         if (m.statusCode == 200) {
                  //           Map<String,dynamic> reportData={};
                  //           reportData = m.response;
                  //           if(reportData["status"]=="success") {
                  //             try {
                  //               await service.checkPermission();
                  //               // await service.download2(reportData["report_url"].toString(),"candidate.pdf");
                  //               service.downloadFile(
                  //                   reportData["report_url"].toString(),"consolidated_report.pdf");
                  //             }catch(e){
                  //               debugPrint(e.toString());
                  //             }
                  //           }
                  //         }
                  //       },
                  //       child: Container(
                  //           height: MediaQuery.of(context).size.height * 0.1,
                  //           child: Center(
                  //             child: ListTile(
                  //               leading: Icon(Icons.assignment_turned_in,color: Colors.green,),
                  //               title: Text('Consolidated Report Download'),
                  //               trailing:Icon(Icons.check,color: Colors.white,),
                  //             ),
                  //           )
                  //       ),
                  //     )
                  // )
                ],
              ),
            )
          //],
          //),
          //)
        ));
  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Total Invigilators",
                        )
                    ),
                  ),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                    padding: EdgeInsets.only(top:20),
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      padding: EdgeInsets.only(top:20),
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["total_invigilators"] = _candidate.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-total-invigilators", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> sresponse = m.response;
                                if (sresponse["status"] == "success" || sresponse["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  postMeeting["exam_id"] = widget.examId;
                                  postMeeting["dayid"] = widget.dayId;
                                  postMeeting["sessionid"]=widget.sessionId;
                                  Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/show-total-invigilators",postMeeting,Constants.AUTH_TOKEN);
                                  if(m1.statusCode==200){
                                    if(m1.response["status"]=="success") {
                                      setState(() {
                                        totalStaff = m1.response;
                                        if(totalStaff["data"]!=null) {
                                          if(totalStaff["data"]["total_invigilators"]!=null) {
                                            _candidate.text = totalStaff["data"]["total_invigilators"].toString();
                                            totalInvigilators=totalStaff["data"]["total_invigilators"].toString();
                                          }else{
                                            totalInvigilators="0";
                                            _candidate.text="0";
                                          }
                                        }
                                      });
                                    }
                                  }
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Total Invigilators updated successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget bookletHandleDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Booklet Handover Details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          width:MediaQuery.of(context).size.width*0.70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.lightGreen),
                              color: Colors.white
                          ),
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                  alignedDropdown: true,child:DropdownButton<String>(
                                style: TextStyle(color: Colors.green[900],fontSize: 16),
                                items: handleto.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: widget.reasonType,
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    widget.reasonType=value!;
                                  });

                                },
                              ))),

                        );}),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:InkWell(
                      onTap: (){
                        _selectHandleTime(context);
                      },
                      child:TextField(
                          controller: _handleTime,
                          decoration: InputDecoration(
                              isDense: true,
                              enabled: false,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero
                              ),
                              hintText: 'Handle Time',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w400
                              ),
                              suffixIcon: Icon(Icons.date_range_outlined,color: Colors.blue[800],)
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["handle_to"] = handleToTypes[handleto.indexOf(widget.reasonType)];;
                              userData["handle_time"]=_handleTime.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-booklet-handle", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Booklet Handover Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  _selectHandleTime(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _handleTime.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
            _handleTime.text.toString(), DateTimeUtils.DD_MM_YYYY_Format,
            DateTimeUtils.YYYY_MM_DD_Format)
        ),
        firstDate: _handleTime.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
            _handleTime.text.toString(), DateTimeUtils.DD_MM_YYYY_Format,
            DateTimeUtils.YYYY_MM_DD_Format)),
        lastDate: DateTime.now()

    );
    if (selected != null) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),

      );
      String selectedTime = "";
      if (picked != null)
        setState(() {
          selectedTime =
              DateTimeUtils().dateToStringFormat(DateTime(
                  selected.year, selected.month, selected.day, picked.hour,
                  picked.minute), DateTimeUtils.DD_MM_YYYY_Format_Time);
        });
      _handleTime.text = selectedTime;
    }
  }
  _selectDistributionTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),

      );
      String selectedTime = "";
      DateTime selected=DateTime.now();
      if (picked != null)
        setState(() {
          selectedTime =
              DateTimeUtils().dateToStringFormat(DateTime(
                  selected.year, selected.month, selected.day, picked.hour,
                  picked.minute), DateTimeUtils.HH_MM_A_Format_Time);
        });
      _distTime.text = selectedTime;
  }
  Widget qsnDistributionDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Time of distribution of Question Paper",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  // StatefulBuilder(
                  //     builder: (BuildContext context, StateSetter setState) {
                  //       return Container(
                  //         margin: EdgeInsets.only(left: 10),
                  //         width:MediaQuery.of(context).size.width*0.70,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(4),
                  //             border: Border.all(color: Colors.lightGreen),
                  //             color: Colors.white
                  //         ),
                  //         child: DropdownButtonHideUnderline(
                  //             child: ButtonTheme(
                  //                 alignedDropdown: true,child:DropdownButton<String>(
                  //               style: TextStyle(color: Colors.green[900],fontSize: 16),
                  //               items: answer.map((String value) {
                  //                 return DropdownMenuItem<String>(
                  //                   value: value,
                  //                   child: Text(value),
                  //                 );
                  //               }).toList(),
                  //               value: widget.answerType,
                  //               onChanged: (value) {
                  //                 debugPrint(value);
                  //                 setState(() {
                  //                   widget.answerType=value!;
                  //                 });
                  //
                  //               },
                  //             ))),
                  //
                  //       );}),
                  // SizedBox(height: 15),
                  // Container(
                  //   margin: EdgeInsets.only(left: 10),
                  //   width:MediaQuery.of(context).size.width*0.70,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(4),
                  //       border: Border.all(color: Colors.lightGreen),
                  //       color: Colors.white
                  //   ),
                  //   child:TextFormField(
                  //       controller:_comments ,
                  //       enabled: true,
                  //       maxLines: 5,
                  //       keyboardType: TextInputType.text,
                  //       textAlign: TextAlign.left,
                  //       decoration: InputDecoration(
                  //         alignLabelWithHint: false,
                  //         labelText: "Remarks",
                  //       )
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:InkWell(
                      onTap: (){
                        _selectDistributionTime(context);
                      },
                      child:TextField(
                          controller: _distTime,
                          decoration: InputDecoration(
                              isDense: true,
                              enabled: false,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero
                              ),
                              hintText: 'Distributed Time',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w400
                              ),
                              suffixIcon: Icon(Icons.date_range_outlined,color: Colors.blue[800],)
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              // userData["answer"] = answerTypes[answerTypes.indexOf(widget.answerType)];;
                              // userData["remarks"]=_comments.text.toString();
                              userData["time"]=_distTime.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-qp-distributed", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Distribution of Question Paper Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget videoPackDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Videographed entire counting and packing activities?",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          width:MediaQuery.of(context).size.width*0.70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.lightGreen),
                              color: Colors.white
                          ),
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                  alignedDropdown: true,child:DropdownButton<String>(
                                style: TextStyle(color: Colors.green[900],fontSize: 16),
                                items: answer.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: widget.answerType,
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    widget.answerType=value!;
                                  });

                                },
                              ))),

                        );}),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_comments ,
                        enabled: true,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Remarks",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["answer"] = answerTypes[answerTypes.indexOf(widget.answerType)];;
                              userData["remarks"]=_comments.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-videograph-packing", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Packing Video Status Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget videoRoomDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Videographed all the exam rooms during the time of examination?",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          width:MediaQuery.of(context).size.width*0.70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.lightGreen),
                              color: Colors.white
                          ),
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                  alignedDropdown: true,child:DropdownButton<String>(
                                style: TextStyle(color: Colors.green[900],fontSize: 16),
                                items: answer.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: widget.answerType,
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    widget.answerType=value!;
                                  });

                                },
                              ))),

                        );}),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_comments ,
                        enabled: true,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Remarks",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["answer"] = answerTypes[answerTypes.indexOf(widget.answerType)];;
                              userData["remarks"]=_comments.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-videograph-rooms", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Room Video Status Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget declarationDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Whether any declaration from candidates & Scribes obtained, if so, how many?",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          width:MediaQuery.of(context).size.width*0.70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.lightGreen),
                              color: Colors.white
                          ),
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                  alignedDropdown: true,child:DropdownButton<String>(
                                style: TextStyle(color: Colors.green[900],fontSize: 16),
                                items: answer.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: widget.answerType,
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    widget.answerType=value!;
                                  });

                                },
                              ))),

                        );}),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_comments ,
                        enabled: true,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Count",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["answer"] = answerTypes[answerTypes.indexOf(widget.answerType)];;
                              userData["count"]=_comments.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-declarations", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Declaration Status Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget qsnBoxDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text((Constants.EXAM_TYPE=="Descriptive")?'Time of Opening the Booklet Box':'Time of Opening the Question Paper Box',style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:InkWell(
                      onTap: (){
                        _selectHandleTime(context);
                      },
                      child:TextField(
                          controller: _handleTime,
                          decoration: InputDecoration(
                              isDense: true,
                              enabled: false,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero
                              ),
                              hintText: 'Opening Time',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w400
                              ),
                              suffixIcon: Icon(Icons.date_range_outlined,color: Colors.blue[800],)
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["qr_details"]="";
                              userData["opening_time"]=_handleTime.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-material-received", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text(((Constants.EXAM_TYPE=="Descriptive")?'Booklet Open Time':'QP Box Open Time')+" Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class ExamUTCPage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String notificationName="";
  String examName="";
  Map<int, String>  savedValues=
  new Map<int, String>();
  String returned="TNPSC inspection";
  ExamUTCPage({this.examId=0,this.dayId=0,this.notificationName="",this.examName=""});
  @override
  _ExamUTCPageState createState() => _ExamUTCPageState();
}

class _ExamUTCPageState extends State<ExamUTCPage> {
  Map<String,dynamic> utcData={};
  Map<String,dynamic> ansData={};
  List<dynamic> questions=[];
  List<dynamic> answer=[];
  Map<int, TextEditingController> _textControllers =
  new Map<int, TextEditingController>();
  double totalUTCAmount=0;
  double amountReceived=0;
  double amountSpent=0;
  double balanceAmount=0;
  TextEditingController _totalAmount=new TextEditingController();
  TextEditingController _amountReceived=new TextEditingController();
  TextEditingController _amountSpent=new TextEditingController();
  TextEditingController _balanceAmount=new TextEditingController();
  TextEditingController _staffname=new TextEditingController();
  TextEditingController _designation=new TextEditingController();
  late Future<HashMap<String,Meta>> _future;
  List<String> returnTo=['TNPSC inspection', 'Mobile Team'];

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    HashMap<String,Meta> ed=new HashMap<String,Meta>();
    _future.then((value){
      ed=value;
      if(ed["question"]!=null) {
        Meta m=ed["question"]??new Meta();
        Meta ans=ed["answer"]??new Meta();
        if(ans!=null && ans.statusCode==200){
          ansData=ans.response;
        }
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          debugPrint(ans.response.toString());
          utcData = m.response;
          setState(() {
            if(utcData["data"]!=null && utcData["data"].length>0){
              questions=utcData["data"];
              for(var question in questions){
                _textControllers[question["qsn_id"]]=new TextEditingController();
              }
            }
            if(ansData["question_data"]!=null && ansData["question_data"].length>0){
              answer=ansData["question_data"];
            }
            if(ansData["utc_amount"]!=null){
              totalUTCAmount=double.parse(ansData["utc_amount"]["amount_spent"].toString());
              amountReceived=double.parse(ansData["utc_amount"]["amount_received"].toString());
              amountSpent=double.parse(ansData["utc_amount"]["amount_spent"].toString());
              balanceAmount=double.parse(ansData["utc_amount"]["balance_amount"].toString());
              _totalAmount.text=totalUTCAmount.toStringAsFixed(2);
              _amountReceived.text=amountReceived.toStringAsFixed(2);
              _amountSpent.text=amountSpent.toStringAsFixed(2);
              _balanceAmount.text=balanceAmount.toStringAsFixed(2);
              _staffname.text=ansData["utc_amount"]["name"]==null?"":ansData["utc_amount"]["name"];
              _designation.text=ansData["utc_amount"]["desig"]==null?"":ansData["utc_amount"]["desig"];
              widget.returned=ansData["utc_amount"]["amount_return_to"]==null?"TNPSC inspection":ansData["utc_amount"]["amount_return_to"].toString();
            }
          });
        }
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text("Utilization Certificate"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> DaysListPage(examId: widget.examId,notificationName: widget.notificationName)));            },
          ),
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: questions!=null && questions.length>0?Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children:[  getQuestionList()]),
                  Visibility(visible:false,child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Container(
                            margin: EdgeInsets.only(left: 10,top:10),
                            height: 50,
                            padding: EdgeInsets.only(top:10),
                            width :  MediaQuery.of(context).size.width*0.60,
                            child:Text("Total ",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                        Container(
                            margin: EdgeInsets.only(left: 10,top:10),
                            height: 50,
                            width : MediaQuery.of(context).size.width*0.30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white
                            ),child:TextFormField(
                          controller:_totalAmount ,
                          enabled: false,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            labelText: "",
                          ),
                        ))])),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Container(
                            margin: EdgeInsets.only(left: 10,top:10),
                            height: 50,
                            padding: EdgeInsets.only(top:10),
                            width :  MediaQuery.of(context).size.width*0.60,
                            child:Text("Amount Spent",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                        Container(
                            margin: EdgeInsets.only(left: 10,top:10),
                            height: 50,
                            width : MediaQuery.of(context).size.width*0.30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white
                            ),child:TextFormField(
                          controller:_amountSpent ,
                          enabled: false,
                          onChanged: (value){
                            setState(() {
                              getTotal();
                            });
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            labelText: "",
                          ),
                        ))]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Container(
                            margin: EdgeInsets.only(left: 10,top:10),
                            height: 50,
                            padding: EdgeInsets.only(top:10),
                            width :  MediaQuery.of(context).size.width*0.60,
                            child:Text("Amount Received",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                        Container(
                            margin: EdgeInsets.only(left: 10,top:10),
                            height: 50,
                            width : MediaQuery.of(context).size.width*0.30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white
                            ),child:TextFormField(
                          controller:_amountReceived ,
                          enabled: true,
                          onChanged: (value){
                            setState(() {
                              getTotal();
                            });
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            labelText: "",
                          ),
                        ))]),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Container(
                            margin: EdgeInsets.only(left: 10,top:10),
                            height: 50,
                            padding: EdgeInsets.only(top:10),
                            width :  MediaQuery.of(context).size.width*0.60,
                            child:
                            Text("Balance Amount",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                        Container(
                            margin: EdgeInsets.only(left: 10,top:10),
                            height: 50,
                            width : MediaQuery.of(context).size.width*0.30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white
                            ),child:TextFormField(
                          controller:_balanceAmount ,
                          enabled: false,
                          onChanged: (value){
                            setState(() {
                              getTotal();
                            });
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            labelText: "",
                          ),
                        )),]),
                  Visibility(visible:balanceAmount>0?true:false ,
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Container(
                                margin: EdgeInsets.only(left: 10,top:10),
                                height: 50,
                                padding: EdgeInsets.only(top:10),
                                width :  MediaQuery.of(context).size.width*0.40,
                                child:
                                Text("Amount Returned To",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                            Container(
                              margin: EdgeInsets.only(left: 10,top:10),
                              height: 50,
                              width : MediaQuery.of(context).size.width*0.50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white
                              ),child:DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                    alignedDropdown: true,child:DropdownButton<String>(
                                  style: TextStyle(color: Colors.green[900],fontSize: 16),
                                  items: returnTo.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  value: widget.returned,
                                  onChanged: (value) {
                                    debugPrint(value);
                                    setState(() {
                                      widget.returned=value!;
                                    });

                                  },
                                ))),),])),
                  Visibility(visible:balanceAmount>0?true:false ,
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Container(
                                margin: EdgeInsets.only(left: 10,top:10),
                                height: 50,
                                padding: EdgeInsets.only(top:10),
                                width :  MediaQuery.of(context).size.width*0.40,
                                child:
                                Text("Name",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                            Container(
                                margin: EdgeInsets.only(left: 10,top:10),
                                height: 50,
                                width : MediaQuery.of(context).size.width*0.50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white
                                ),child:TextFormField(
                              controller:_staffname ,
                              enabled: true,
                              onChanged: (value){
                                setState(() {
                                  getTotal();
                                });
                              },
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                alignLabelWithHint: false,
                                labelText: "",
                              ),
                            )),])),
                  Visibility(visible:balanceAmount>0?true:false ,
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Container(
                                margin: EdgeInsets.only(left: 10,top:10),
                                height: 50,
                                padding: EdgeInsets.only(top:10),
                                width :  MediaQuery.of(context).size.width*0.40,
                                child:
                                Text("Designation",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                            Container(
                                margin: EdgeInsets.only(left: 10,top:10),
                                height: 50,
                                width : MediaQuery.of(context).size.width*0.50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white
                                ),child:TextFormField(
                              controller:_designation ,
                              enabled: true,
                              onChanged: (value){
                                setState(() {
                                  getTotal();
                                });
                              },
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                alignLabelWithHint: false,
                                labelText: "",
                              ),
                            )),])),

                  Padding(padding:EdgeInsets.only(top:10),child:Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900] ,
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              // userData["dayid"]=widget.dayId;
                              userData["total_utc_amount"] = totalUTCAmount;
                              userData["amount_received"] = amountReceived;
                              userData["amount_spent"] = amountSpent;
                              userData["balance_amount"] = balanceAmount;
                              userData["amount_return_to"]=widget.returned;
                              userData["name"]=_staffname.text.toString();
                              userData["desig"]=_designation.text.toString();
                              userData["utilization"]=[];
                              for(var question in questions){
                                Map<String,dynamic> ans={};
                                ans["qsn_id"]=question["qsn_id"];
                                try {
                                  if (_textControllers[question["qsn_id"]] != "" )
                                    ans["ans"]=double.parse(_textControllers[question["qsn_id"]]!.text.toString());
                                }catch(e){
                                  ans["ans"]=0;
                                  // do nothing
                                }
                                userData["utilization"].add(ans);
                              }
                              debugPrint(userData.toString());
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/utilization-certificate", userData,
                                  Constants.AUTH_TOKEN);
                              if (m.statusCode == 200) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> DaysListPage(examId: widget.examId,notificationName: widget.notificationName)));
                              }
                            },
                            child: Text("Submit",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )),

                ],
              ):CircularProgressIndicator(),
            )
        ));
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> utcData= HashMap<String,Meta>();
    Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
    postExamDetail["exam_id"] = widget.examId;
    // postExamDetail["dayid"] = widget.dayId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/utilization-certificate-list",postExamDetail,Constants.AUTH_TOKEN);
    utcData["answer"]=m;
    postExamDetail["examid"] = widget.examId;
    // postExamDetail["dayid"] = widget.dayId;
    Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/utilization-questions",postExamDetail,Constants.AUTH_TOKEN);
    utcData["question"]=m1;
    return utcData;
  }
  Widget getQuestionList(){
    for(var ans in answer){
      if(_textControllers[int.parse(ans["qsn_id"].toString())]!=null) {
        _textControllers[int.parse(ans["qsn_id"].toString())]!.text = ans["ans"].toString();
      }
    }
    return Expanded(child:ListView.builder(
        key: PageStorageKey("ExamUTC_PageStorageKey"),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context, j) {
          if(widget.savedValues[questions[j]["qsn_id"]]!=null) {
            _textControllers[questions[j]["qsn_id"]]!.text =
            widget.savedValues[questions[j]["qsn_id"]]!;
          }else{
            widget.savedValues[questions[j]["qsn_id"]]=_textControllers[questions[j]["qsn_id"]]!.text.toString();
          }
          // debugPrint("ssss"+_textControllers[questions[j]["qsn_id"]]!.text.toString());
          // _textControllers[questions[j]["qsn_id"]]=new TextEditingController();
          // if(answer.where((ans) => ans["qsn_id"] == questions[j]["qsn_id"]).toList().length>0) {
          //   _textControllers[int.parse(questions[j]["qsn_id"])]!.text =
          //       answer.where((ans) => ans["qsn_id"] == questions[j]["qsn_id"]).first()["ans"].toString();
          // }
          // debugPrint(svg);
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {

                return Container(
                  padding: EdgeInsets.only(left:10,right:10,top:10),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 50,
                            width :  MediaQuery.of(context).size.width*0.60,
                            child:Text(questions[j]["question"],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 50,
                            width : MediaQuery.of(context).size.width*0.30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white
                            ),child:TextFormField(
                          controller:_textControllers[questions[j]["qsn_id"]] ,
                          enabled: true,
                          onChanged: (value){
                            widget.savedValues[questions[j]["qsn_id"]]=value;
                            setState(() {
                              getTotal();
                            });
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            labelText: "",
                          ),
                        ))]),

                );});}));

  }
  void getTotal(){
    totalUTCAmount=0;
    for(var question in questions){
      try {
        if (_textControllers[question["qsn_id"]] != "" )
          totalUTCAmount = totalUTCAmount+double.parse(_textControllers[question["qsn_id"]]!.text.toString());
      }catch(e){
        totalUTCAmount = totalUTCAmount+0;
        // do nothing
      }
    }
    _totalAmount.text=totalUTCAmount.toStringAsFixed(2);
    _amountSpent.text=totalUTCAmount.toStringAsFixed(2);
    if(_amountReceived.text!=""){
      try {
        amountReceived = double.parse(_amountReceived.text.toString());
      }catch(e){
        amountReceived=0;
        // do nothing
      }
    }
    if(_amountSpent.text!=""){
      try {
        amountSpent = double.parse(_amountSpent.text.toString());
      }catch(e){
        amountSpent=0;
        // do nothing
      }
    }
    balanceAmount=(amountReceived-amountSpent);
    _balanceAmount.text=(amountReceived-amountSpent).toStringAsFixed(2);
  }
}
class ExamBundleScanListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  ExamBundleScanListPage({this.type=1,this.returnedQrCode="",this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _ExamBundleScanPageState createState() => _ExamBundleScanPageState();
}

class _ExamBundleScanPageState extends State<ExamBundleScanListPage> {
  List<dynamic> response=[];
  List<dynamic> bundleList=[];
  late Future<HashMap<String,Meta>> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HashMap<String,Meta>>(
        future: _future,
        builder: (context, AsyncSnapshot<HashMap<String,Meta>> snapshot) {
          HashMap<String,Meta>? metaData=snapshot.data;
          if(metaData!=null) {
            Meta? m = metaData!["bundlelist"];
            Meta? m1 = metaData!["namelist"];
            if (m?.statusCode == 200) {
              debugPrint(m?.response.toString());
              if (m?.response["status"] == "success") {
                response = m?.response["data"] ?? [];
              }
            }
            if (m1?.statusCode == 200) {
              debugPrint(m1?.response.toString());
              if (m1?.response["status"] == "success") {
                bundleList = m1?.response["data"] ?? [];
              }
            }
          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Bundle Packing"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(mainAxisSize: MainAxisSize.min,children:[getBundleScanList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> responseData= HashMap<String,Meta>();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/bundle-packing-list",postMeeting,Constants.AUTH_TOKEN);
    responseData["bundlelist"]=m;
    Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/bundle-packing/name-list",postMeeting,Constants.AUTH_TOKEN);
    responseData["namelist"]=m1;
    return responseData;
  }
  Widget getBundleScanList(){
    debugPrint(" bundlelist "+bundleList.length.toString());
    return Expanded(child: ListView.builder(
        key: PageStorageKey("BundleScan_PageStorageKey"),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount:  bundleList.length,
        itemBuilder: (context, j) {

          // debugPrint(svg);

          return Container(
              padding: EdgeInsets.only(left:10,right:10,top:10),
              child:
              Card(
                child:  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              QrPage(value: 1,examId: widget.examId,type: "add-bundle-packing",notificationName: widget.notificationName,examName:widget.examName,dayId: widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,bundleName: bundleList[j]["bundle_name"],bundleLabel: bundleList[j]["label"])));
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,

                        child: ListTile(
                          leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                          title: Text( bundleList[j]["label"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing: (response!=null && response.where((bundle) => bundle["bundle"] == bundleList[j]["bundle_name"]).toList().length>0)? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
                        )
                    )),
              )
          );}));

  }
}

// class ExamUTCPage extends StatefulWidget {
//   int examId=0;
//   int dayId=0;
//   String notificationName="";
//   String examName="";
//   Map<int, String>  savedValues=
//   new Map<int, String>();
//   String returned="TNPSC inspection";
//   ExamUTCPage({this.examId=0,this.dayId=0,this.notificationName="",this.examName=""});
//   @override
//   _ExamUTCPageState createState() => _ExamUTCPageState();
// }
//
// class _ExamUTCPageState extends State<ExamUTCPage> {
//   Map<String,dynamic> utcData={};
//   Map<String,dynamic> ansData={};
//   List<dynamic> questions=[];
//   List<dynamic> answer=[];
//   Map<int, TextEditingController> _textControllers =
//   new Map<int, TextEditingController>();
//   double totalUTCAmount=0;
//   double amountReceived=0;
//   double amountSpent=0;
//   double balanceAmount=0;
//   TextEditingController _totalAmount=new TextEditingController();
//   TextEditingController _amountReceived=new TextEditingController();
//   TextEditingController _amountSpent=new TextEditingController();
//   TextEditingController _balanceAmount=new TextEditingController();
//   late Future<HashMap<String,Meta>> _future;
//   List<String> returnTo=['TNPSC inspection', 'Mobile Team'];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     _future = callAsyncMethod();
//     HashMap<String,Meta> ed=new HashMap<String,Meta>();
//     _future.then((value){
//       ed=value;
//       if(ed["question"]!=null) {
//         Meta m=ed["question"]??new Meta();
//         Meta ans=ed["answer"]??new Meta();
//         if(ans!=null && ans.statusCode==200){
//           ansData=ans.response;
//         }
//         if (m.statusCode == 200) {
//           debugPrint(m.response.toString());
//           debugPrint(ans.response.toString());
//           utcData = m.response;
//           setState(() {
//             if(utcData["data"]!=null && utcData["data"].length>0){
//               questions=utcData["data"];
//               for(var question in questions){
//                 _textControllers[question["qsn_id"]]=new TextEditingController();
//               }
//             }
//             if(ansData["question_data"]!=null && ansData["question_data"].length>0){
//               answer=ansData["question_data"];
//             }
//             if(ansData["utc_amount"]!=null){
//               totalUTCAmount=double.parse(ansData["utc_amount"]["amount_spent"]);
//               amountReceived=double.parse(ansData["utc_amount"]["amount_received"]);
//               amountSpent=double.parse(ansData["utc_amount"]["amount_spent"]);
//               balanceAmount=double.parse(ansData["utc_amount"]["balance_amount"]);
//               _totalAmount.text=totalUTCAmount.toStringAsFixed(2);
//               _amountReceived.text=amountReceived.toStringAsFixed(2);
//               _amountSpent.text=amountSpent.toStringAsFixed(2);
//               _balanceAmount.text=balanceAmount.toStringAsFixed(2);
//               widget.returned=ansData["utc_amount"]["aamount_return_to"];
//             }
//           });
//         }
//       }
//
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.green[900],
//           title: Text("Utilization Certificate"),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: (){
//               Navigator.pop(context);
//               Navigator.push(context, MaterialPageRoute(builder: (context)=> DaysListPage(examId: widget.examId,notificationName: widget.notificationName)));            },
//           ),
//         ),
//         body: SafeArea(
//             child:SingleChildScrollView(
//               child: questions!=null && questions.length>0?Column(mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Row(children:[  getQuestionList()]),
//             Visibility(visible:false,child:Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children:[
//                         Container(
//                             margin: EdgeInsets.only(left: 10,top:10),
//                             height: 50,
//                             padding: EdgeInsets.only(top:10),
//                             width :  MediaQuery.of(context).size.width*0.60,
//                             child:Text("Total ",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
//                         Container(
//                             margin: EdgeInsets.only(left: 10,top:10),
//                             height: 50,
//                             width : MediaQuery.of(context).size.width*0.30,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(color: Colors.grey),
//                                 color: Colors.white
//                             ),child:TextFormField(
//                           controller:_totalAmount ,
//                           enabled: false,
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.right,
//                           decoration: InputDecoration(
//                             alignLabelWithHint: false,
//                             labelText: "",
//                           ),
//                         ))])),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children:[
//                         Container(
//                             margin: EdgeInsets.only(left: 10,top:10),
//                             height: 50,
//                             padding: EdgeInsets.only(top:10),
//                             width :  MediaQuery.of(context).size.width*0.60,
//                             child:Text("Amount Spent",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
//                         Container(
//                             margin: EdgeInsets.only(left: 10,top:10),
//                             height: 50,
//                             width : MediaQuery.of(context).size.width*0.30,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(color: Colors.grey),
//                                 color: Colors.white
//                             ),child:TextFormField(
//                           controller:_amountSpent ,
//                           enabled: false,
//                           onChanged: (value){
//                             setState(() {
//                               getTotal();
//                             });
//                           },
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.right,
//                           decoration: InputDecoration(
//                             alignLabelWithHint: false,
//                             labelText: "",
//                           ),
//                         ))]),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children:[
//                         Container(
//                             margin: EdgeInsets.only(left: 10,top:10),
//                             height: 50,
//                             padding: EdgeInsets.only(top:10),
//                             width :  MediaQuery.of(context).size.width*0.60,
//                             child:Text("Amount Received",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
//                         Container(
//                             margin: EdgeInsets.only(left: 10,top:10),
//                             height: 50,
//                             width : MediaQuery.of(context).size.width*0.30,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(color: Colors.grey),
//                                 color: Colors.white
//                             ),child:TextFormField(
//                           controller:_amountReceived ,
//                           enabled: true,
//                           onChanged: (value){
//                             setState(() {
//                               getTotal();
//                             });
//                           },
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.right,
//                           decoration: InputDecoration(
//                             alignLabelWithHint: false,
//                             labelText: "",
//                           ),
//                         ))]),
//
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children:[
//                         Container(
//                             margin: EdgeInsets.only(left: 10,top:10),
//                             height: 50,
//                             padding: EdgeInsets.only(top:10),
//                             width :  MediaQuery.of(context).size.width*0.60,
//                             child:
//                             Text("Balance Amount",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
//                         Container(
//                             margin: EdgeInsets.only(left: 10,top:10),
//                             height: 50,
//                             width : MediaQuery.of(context).size.width*0.30,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(color: Colors.grey),
//                                 color: Colors.white
//                             ),child:TextFormField(
//                           controller:_balanceAmount ,
//                           enabled: false,
//                           onChanged: (value){
//                             setState(() {
//                               getTotal();
//                             });
//                           },
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.right,
//                           decoration: InputDecoration(
//                             alignLabelWithHint: false,
//                             labelText: "",
//                           ),
//                         )),]),
//     Visibility(visible:balanceAmount>0?true:false ,child:Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children:[
//     Container(
//     margin: EdgeInsets.only(left: 10,top:10),
//     height: 50,
//     padding: EdgeInsets.only(top:10),
//     width :  MediaQuery.of(context).size.width*0.40,
//     child:
//     Text("Amount Returned To",textAlign:TextAlign.end,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
//     Container(
//     margin: EdgeInsets.only(left: 10,top:10),
//     height: 50,
//     width : MediaQuery.of(context).size.width*0.50,
//     decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(8),
//     border: Border.all(color: Colors.grey),
//     color: Colors.white
//     ),child:DropdownButtonHideUnderline(
//         child: ButtonTheme(
//             alignedDropdown: true,child:DropdownButton<String>(
//           style: TextStyle(color: Colors.green[900],fontSize: 16),
//           items: returnTo.map((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//           value: widget.returned,
//           onChanged: (value) {
//             debugPrint(value);
//             setState(() {
//               widget.returned=value!;
//             });
//
//           },
//         ))),),])),
//                   Padding(padding:EdgeInsets.only(top:10),child:Align(
//                         alignment: FractionalOffset.bottomCenter,
//                         child: ButtonTheme(
//                             height: MediaQuery.of(context).size.height * 0.06,
//                             minWidth: MediaQuery.of(context).size.width * 0.9,
//                             child: RaisedButton(
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                               elevation: 1,
//                               color: Colors.green[900] ,
//                               onPressed: ()async{
//                                 Map<String, dynamic> userData = new Map<String, dynamic>();
//                                 userData["exam_id"] = widget.examId;
//                                 // userData["dayid"]=widget.dayId;
//                                 userData["total_utc_amount"] = totalUTCAmount;
//                                 userData["amount_received"] = amountReceived;
//                                 userData["amount_spent"] = amountSpent;
//                                 userData["balance_amount"] = balanceAmount;
//                                 userData["amount_return_to"]=widget.returned;
//                                 userData["utilization"]=[];
//                                 for(var question in questions){
//                                   Map<String,dynamic> ans={};
//                                   ans["qsn_id"]=question["qsn_id"];
//                                   try {
//                                     if (_textControllers[question["qsn_id"]] != "" )
//                                       ans["ans"]=double.parse(_textControllers[question["qsn_id"]]!.text.toString());
//                                   }catch(e){
//                                     ans["ans"]=0;
//                                     // do nothing
//                                   }
//                                   userData["utilization"].add(ans);
//                                 }
//                                 TNPSCService service = new TNPSCService();
//                                 Meta m = await service.processPostURL(
//                                     Constants.BaseUrlDev + "/exam/utilization-certificate", userData,
//                                     Constants.AUTH_TOKEN);
//                                 if (m.statusCode == 200) {
//                                   Navigator.pop(context);
//                                   Navigator.push(context, MaterialPageRoute(builder: (context)=> DaysListPage(examId: widget.examId,notificationName: widget.notificationName)));
//                                 }
//                               },
//                               child: Text("Submit",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
//                             )
//                         )
//                     )),
//
//                 ],
//               ):CircularProgressIndicator(),
//             )
//         ));
//   }
//   Future<HashMap<String,Meta>> callAsyncMethod() async{
//     TNPSCService service=new TNPSCService();
//     HashMap<String,Meta> utcData= HashMap<String,Meta>();
//     Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
//     postExamDetail["exam_id"] = widget.examId;
//     // postExamDetail["dayid"] = widget.dayId;
//     Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/utilization-certificate-list",postExamDetail,Constants.AUTH_TOKEN);
//     utcData["answer"]=m;
//     postExamDetail["examid"] = widget.examId;
//     // postExamDetail["dayid"] = widget.dayId;
//     Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/utilization-questions",postExamDetail,Constants.AUTH_TOKEN);
//     utcData["question"]=m1;
//     return utcData;
//   }
//   Widget getQuestionList(){
//     for(var ans in answer){
//       if(_textControllers[int.parse(ans["qsn_id"])]!=null) {
//         _textControllers[int.parse(ans["qsn_id"])]!.text = ans["ans"].toString();
//       }
//     }
//     return Expanded(child:ListView.builder(
//         key: PageStorageKey("ExamUTC_PageStorageKey"),
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: questions.length,
//         itemBuilder: (context, j) {
//           if(widget.savedValues[questions[j]["qsn_id"]]!=null) {
//             _textControllers[questions[j]["qsn_id"]]!.text =
//             widget.savedValues[questions[j]["qsn_id"]]!;
//           }else{
//             widget.savedValues[questions[j]["qsn_id"]]=_textControllers[questions[j]["qsn_id"]]!.text.toString();
//           }
//           // debugPrint("ssss"+_textControllers[questions[j]["qsn_id"]]!.text.toString());
//           // _textControllers[questions[j]["qsn_id"]]=new TextEditingController();
//           // if(answer.where((ans) => ans["qsn_id"] == questions[j]["qsn_id"]).toList().length>0) {
//           //   _textControllers[int.parse(questions[j]["qsn_id"])]!.text =
//           //       answer.where((ans) => ans["qsn_id"] == questions[j]["qsn_id"]).first()["ans"].toString();
//           // }
//           // debugPrint(svg);
//           return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//
//     return Container(
//               padding: EdgeInsets.only(left:10,right:10,top:10),
//               child:Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:[
//               Container(
//               margin: EdgeInsets.only(left: 10),
//               height: 50,
//               width :  MediaQuery.of(context).size.width*0.60,
//                   child:Text(questions[j]["question"],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
//             Container(
//                 margin: EdgeInsets.only(left: 10),
//                 height: 50,
//                 width : MediaQuery.of(context).size.width*0.30,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey),
//                     color: Colors.white
//                 ),child:TextFormField(
//                   controller:_textControllers[questions[j]["qsn_id"]] ,
//                   enabled: true,
//               onChanged: (value){
//                 widget.savedValues[questions[j]["qsn_id"]]=value;
//                 setState(() {
//                   getTotal();
//                 });
//               },
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.right,
//                   decoration: InputDecoration(
//                     alignLabelWithHint: false,
//                     labelText: "",
//                   ),
//                 ))]),
//
//           );});}));
//
//   }
//   void getTotal(){
//     totalUTCAmount=0;
//       for(var question in questions){
//         try {
//           if (_textControllers[question["qsn_id"]] != "" )
//             totalUTCAmount = totalUTCAmount+double.parse(_textControllers[question["qsn_id"]]!.text.toString());
//         }catch(e){
//           totalUTCAmount = totalUTCAmount+0;
//           // do nothing
//         }
//       }
//       _totalAmount.text=totalUTCAmount.toStringAsFixed(2);
//       _amountSpent.text=totalUTCAmount.toStringAsFixed(2);
//       if(_amountReceived.text!=""){
//         try {
//             amountReceived = double.parse(_amountReceived.text.toString());
//         }catch(e){
//           amountReceived=0;
//           // do nothing
//         }
//       }
//     if(_amountSpent.text!=""){
//       try {
//         amountSpent = double.parse(_amountSpent.text.toString());
//       }catch(e){
//         amountSpent=0;
//         // do nothing
//       }
//     }
//       balanceAmount=(amountReceived-amountSpent);
//       _balanceAmount.text=(amountReceived-amountSpent).toStringAsFixed(2);
//   }
// }
// class ExamBundleScanListPage extends StatefulWidget {
//   int type=1;
//   String returnedQrCode="";
//   int examId=0;
//   String notificationName="";
//   String sessionName="";
//   String examName="";
//   int dayId=0;
//   int sessionId=0;
//   ExamBundleScanListPage({this.type=1,this.returnedQrCode="",this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
//   @override
//   _ExamBundleScanPageState createState() => _ExamBundleScanPageState();
// }
//
// class _ExamBundleScanPageState extends State<ExamBundleScanListPage> {
//   List<dynamic> response=[];
//   List<dynamic> bundleList=[];
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<HashMap<String,Meta>>(
//         future: callAsyncMethod(),
//         builder: (context, AsyncSnapshot<HashMap<String,Meta>> snapshot) {
//           HashMap<String,Meta>? metaData=snapshot.data;
//           if(metaData!=null) {
//             Meta? m = metaData!["bundlelist"];
//             Meta? m1 = metaData!["namelist"];
//             if (m?.statusCode == 200) {
//               debugPrint(m?.response.toString());
//               if (m?.response["status"] == "success") {
//                 response = m?.response["data"] ?? [];
//               }
//             }
//             if (m1?.statusCode == 200) {
//               debugPrint(m1?.response.toString());
//               if (m1?.response["status"] == "success") {
//                 bundleList = m1?.response["data"] ?? [];
//               }
//             }
//           }
//           return Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.green[900],
//                 title: Text("Bundle Packing"),
//                 leading: IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: (){
//                     Navigator.pop(context);
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
//                 ),
//               ),
//               body:SafeArea(
//                 child:SingleChildScrollView(
//                   child:
//                   Center(
//                     child: snapshot.hasData? Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(mainAxisSize: MainAxisSize.min,children:[getBundleScanList()])
//                       ],
//                     ):CircularProgressIndicator(),
//                   )
//               )));
//
//         }
//     );
//
//   }
//   Future<HashMap<String,Meta>> callAsyncMethod() async{
//     TNPSCService service=new TNPSCService();
//     HashMap<String,Meta> responseData= HashMap<String,Meta>();
//     Map<String, dynamic> postMeeting = new Map<String, dynamic>();
//     postMeeting["exam_id"] = widget.examId;
//     postMeeting["dayid"] = widget.dayId;
//     postMeeting["sessionid"]=widget.sessionId;
//     Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/bundle-packing-list",postMeeting,Constants.AUTH_TOKEN);
//     responseData["bundlelist"]=m;
//     Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/bundle-packing/name-list",postMeeting,Constants.AUTH_TOKEN);
//     responseData["namelist"]=m1;
//     return responseData;
//   }
//   Widget getBundleScanList(){
//     debugPrint(" bundlelist "+bundleList.length.toString());
//     return Expanded(child: ListView.builder(
//         key: PageStorageKey("BundleScan_PageStorageKey"),
//         shrinkWrap: true,
//         physics: ClampingScrollPhysics(),
//         scrollDirection: Axis.vertical,
//         itemCount:  bundleList.length,
//         itemBuilder: (context, j) {
//
//           // debugPrint(svg);
//
//           return Container(
//               padding: EdgeInsets.only(left:10,right:10,top:10),
//               child:
//               Card(
//                 child:  InkWell(
//                     splashColor: Colors.blue.withAlpha(30),
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(
//                           builder: (context) =>
//                               QrPage(value: 1,examId: widget.examId,type: "add-bundle-packing",notificationName: widget.notificationName,examName:widget.examName,dayId: widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,bundleName: bundleList[j]["label"])));
//                     },
//                     child: Container(
//                         height: MediaQuery.of(context).size.height * 0.1,
//
//                         child: ListTile(
//                           leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
//                           title: Text( bundleList[j]["label"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
//                           trailing: (response!=null && response.where((bundle) => bundle["bundle"] == bundleList[j]["bundle_name"]).toList().length>0)? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
//                         )
//                     )),
//               )
//           );}));
//
//   }
// }

class ExamMalpracticePage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  ExamMalpracticePage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _ExamMalpracticePageState createState() => _ExamMalpracticePageState();
}

class _ExamMalpracticePageState extends State<ExamMalpracticePage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _comments=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
              },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Malpractice"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                child:SingleChildScrollView(
                  child:
                  Center(
                    child: snapshot.hasData?Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children:[getMalpractiveList()])
                      ],
                    ):CircularProgressIndicator(),
                  )
              )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["examid"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/malpractice-list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getMalpractiveList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("MalScan_PageStorageKey"),
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
                          title: Text("Reg No: "+ response[j]["candidate"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["malpractice_id"] = response[j]["malpractice_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/malpractice", userData,
                                Constants.AUTH_TOKEN);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["examid"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/malpractice-list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    _comments.text="";
    return AlertDialog(
      title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Furnish the candidate's details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

      ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

              Container(
              margin: EdgeInsets.only(left: 10),
              width:MediaQuery.of(context).size.width*0.70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.lightGreen),
                  color: Colors.white
              ),
              child:TextFormField(
                controller:_candidate ,
                enabled: true,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    alignLabelWithHint: false,
                    labelText: "Reg. No",
                  )
              ),
            ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                      controller:_comments ,
                      enabled: true,
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Remarks",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                                Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["examid"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["reg_no"] = _candidate.text.toString();
                              userData["remarks"] = _comments.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-malpractice", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["examid"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/malpractice-list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //       if(m1.response["data"]!=null){
                                  //         setState(() {
                                  //           response = m1.response["data"] ?? [];
                                  //         });
                                  //       }
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Malpractice Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class ExamOMRPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Returned Blank OMR Sheet";
  ExamOMRPage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _ExamOMRPageState createState() => _ExamOMRPageState();
}

class _ExamOMRPageState extends State<ExamOMRPage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _comments=new TextEditingController();
  List<String> reasons=['Used Non-personalised OMR Sheet', 'Returned Blank OMR Sheet', 'Used pencil in OMR Sheet', 'Used Other than Black ball Point Pen'];
  List<String> reasonTypes=['nonpersonalised', 'blank', 'pencil', 'otherpen'];
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text((Constants.EXAM_TYPE=="Descriptive")?"Booklet Remarks":"OMR Remarks"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                child:SingleChildScrollView(
                  child:
                  Center(
                    child: snapshot.hasData?Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children:[getOMRList()])
                      ],
                    ):CircularProgressIndicator(),
                  )
              )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/omr-remarks-list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getOMRList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("OMRScan_PageStorageKey"),
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
                          title: Text("Reg No: "+ response[j]["candidate"]+"\nReason:"+response[j]["remarkstype"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["exam_id"] = widget.examId;
                            userData["dayid"] = widget.dayId;
                            userData["sessionid"] = widget.sessionId;
                            userData["remarkstype"]=response[j]["remarkstype"];
                            userData["data_id"] = response[j]["data_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/omr-remarks/delete", userData,
                                Constants.AUTH_TOKEN);
                            debugPrint(m.statusMsg);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["exam_id"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/omr-remarks-list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    widget.reasonType="Returned Blank OMR Sheet";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Furnish the candidate's details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Reg. No",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
    StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
    return Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                    alignedDropdown: true,child:DropdownButton<String>(
                      isExpanded:true,
                      style: TextStyle(color: Colors.green[900],fontSize: 16),
                      items: reasons.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: widget.reasonType,
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          widget.reasonType=value!;
                        });

                      },
                    ))),

                  );}),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                                  Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["reg_no"] = _candidate.text.toString();
                              userData["remarks_type"] = reasonTypes[reasons.indexOf(widget.reasonType)];
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-omr-remarks", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> sresponse = m.response;
                                if (sresponse["status"] == "success" || sresponse["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["exam_id"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/omr-remarks-list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     setState(() {
                                  //       response = m1.response["data"] ?? [];
                                  //     });
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("OMR Remarks Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}
class ExamSessionCloserPage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String notificationName="";
  String examName="";
  String sessionName="";
  int sessionId=0;
  Map<int, String> mRadioValues =
  new Map<int, String>();
  ExamSessionCloserPage({this.examId=0,this.dayId=0,this.notificationName="",this.examName="",this.sessionName="",this.sessionId=0});
  @override
  _ExamSessionCloserPageState createState() => _ExamSessionCloserPageState();
}

class _ExamSessionCloserPageState extends State<ExamSessionCloserPage> {
  Map<String,dynamic> utcData={};
  Map<String,dynamic> ansData={};
  List<dynamic> questions=[];
  List<dynamic> answer=[];
  Map<int, String> _radioValues =
  new Map<int, String>();
  late Future<HashMap<String,Meta>> _future;
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    HashMap<String,Meta> ed=new HashMap<String,Meta>();
    _future.then((value){
      ed=value;
      if(ed["question"]!=null) {
        Meta m=ed["question"]??new Meta();
        Meta ans=ed["answer"]??new Meta();
        if(ans!=null && ans.statusCode==200){
          ansData=ans.response;
        }
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          debugPrint(ans.response.toString());
          utcData = m.response;
          setState(() {
            if(utcData["data"]!=null && utcData["data"].length>0){
              questions=utcData["data"];
              for(var question in questions){
                _radioValues[question["qsn_id"]]="no";
              }
            }
            if(ansData["data"]!=null && ansData["data"].length>0){
              answer=ansData["data"];
            }
          });
        }
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text("Certificate"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionName: widget.sessionName,sessionId: widget.sessionId,)));            },
          ),
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: questions!=null && questions.length>0?Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children:[  getQuestionList()]),
                  Padding(padding:EdgeInsets.only(top:10),child:Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900] ,
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"]=widget.dayId;
                              userData['sessionid']=widget.sessionId;
                              userData["closing"]=[];
                              for(var question in questions){
                                Map<String,dynamic> ans={};
                                ans["qsn_id"]=question["qsn_id"];
                                try {
                                  if (_radioValues[question["qsn_id"]] != "" )
                                    ans["ans"]=_radioValues[question["qsn_id"]].toString();
                                }catch(e){
                                  ans["ans"]="no";
                                  // do nothing
                                }
                                userData["closing"].add(ans);
                              }
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-closer-details", userData,
                                  Constants.AUTH_TOKEN);
                              if (m.statusCode == 200) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                              }
                            },
                            child: Text("Submit",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )),

                ],
              ):CircularProgressIndicator(),
            )
        ));
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> utcData= HashMap<String,Meta>();
    Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
    postExamDetail["exam_id"] = widget.examId;
    postExamDetail["dayid"] = widget.dayId;
    postExamDetail["sessionid"] = widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/closer-details-list",postExamDetail,Constants.AUTH_TOKEN);
    utcData["answer"]=m;
    postExamDetail["examid"] = widget.examId;
    postExamDetail["dayid"] = widget.dayId;
    postExamDetail["sessionid"] = widget.sessionId;
    Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/closer-details/questions",postExamDetail,Constants.AUTH_TOKEN);
    utcData["question"]=m1;
    return utcData;
  }
  Widget getQuestionList(){
    for(var ans in answer){
      if(_radioValues[int.parse(ans["qsn_id"])]!=null) {
        _radioValues[int.parse(ans["qsn_id"])] = ans["ans"].toString();
      }
    }
    return Expanded(child:ListView.builder(
        key: PageStorageKey("ExamClosingQtns_PageStorageKey"),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context, j) {
          if(widget.mRadioValues[questions[j]["qsn_id"]]!=null) {
            _radioValues[questions[j]["qsn_id"]] =
            widget.mRadioValues[questions[j]["qsn_id"]]!;
          }else{
            widget.mRadioValues[questions[j]["qsn_id"]]=_radioValues[questions[j]["qsn_id"]].toString();
          }
          // debugPrint(svg);

          return Container(
            padding: EdgeInsets.only(left:10,right:10,top:10),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      width : MediaQuery.of(context).size.width*0.97,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: Colors.grey),
                      //     color: Colors.white
                      // ),
                      child:StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Row(children:[Expanded(child:Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.green[900],
                                    disabledColor: Colors.green[900],
                                    toggleableActiveColor:Colors.green[900]
                                ),child:CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text((j+1).toString()+"."+questions[j]["question"],textAlign:TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                              value: _radioValues[questions[j]["qsn_id"]]=="yes"?true:false,
                              // groupValue: _radioValues[questions[j]["qsn_id"]],
                              onChanged: (bool? value) {
                                widget.mRadioValues[questions[j]["qsn_id"]] = value!?"yes":"no";
                                setState(() {
                                  _radioValues[questions[j]["qsn_id"]] = value!?"yes":"no";
                                });
                              },
                            ))),]);}
                      ))
    //               Container(
    //                   margin: EdgeInsets.only(left: 10),
    //                   width :  MediaQuery.of(context).size.width*0.97,
    //                   child:Text((j+1).toString()+"."+questions[j]["question"],textAlign:TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
    //               Container(
    //                   margin: EdgeInsets.only(left: 10),
    //                   height: 50,
    //                   width : MediaQuery.of(context).size.width*0.97,
    //                   // decoration: BoxDecoration(
    //                   //     borderRadius: BorderRadius.circular(8),
    //                   //     border: Border.all(color: Colors.grey),
    //                   //     color: Colors.white
    //                   // ),
    //                   child:StatefulBuilder(
    // builder: (BuildContext context, StateSetter setState) {
    // return Row(children:[Expanded(child:Theme(
    //                   data: Theme.of(context).copyWith(
    //                       unselectedWidgetColor: Colors.green[900],
    //                       disabledColor: Colors.green[900],
    //                       toggleableActiveColor:Colors.green[900]
    //                   ),child:RadioListTile<String>(
    //                 title: const Text('Yes'),
    //                 value: "yes",
    //                 groupValue: _radioValues[questions[j]["qsn_id"]],
    //                 onChanged: (String? value) {
    //                   widget.mRadioValues[questions[j]["qsn_id"]] = value!;
    //                   setState(() {
    //                     _radioValues[questions[j]["qsn_id"]] = value!;
    //                   });
    //                 },
    //               ))),
    //                 Expanded(child:Theme(
    //       data: Theme.of(context).copyWith(
    //       unselectedWidgetColor: Colors.green[900],
    //       disabledColor: Colors.green[900],
    //           toggleableActiveColor:Colors.green[900]
    //       ),child:RadioListTile<String>(
    //                   title: const Text('No'),
    //                   value: "no",
    //                   groupValue: _radioValues[questions[j]["qsn_id"]],
    //                   onChanged: (String? value) {
    //                     widget.mRadioValues[questions[j]["qsn_id"]] = value!;
    //                     setState(() {
    //                       _radioValues[questions[j]["qsn_id"]] = value!;
    //                     });
    //                   },
    //                 ))),]);}
    //               ))
                ]),

          );}));

  }
}
class ExamPreliminaryPage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String notificationName="";
  String examName="";
  String sessionName="";
  int sessionId=0;
  Map<int, String> mRadioValues =
  new Map<int, String>();
  ExamPreliminaryPage({this.examId=0,this.dayId=0,this.notificationName="",this.examName="",this.sessionName="",this.sessionId=0});
  @override
  _ExamPreliminaryPageState createState() => _ExamPreliminaryPageState();
}

class _ExamPreliminaryPageState extends State<ExamPreliminaryPage> {
  Map<String,dynamic> prelimData={};
  Map<String,dynamic> ansData={};
  List<dynamic> questions=[];
  List<dynamic> answer=[];
  Map<int, String> _radioValues =
  new Map<int, String>();
  Map<int,Map<String,TextEditingController>> _textControllers=new Map<int,Map<String,TextEditingController>>();
  late Future<HashMap<String,Meta>> _future;
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    HashMap<String,Meta> ed=new HashMap<String,Meta>();
    _future.then((value){
      ed=value;
      if(ed["question"]!=null) {
        Meta m=ed["question"]??new Meta();
        Meta ans=ed["answer"]??new Meta();
        if(ans!=null && ans.statusCode==200){
          ansData=ans.response;
        }
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          debugPrint(ans.response.toString());
          prelimData = m.response;
          setState(() {
            if(prelimData["data"]!=null && prelimData["data"].length>0){
              questions=prelimData["data"];
              for(var question in questions){
                _radioValues[question["qsn_id"]]="no";
                if(question["answer_format"]["data"]!=null) {
                  question["answer_format"]["data"].forEach((k,v) {
                        if(_textControllers[question["qsn_id"]]==null) {
                          _textControllers[question["qsn_id"]] = new Map<
                              String,
                              TextEditingController>();
                        }
                        _textControllers[question["qsn_id"]]![k]=new TextEditingController();
                  });
                }
              }
            }
            if(ansData["data"]!=null && ansData["data"].length>0){
              answer=ansData["data"];
            }
          });
        }
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text("Preliminary Checklist"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> DaysListPage(examId: widget.examId,notificationName: widget.notificationName,)));            },
          ),
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: questions!=null && questions.length>0?Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children:[  getQuestionList()]),
                  Padding(padding:EdgeInsets.only(top:10),child:Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900] ,
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              // userData["dayid"]=widget.dayId;
                              userData["checklist"]=[];
                              for(var question in questions){
                                Map<String,dynamic> ans={};
                                ans["qsn_id"]=question["qsn_id"];
                                try {
                                  if (_radioValues[question["qsn_id"]] != "" )
                                    ans["ans"]=_radioValues[question["qsn_id"]].toString();
                                }catch(e){
                                  ans["ans"]="no";
                                  // do nothing
                                }
                                userData["checklist"].add(ans);
                              }
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/preliminary-checklist", userData,
                                  Constants.AUTH_TOKEN);
                              if (m.statusCode == 200) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> DaysListPage(examId: widget.examId,notificationName: widget.notificationName)));
                              }
                            },
                            child: Text("Submit",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )),

                ],
              ):CircularProgressIndicator(),
            )
        ));
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> prelimData= HashMap<String,Meta>();
    Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
    postExamDetail["exam_id"] = widget.examId;
    // postExamDetail["dayid"] = widget.dayId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/preliminary-checklist/list",postExamDetail,Constants.AUTH_TOKEN);
    prelimData["answer"]=m;
    postExamDetail["examid"] = widget.examId;
    // postExamDetail["dayid"] = widget.dayId;
    Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/preliminary-checklist/questions",postExamDetail,Constants.AUTH_TOKEN);
    prelimData["question"]=m1;
    return prelimData;
  }
  Widget getQuestionList(){
    for(var ans in answer){
      if(_radioValues[int.parse(ans["qsn_id"])]!=null) {
        _radioValues[int.parse(ans["qsn_id"])] = ans["ans"].toString();
      }
    }
    return Expanded(child:ListView.builder(
        key: PageStorageKey("ExamClosingQtns_PageStorageKey"),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context, j) {
          if(widget.mRadioValues[questions[j]["qsn_id"]]!=null) {
            _radioValues[questions[j]["qsn_id"]] =
            widget.mRadioValues[questions[j]["qsn_id"]]!;
          }else{
            widget.mRadioValues[questions[j]["qsn_id"]]=_radioValues[questions[j]["qsn_id"]].toString();
          }

          // debugPrint(svg);

          return Container(
            padding: EdgeInsets.only(left:10,right:10,top:10),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      width :  MediaQuery.of(context).size.width*0.97,
                      child:Text((j+1).toString()+"."+questions[j]["question"],textAlign:TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 50,
                      width : MediaQuery.of(context).size.width*(questions[j]["answer_format"]["ans"].contains(":NA")?0.97:0.97),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: Colors.grey),
                      //     color: Colors.white
                      // ),
                      child:Align(alignment:Alignment.topLeft,child:StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Row(children:[Expanded(child:Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.green[900],
                                    disabledColor: Colors.green[900],
                                    toggleableActiveColor:Colors.green[900]
                                ),child:RadioListTile<String>(
                              title: const Text('Yes'),
                              value: "yes",
                              groupValue: _radioValues[questions[j]["qsn_id"]],
                              onChanged: (String? value) {
                                widget.mRadioValues[questions[j]["qsn_id"]] = value!;
                                setState(() {
                                  _radioValues[questions[j]["qsn_id"]] = value!;
                                });
                              },
                            ))),
                              Expanded(child:Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.green[900],
                                      disabledColor: Colors.green[900],
                                      toggleableActiveColor:Colors.green[900]
                                  ),child:RadioListTile<String>(
                                title: const Text('No'),
                                value: "no",
                                groupValue: _radioValues[questions[j]["qsn_id"]],
                                onChanged: (String? value) {
                                  widget.mRadioValues[questions[j]["qsn_id"]] = value!;
                                  setState(() {
                                    _radioValues[questions[j]["qsn_id"]] = value!;
                                  });

                                },
                              ))),Visibility(visible:questions[j]["answer_format"]["ans"].contains(":NA")?true:false,child:Expanded(child:Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.green[900],
                                      disabledColor: Colors.green[900],
                                      toggleableActiveColor:Colors.green[900]
                                  ),child:RadioListTile<String>(
                                title: const Text('NA'),
                                value: "NA",
                                groupValue: _radioValues[questions[j]["qsn_id"]],
                                onChanged: (String? value) {
                                  widget.mRadioValues[questions[j]["qsn_id"]] = value!;
                                  setState(() {
                                    _radioValues[questions[j]["qsn_id"]] = value!;
                                  });
                                },
                              ))))]);}
                      ))),
                ]),


          );}));

  }
}
class ExamSessionPreliminaryPage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String notificationName="";
  String examName="";
  String sessionName="";
  int sessionId=0;
  List<dynamic> questions=[];
  List<dynamic> answer=[];
  Map<int,Map<String,String>> mTextValues=new Map<int,Map<String,String>>();
  Map<int, String> mRadioValues =
  new Map<int, String>();

  Map<int,Map<String,TextEditingController>> _textControllers=new Map<int,Map<String,TextEditingController>>();
  Map<int, String> _radioValues =
  new Map<int, String>();
  ExamSessionPreliminaryPage({this.examId=0,this.dayId=0,this.notificationName="",this.examName="",this.sessionName="",this.sessionId=0});
  @override
  _ExamSessionPreliminaryPageState createState() => _ExamSessionPreliminaryPageState();
  void createControllers(List<dynamic> questions){
    for(var question in questions){
      _radioValues[question["qsn_id"]]="no";
      if(question["answer_format"]["data"]!=null) {
        question["answer_format"]["data"].forEach((k,v) {
          if(_textControllers[question["qsn_id"]]==null) {
            _textControllers[question["qsn_id"]] = new Map<
                String,
                TextEditingController>();
          }
          _textControllers[question["qsn_id"]]![k]=new TextEditingController();
        });
      }
    }
  }
}

class _ExamSessionPreliminaryPageState extends State<ExamSessionPreliminaryPage> {
  Map<String,dynamic> prelimData={};
  Map<String,dynamic> ansData={};
  late Future<HashMap<String,Meta>> _future;
  @override
  void initState() {
    // TODO: implement initState
      _future = callAsyncMethod();
      HashMap<String, Meta> ed = new HashMap<String, Meta>();
      _future.then((value) {
        ed = value;
        if (ed["question"] != null) {
          Meta m = ed["question"] ?? new Meta();
          Meta ans = ed["answer"] ?? new Meta();
          if (ans != null && ans.statusCode == 200) {
            ansData = ans.response;
          }
          if (m.statusCode == 200) {
            debugPrint(m.response.toString());
            debugPrint(ans.response.toString());
            prelimData = m.response;
            setState(() {
              if (prelimData["data"] != null && prelimData["data"].length > 0) {
                widget.questions = prelimData["data"];
                widget.createControllers(widget.questions);
              }
              if (ansData["data"] != null && ansData["data"].length > 0) {
                widget.answer = ansData["data"];
              }
            });
          }
        }
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text("Session Checklist"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId: widget.sessionId,sessionName: widget.sessionName,)));            },
          ),
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: widget.questions!=null && widget.questions.length>0?Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children:[  getQuestionList()]),
                  Padding(padding:EdgeInsets.only(top:10),child:Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900] ,
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"]=widget.dayId;
                              userData["sessionid"]=widget.sessionId;
                              userData["checklist"]=[];
                              for(var question in widget.questions){
                                Map<String,dynamic> ans={};
                                ans["qsn_id"]=question["qsn_id"];
                                try {
                                  if (widget._radioValues[question["qsn_id"]] != "" )
                                    ans["ans"]=widget._radioValues[question["qsn_id"]].toString();
                                }catch(e){
                                  ans["ans"]="no";
                                  // do nothing
                                }
                                if(question["answer_format"]["data"]!=null) {
                                  ans["data"]={};
                                  question["answer_format"]["data"].forEach((k,v) {
                                    var key=k;
                                    if(k=="name" || k=="desig" || k=="dept"){
                                      key="ins_"+k;
                                    }
                                    ans["data"][key]=widget._textControllers[question["qsn_id"]]![k]!.text.toString();
                                  });
                                }
                                userData["checklist"].add(ans);
                              }
                              debugPrint(userData.toString());
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/session-checklist", userData,
                                  Constants.AUTH_TOKEN);
                              if (m.statusCode == 200) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                              }
                            },
                            child: Text("Submit",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )),

                ],
              ):CircularProgressIndicator(),
            )
        ));
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> prelimData= HashMap<String,Meta>();
    Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
    postExamDetail["exam_id"] = widget.examId;
    postExamDetail["dayid"] = widget.dayId;
    postExamDetail["sessionid"] = widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/session-checklist/list",postExamDetail,Constants.AUTH_TOKEN);
    prelimData["answer"]=m;
    postExamDetail["examid"] = widget.examId;
    Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/session-checklist/questions",postExamDetail,Constants.AUTH_TOKEN);
    prelimData["question"]=m1;
    return prelimData;
  }
  Widget getQuestionList(){
    for(var ans in widget.answer){
      if(widget._radioValues[int.parse(ans["qsn_id"])]!=null) {
        widget._radioValues[int.parse(ans["qsn_id"])] = ans["ans"].toString();
        // widget.mRadioValues[int.parse(ans["qsn_id"])] = ans["ans"].toString();
      }
      if(ans["data"]!=null) {
        ans["data"].forEach((k,v) {
          var key=k;
          if(k=="ins_name" || k=="ins_desig" || k=="ins_dept"){
            key=k.replaceAll("ins_","");
          }
          widget._textControllers[int.parse(ans["qsn_id"])]![key]!.text=ans["data"][k];
          // if(widget.mTextValues[int.parse(ans["qsn_id"])]==null){
          //   widget.mTextValues[int.parse(ans["qsn_id"])]=new Map<String,String>();
          // }
          // widget.mTextValues[int.parse(ans["qsn_id"])]![key]=widget._textControllers[int.parse(ans["qsn_id"])]![key]!.text.toString();
        });
      }
    }
    return Expanded(child:ListView.builder(
        key: PageStorageKey("ExamSessionQtns_PageStorageKey"),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.questions.length,
        itemBuilder: (context, j) {
          if(widget.mRadioValues[widget.questions[j]["qsn_id"]]!=null) {
            widget._radioValues[widget.questions[j]["qsn_id"]] =
            widget.mRadioValues[widget.questions[j]["qsn_id"]]!;
          }else{
            widget.mRadioValues[widget.questions[j]["qsn_id"]]=widget._radioValues[widget.questions[j]["qsn_id"]].toString();
          }
          if(widget.questions[j]["answer_format"]["data"]!=null) {
            widget.questions[j]["answer_format"]["data"].forEach((k,v) {
              var key=k;
              // if(k=="name" || k=="desig" || k=="dept"){
              //   key="ins_"+k;
              // }
              if(widget.mTextValues[widget.questions[j]["qsn_id"]]!=null && widget.mTextValues[widget.questions[j]["qsn_id"]]![key]!=null) {
                widget._textControllers[widget.questions[j]["qsn_id"]]![key]!
                    .text =
                widget.mTextValues[widget.questions[j]["qsn_id"]]![key]!;
              }else{
                if(widget.mTextValues[widget.questions[j]["qsn_id"]]==null){
                  widget.mTextValues[widget.questions[j]["qsn_id"]]=new Map<String,String>();
                }
                widget.mTextValues[widget.questions[j]["qsn_id"]]![key]
                =widget._textControllers[widget.questions[j]["qsn_id"]]![key]!
                    .text.toString();

              }
              widget._textControllers[widget.questions[j]["qsn_id"]]![key]!.selection = TextSelection.fromPosition(TextPosition(offset: widget._textControllers[widget.questions[j]["qsn_id"]]![key]!.text.length));
            });
          }
          // debugPrint(svg);
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
            padding: EdgeInsets.only(left:10,right:10,top:10),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      width :  MediaQuery.of(context).size.width*0.97,
                      child:Text((j+1).toString()+"."+widget.questions[j]["question"],textAlign:TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 50,
                      width : MediaQuery.of(context).size.width*(widget.questions[j]["answer_format"]["ans"].contains(":NA")?0.97:0.97),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: Colors.grey),
                      //     color: Colors.white
                      // ),
                      child:StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Row(children:[Expanded(child:Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.green[900],
                                    disabledColor: Colors.green[900],
                                    toggleableActiveColor:Colors.green[900]
                                ),child:RadioListTile<String>(
                              title: const Text('Yes'),
                              value: "yes",
                              groupValue: widget._radioValues[widget.questions[j]["qsn_id"]],
                              onChanged: (String? value) {
                                widget.mRadioValues[widget.questions[j]["qsn_id"]] = value!;
                                setState(() {
                                  widget._radioValues[widget.questions[j]["qsn_id"]]=value!;
                                });
                              },
                            ))),
                              Expanded(child:Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.green[900],
                                      disabledColor: Colors.green[900],
                                      toggleableActiveColor:Colors.green[900]
                                  ),child:RadioListTile<String>(
                                title: const Text('No'),
                                value: "no",
                                groupValue: widget._radioValues[widget.questions[j]["qsn_id"]],
                                onChanged: (String? value) {
                                  widget.mRadioValues[widget.questions[j]["qsn_id"]] = value!;
                                  setState(() {
                                    widget._radioValues[widget.questions[j]["qsn_id"]]=value!;
                                  });
                                },
                              ))),Visibility(visible:widget.questions[j]["answer_format"]["ans"].contains(":NA")?true:false,child:Expanded(child:Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.green[900],
                                      disabledColor: Colors.green[900],
                                      toggleableActiveColor:Colors.green[900]
                                  ),child:RadioListTile<String>(
                                title: const Text('NA'),
                                value: "NA",
                                groupValue: widget._radioValues[widget.questions[j]["qsn_id"]],
                                onChanged: (String? value) {
                                  widget.mRadioValues[widget.questions[j]["qsn_id"]] = value!;
                                  setState(() {
                                    widget._radioValues[widget.questions[j]["qsn_id"]]=value!;
                                  });
                                },
                              ))))]);}
                      )),
                  widget.questions[j]["answer_format"]["data"]!=null && widget.questions[j]["answer_format"]["data"]["name"]!=null?
                  Container(
                    padding: EdgeInsets.only(left:10,right:10,top:10),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Container(
                              margin: EdgeInsets.only(left: 10,top:10),
                              height: 40,
                              width :  MediaQuery.of(context).size.width*0.30,
                              child:Text("Name",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 40,
                              width : MediaQuery.of(context).size.width*0.50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white
                              ),child:TextFormField(
                            controller:widget._textControllers[widget.questions[j]["qsn_id"]]!["name"] ,
                            enabled: true,
                            keyboardType: TextInputType.text,
                            onChanged: (String? value) {
                              widget.mTextValues[widget.questions[j]["qsn_id"]]!["name"]=value!;
                              debugPrint(value);
                              // setState(() {
                              //   _textControllers[questions[j]["qsn_id"]]!["name"]!.text = value!;
                              // });
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: false,
                              labelText: "",
                            ),
                          ))]),

                  ):Visibility(visible:false,child: Text("None")),
                  widget.questions[j]["answer_format"]["data"]!=null && widget.questions[j]["answer_format"]["data"]["desig"]!=null?
                  Container(
                    padding: EdgeInsets.only(left:10,right:10,top:10),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Container(
                              margin: EdgeInsets.only(left: 10,top:10),
                              height: 40,
                              width :  MediaQuery.of(context).size.width*0.30,
                              child:Text("Designation",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 40,
                              width : MediaQuery.of(context).size.width*0.50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white
                              ),child:TextFormField(
                            controller:widget._textControllers[widget.questions[j]["qsn_id"]]!["desig"] ,
                            enabled: true,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            onChanged: (String? value) {
                              widget.mTextValues[widget.questions[j]["qsn_id"]]!["desig"]=value!;
                              debugPrint(value);
                              // setState(() {
                              //   _textControllers[questions[j]["qsn_id"]]!["name"]!.text = value!;
                              // });
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: false,
                              labelText: "",
                            ),
                          ))]),

                  ):Visibility(visible:false,child: Text("None")),
                  widget.questions[j]["answer_format"]["data"]!=null && widget.questions[j]["answer_format"]["data"]["dept"]!=null?
                  Container(
                    padding: EdgeInsets.only(left:10,right:10,top:10),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Container(
                              margin: EdgeInsets.only(left: 10,top:10),
                              height: 40,
                              width :  MediaQuery.of(context).size.width*0.30,
                              child:Text("Department",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 40,
                              width : MediaQuery.of(context).size.width*0.50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white
                              ),child:TextFormField(
                            controller:widget._textControllers[widget.questions[j]["qsn_id"]]!["dept"] ,
                            enabled: true,
                            keyboardType: TextInputType.text,
                            onChanged: (String? value) {
                              widget.mTextValues[widget.questions[j]["qsn_id"]]!["dept"]=value!;
                              debugPrint(value);
                              // setState(() {
                              //   _textControllers[questions[j]["qsn_id"]]!["name"]!.text = value!;
                              // });
                            },
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              alignLabelWithHint: false,
                              labelText: "",
                            ),
                          ))]),

                  ):Visibility(visible:false,child: Text("None")),
                  widget.questions[j]["answer_format"]["data"]!=null && widget.questions[j]["answer_format"]["data"]["pc_no"]!=null && Constants.EXAM_TYPE=="Objective"?
                  Container(
                    padding: EdgeInsets.only(left:10,right:10,top:10),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Container(
                              margin: EdgeInsets.only(left: 10,top:10),
                              height: 40,
                              width :  MediaQuery.of(context).size.width*0.30,
                              child:Text("PC No.",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 40,
                              width : MediaQuery.of(context).size.width*0.50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white
                              ),child:TextFormField(
                            controller:widget._textControllers[widget.questions[j]["qsn_id"]]!["pc_no"] ,
                            enabled: true,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            onChanged: (String? value) {
                              widget.mTextValues[widget.questions[j]["qsn_id"]]!["pc_no"]=value!;
                              debugPrint(value);
                              // setState(() {
                              //   _textControllers[questions[j]["qsn_id"]]!["name"]!.text = value!;
                              // });
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: false,
                              labelText: "",
                            ),
                          ))]),

                  ):Visibility(visible:false,child: Text("None")),
                  widget.questions[j]["answer_format"]["data"]!=null && widget.questions[j]["answer_format"]["data"]["arrival_time"]!=null && Constants.EXAM_TYPE=="Objective"?
                  Container(
                    padding: EdgeInsets.only(left:10,right:10,top:10),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Container(
                              margin: EdgeInsets.only(left: 10,top:10),
                              height: 40,
                              width :  MediaQuery.of(context).size.width*0.30,
                              child:Text("Arrival Time",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                          InkWell(
                            onTap: () async{
                              TimeOfDay? pickedTime=await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now()
                                );
                                if (pickedTime != null){
                                  final localizations = MaterialLocalizations.of(context);
                                  final formattedTimeOfDay = localizations.formatTimeOfDay(pickedTime);
                                  widget.mTextValues[widget.questions[j]["qsn_id"]]!["arrival_time"] = formattedTimeOfDay;
                                  setState(() {
                                    widget._textControllers[widget.questions[j]["qsn_id"]]!["arrival_time"]!.text = formattedTimeOfDay;
                                  });
                                }
                            },
                              child:Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 40,
                              width : MediaQuery.of(context).size.width*0.50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white
                              ),child:TextFormField(
                            controller:widget._textControllers[widget.questions[j]["qsn_id"]]!["arrival_time"] ,
                            enabled: false,
                            keyboardType: TextInputType.text,
                          textAlign: TextAlign.start,
                            onChanged: (String? value) {
                              widget.mTextValues[widget.questions[j]["qsn_id"]]!["arrival_time"]=value!;
                              debugPrint(value);
                              // setState(() {
                              //   _textControllers[questions[j]["qsn_id"]]!["name"]!.text = value!;
                              // });
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: false,
                              labelText: "",
                            ),
                          )))]),

                  ):Visibility(visible:false,child: Text("None")),
                  widget.questions[j]["answer_format"]["data"]!=null && widget.questions[j]["answer_format"]["data"]["pc_count"]!=null && Constants.EXAM_TYPE=="Descriptive"?
                  Container(
                    padding: EdgeInsets.only(left:10,right:10,top:10),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Container(
                              margin: EdgeInsets.only(left: 10,top:10),
                              height: 40,
                              width :  MediaQuery.of(context).size.width*0.30,
                              child:Text("PC Count.",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 40,
                              width : MediaQuery.of(context).size.width*0.50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white
                              ),child:TextFormField(
                            controller:widget._textControllers[widget.questions[j]["qsn_id"]]!["pc_count"] ,
                            enabled: true,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            onChanged: (String? value) {
                              widget.mTextValues[widget.questions[j]["qsn_id"]]!["pc_count"]=value!;
                              debugPrint(value);
                              // setState(() {
                              //   _textControllers[questions[j]["qsn_id"]]!["name"]!.text = value!;
                              // });
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: false,
                              labelText: "",
                            ),
                          ))]),

                  ):Visibility(visible:false,child: Text("None")),
                ]),

          );});
        }));

  }
}
class ExamDamageShortagePage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Blank";
  ExamDamageShortagePage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _ExamDamageShortagePageState createState() => _ExamDamageShortagePageState();
}

class _ExamDamageShortagePageState extends State<ExamDamageShortagePage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _oldno=new TextEditingController();
  TextEditingController _newno=new TextEditingController();
  String paperType="qp";
  String tranType="damage";
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text((Constants.EXAM_TYPE=="Descriptive")?"Replacement of Booklet":"Replacement of Question Paper/Answer Sheet"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                child:SingleChildScrollView(
                  child:
                  Center(
                    child: snapshot.hasData?Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children:[getDamageList()])
                      ],
                    ):CircularProgressIndicator(),
                  )
              )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/damage-shortage-list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getDamageList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("Damage_PageStorageKey"),
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
                          title: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                            Text("Reg No: "+ response[j]["candidate"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold)),
                            Text((response[j]["type"]=="damage"?"Damage":"Shortage")+" : "+(response[j]["papertype"]=="ans"?"Answer Sheet":"Question Paper"),style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold)),
                            Text("Issued No : "+(response[j]["new_omr"]),style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold))]),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["exam_id"] = widget.examId;
                            userData["dayid"] = widget.dayId;
                            userData["sessionid"] = widget.sessionId;
                            userData["data_id"] = response[j]["data_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/damage-shortage/delete", userData,
                                Constants.AUTH_TOKEN);
                            debugPrint(m.statusMsg);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["exam_id"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/damage-shortage-list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    _oldno.text="";
    _newno.text="";
    paperType="qp";
    tranType="damage";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Furnish the candidate's details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:20.0,right:20.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content:SingleChildScrollView(child: Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 5),
                    height: 60,
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: "Reg. No",
                        )
                    ),
                  ),
                  SizedBox(height: 5),
                  Visibility(visible:Constants.EXAM_TYPE=="Objective",child:Container(padding:EdgeInsets.all(5),color:Colors.white, child:Text("Material",style: TextStyle(color:Colors.black,fontSize: 20)))),
          Visibility(visible:Constants.EXAM_TYPE=="Objective",child:Container(
                      margin: EdgeInsets.only(left: 5),
                      height: 50,
                      width : MediaQuery.of(context).size.width*0.95,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: Colors.grey),
                      //     color: Colors.white
                      // ),
                      child:StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Row(mainAxisAlignment:MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[Expanded(child:Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.green[900],
                                    disabledColor: Colors.green[900],
                                    toggleableActiveColor:Colors.green[900]
                                ),child:RadioListTile<String>(
                              title: const Text('Question Paper'),
                              value: "qp",
                              groupValue: paperType,
                              onChanged: (String? value) {
                                setState(() {
                                  paperType = value!;
                                });
                              },
                            ))),
                              Expanded(child:Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.green[900],
                                      disabledColor: Colors.green[900],
                                      toggleableActiveColor:Colors.green[900]
                                  ),child:RadioListTile<String>(
                                title: const Text('Answer Sheet'),
                                value: "ans",
                                groupValue: paperType,
                                onChanged: (String? value) {
                                  setState(() {
                                    paperType = value!;
                                  });
                                },
                              ))),]);}
                      ))),
          Visibility(visible:Constants.EXAM_TYPE=="Objective",child:SizedBox(height: 5)),
                  Container(padding:EdgeInsets.all(5),color:Colors.white, child:Text("Type",style: TextStyle(color:Colors.black,fontSize: 20))),
                  Container(
                      margin: EdgeInsets.only(left: 5),
                      height: 50,
                      width : MediaQuery.of(context).size.width*0.95,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: Colors.grey),
                      //     color: Colors.white
                      // ),
                      child:StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Row(children:[Expanded(child:Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.green[900],
                                    disabledColor: Colors.green[900],
                                    toggleableActiveColor:Colors.green[900]
                                ),child:RadioListTile<String>(
                              title: const Text('Damage'),
                              value: "damage",
                              groupValue: tranType,
                              onChanged: (String? value) {
                                setState(() {
                                  tranType = value!;
                                });
                              },
                            ))),
                              Expanded(child:Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.green[900],
                                      disabledColor: Colors.green[900],
                                      toggleableActiveColor:Colors.green[900]
                                  ),child:RadioListTile<String>(
                                title: const Text('Shortage'),
                                value: "shortage",
                                groupValue: tranType,
                                onChanged: (String? value) {
                                  setState(() {
                                    tranType = value!;
                                  });
                                },
                              ))),]);}
                      )),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 60,
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_oldno ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Old No",
                        )
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 60,
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_newno ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "New No",
                        )
                    ),
                  ),
                  SizedBox(height: 15),

                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                                  Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["candidate"] = _candidate.text.toString();
                              userData["type"] = tranType;
                              userData["papertype"] = paperType;
                              userData["old_sheet"] = _oldno.text.toString();
                              userData["new_sheet"] = _newno.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-damage-shortage", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> sresponse = m.response;
                                if (sresponse["status"] == "success" || sresponse["status"] == "ok" || sresponse["status"] == "Ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["exam_id"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/damage-shortage-list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     setState(() {
                                  //       response = m1.response["data"] ?? [];
                                  //     });
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Damage/Shortage Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        ))
    );
  }
}

class StaffListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Blank";
  StaffListPage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _StaffListPageState createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  List<dynamic> response=[];
  TextEditingController _staffname=new TextEditingController();
  TextEditingController _designation=new TextEditingController();
  TextEditingController _contact=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: '',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Add Invigilator"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getStaffList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/staff-list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getStaffList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("SatffList_PageStorageKey"),
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
                          title: Text("Name: "+ response[j]["name"]+"\nDesignation:"+response[j]["designation"]+"\nContact:"+response[j]["contact"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["exam_id"] = widget.examId;
                            userData["dayid"] = widget.dayId;
                            userData["sessionid"] = widget.sessionId;
                            userData["staff_id"] = response[j]["staff_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/staffs/delete", userData,
                                Constants.AUTH_TOKEN);
                            debugPrint(m.statusMsg);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["exam_id"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/staff-list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _staffname.text="";
    _designation.text="";
    _contact.text="";
    widget.reasonType="Blank";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_staffname ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Name",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_designation ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Designation",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_contact ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Contact",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["name"] = _staffname.text.toString();
                              userData["desig"] = _designation.text.toString();
                              userData["contact"] = _contact.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-staffs", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> sresponse = m.response;
                                if (sresponse["status"] == "success" || sresponse["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["exam_id"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/staff-list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     setState(() {
                                  //       response = m1.response["data"] ?? [];
                                  //     });
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Staff Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}


class ScribeListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Blank";
  ScribeListPage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _ScribeListPageState createState() => _ScribeListPageState();
}

class _ScribeListPageState extends State<ScribeListPage> {
  List<dynamic> response=[];
  TextEditingController _staffname=new TextEditingController();
  TextEditingController _designation=new TextEditingController();
  TextEditingController _contact=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: '',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Add Scribe"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getScribeList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/scribe-list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getScribeList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("ScribeList_PageStorageKey"),
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
                          title: Text("Name: "+ response[j]["name"]+"\nDesignation:"+response[j]["designation"]+"\nMobile:"+response[j]["mobile"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["exam_id"] = widget.examId;
                            userData["dayid"] = widget.dayId;
                            userData["sessionid"] = widget.sessionId;
                            userData["data_id"] = response[j]["data_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/scribes/delete", userData,
                                Constants.AUTH_TOKEN);
                            debugPrint(m.statusMsg);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["exam_id"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/scribe-list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _staffname.text="";
    _designation.text="";
    _contact.text="";
    widget.reasonType="Blank";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_staffname ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Name",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_designation ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Designation",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_contact ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Mobile",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["name"] = _staffname.text.toString();
                              userData["desig"] = _designation.text.toString();
                              userData["contact"] = _contact.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-scribes", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> sresponse = m.response;
                                if (sresponse["status"] == "success" || sresponse["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["exam_id"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/scribe-list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     setState(() {
                                  //       response = m1.response["data"] ?? [];
                                  //     });
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Scribe Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class AssistantListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Blank";
  AssistantListPage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _AssistantListPageState createState() => _AssistantListPageState();
}

class _AssistantListPageState extends State<AssistantListPage> {
  List<dynamic> response=[];
  TextEditingController _name=new TextEditingController();
  TextEditingController _designation=new TextEditingController();
  TextEditingController _contact=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: '',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Add CI Assistants"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getAssistantList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/asistant-list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getAssistantList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("AssistantList_PageStorageKey"),
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
                          title: Text("Name: "+ response[j]["name"]+"\nDesignation:"+response[j]["designation"]+"\nMobile:"+response[j]["mobile"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["exam_id"] = widget.examId;
                            userData["dayid"] = widget.dayId;
                            userData["sessionid"] = widget.sessionId;
                            userData["data_id"] = response[j]["data_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/assistant/delete", userData,
                                Constants.AUTH_TOKEN);
                            debugPrint(m.statusMsg);
                            if (m.statusCode == 200) {
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _name.text="";
    _designation.text="";
    _contact.text="";
    widget.reasonType="Blank";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_name ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Name",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_designation ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Designation",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_contact ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Mobile",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["name"] = _name.text.toString();
                              userData["desig"] = _designation.text.toString();
                              userData["contact"] = _contact.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-assistant", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> sresponse = m.response;
                                if (sresponse["status"] == "success" || sresponse["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Assistant Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class ExamCandidateRemarksPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Indulged in Malpractice";
  ExamCandidateRemarksPage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _ExamCandidateRemarksPageState createState() => _ExamCandidateRemarksPageState();
}

class _ExamCandidateRemarksPageState extends State<ExamCandidateRemarksPage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _comments=new TextEditingController();
  List<String> reasons=['Indulged in Malpractice','Wrongly seated/Used OMR of other candidate','Left the Examination hall during the examination','Used Scribe Assistance'  ];
  List<String> reasonTypes=['malpractice','wrong_seat','cand_left','diff_abled'   ];
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Remarks"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getCandidateRemarksList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["examid"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/candidate-remarks/list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getCandidateRemarksList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("CandidateRemarks_PageStorageKey"),
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
                          title: Text("Reg No: "+ response[j]["candidate"]+"\nType:"+ (response[j]["type"]=="malpractice"?"Indulged in Malpractice":response[j]["type"]=="wrong_seat"?"Wrongly seated/Used OMR of other candidate":response[j]["type"]=="cand_left"?"Left the Examination hall during the examination":response[j]["type"]=="diff_abled"?"Used Scribe Assistance":response[j]["type"]=="declaration"?"Declaration Obtained":""),style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["data_id"] = response[j]["data_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/candidate-remarks/delete", userData,
                                Constants.AUTH_TOKEN);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["examid"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/candidate-remarks/list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    _comments.text="";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Furnish the candidate's details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Reg. No",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          width:MediaQuery.of(context).size.width*0.70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.lightGreen),
                              color: Colors.white
                          ),
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                  alignedDropdown: true,child:DropdownButton<String>(
                                isExpanded: true,
                                style: TextStyle(color: Colors.green[900],fontSize: 16),
                                items: reasons.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: widget.reasonType,
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    widget.reasonType=value!;
                                  });

                                },
                              ))),

                        );}),
                  Visibility(visible:false,child:SizedBox(height: 15)),
                  Visibility(visible:false,child:Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_comments ,
                        enabled: true,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Remarks",
                        )
                    ),
                  )),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["examid"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["reg_no"] = _candidate.text.toString();
                              userData["type"]=reasonTypes[reasons.indexOf(widget.reasonType)];
                              userData["remarks"] = _comments.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-candidate-remarks", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["examid"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/candidate-remarks/list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     if(m1.response["data"]!=null){
                                  //       setState(() {
                                  //         response = m1.response["data"] ?? [];
                                  //       });
                                  //     }
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Malpractice Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class DifferentlyAbledListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Blank";
  DifferentlyAbledListPage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _DifferentlyAbledListPageState createState() => _DifferentlyAbledListPageState();
}

class _DifferentlyAbledListPageState extends State<DifferentlyAbledListPage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: '',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Differentlyabled Candidates"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getDifferentlyAbledList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["examid"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/differently-abled/list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getDifferentlyAbledList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("DifferentlyAbledList_PageStorageKey"),
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
                          title: Text("Reg.No: "+ response[j]["candidate"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            // userData["exam_id"] = widget.examId;
                            // userData["dayid"] = widget.dayId;
                            // userData["sessionid"] = widget.sessionId;
                            userData["diffabled_id"] = response[j]["diffabled_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/differently-abled/delete", userData,
                                Constants.AUTH_TOKEN);
                            debugPrint(m.statusMsg);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["examid"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/differently-abled/list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    widget.reasonType="Blank";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Furnish the candidate's details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Reg.No",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["examid"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["reg_no"] = _candidate.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-differently-abled", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> sresponse = m.response;
                                if (sresponse["status"] == "success" || sresponse["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["examid"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/differently-abled/list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     setState(() {
                                  //       response = m1.response["data"] ?? [];
                                  //     });
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Differentlyabled Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class StaffAttendanceListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Blank";
  StaffAttendanceListPage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _StaffAttendanceListPageState createState() => _StaffAttendanceListPageState();
}

class _StaffAttendanceListPageState extends State<StaffAttendanceListPage> {
  List<dynamic> response=[];
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Invigilator Attendance"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getStaffAttendanceList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/staff-attendance-list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getStaffAttendanceList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("SatffAttendanceList_PageStorageKey"),
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
                          title: Text("Name: "+ response[j]["name"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  CupertinoSwitch(
                            value:response[j]["status"]=="present"?true:false,
                          activeColor: Colors.green[900],
                          onChanged:(value)async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["exam_id"] = widget.examId;
                            userData["dayid"] = widget.dayId;
                            userData["sessionid"] = widget.sessionId;
                            userData["staff_id"] = response[j]["staff_id"];
                            userData["status"]=value?"present":"absent";
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/update-staff-attendance", userData,
                                Constants.AUTH_TOKEN);
                            debugPrint(m.statusMsg);
                            if (m.statusCode == 200) {
                              setState(() {
                                response[j]["status"] = userData["status"];
                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
}

class HallAllocationListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Blank";
  HallAllocationListPage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _HallAllocationListPageState createState() => _HallAllocationListPageState();
}

class _HallAllocationListPageState extends State<HallAllocationListPage> {
  List<dynamic> response=[];
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Invigilator Allotment"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getHallAllocationList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/hall-allocated-list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getHallAllocationList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("HallAllocationList_PageStorageKey"),
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
                          title: Text("Name: "+ response[j]["staff_name"]+" \n Hall: "+ response[j]["hall_code"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  Text(""),
                        )
                    )),
              )
          );}));

  }
}

class AdditionalCandidatePage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  AdditionalCandidatePage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _AdditionalCandidatePageState createState() => _AdditionalCandidatePageState();
}

class _AdditionalCandidatePageState extends State<AdditionalCandidatePage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _name=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Additional Candidate"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getAdditionalCandidateList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["examid"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/additional-candidate/list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getAdditionalCandidateList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("addlcand_PageStorageKey"),
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
                          title: Text("Reg No: "+ response[j]["reg_no"]+" \n"+"Name: "+ response[j]["name"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["addcand_id"] = response[j]["addcand_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/additional-candidate/delete", userData,
                                Constants.AUTH_TOKEN);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["examid"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/additional-candidate/list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    _name.text="";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Furnish the candidate's details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Reg. No",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_name ,
                        enabled: true,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Name",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["examid"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["reg_no"] = _candidate.text.toString();
                              userData["name"] = _name.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-additional-candidate", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["examid"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/additional-candidate/list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     if(m1.response["data"]!=null){
                                  //       setState(() {
                                  //         response = m1.response["data"] ?? [];
                                  //       });
                                  //     }
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Additional Candidate Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class SubjectChangePage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  SubjectChangePage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _SubjectChangePageState createState() => _SubjectChangePageState();
}

class _SubjectChangePageState extends State<SubjectChangePage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _name=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Subject Change Candidate List"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getSubjectChangeList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["examid"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/subject-change/list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getSubjectChangeList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("subjchange_PageStorageKey"),
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
                          title: Text("Reg No: "+ response[j]["reg_no"]+" \n"+"Name: "+ response[j]["name"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["subchg_id"] = response[j]["subchg_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/exam/subject-change/delete", userData,
                                Constants.AUTH_TOKEN);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["examid"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/subject-change/list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    _name.text="";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Furnish the candidate's details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Reg. No",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_name ,
                        enabled: true,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Name",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["examid"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["reg_no"] = _candidate.text.toString();
                              userData["name"] = _name.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-subject-change", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["examid"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/subject-change/list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     if(m1.response["data"]!=null){
                                  //       setState(() {
                                  //         response = m1.response["data"] ?? [];
                                  //       });
                                  //     }
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Additional Candidate Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class BookletHandlePage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="Mobile";
  BookletHandlePage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _BookletHandlePageState createState() => _BookletHandlePageState();
}

class _BookletHandlePageState extends State<BookletHandlePage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _handleTime=new TextEditingController();
  List<String> handleto=['Mobile','Staff','Officer'];
  List<String> handleToTypes=['Mobile','Staff','Officer'];
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Booklet Handle"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getBookletHandleList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/booklet-handle/details",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getBookletHandleList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("booklet_PageStorageKey"),
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
                          title: Text("Handle To: "+ response[j]["handle_to"]+"\nTime:"+ response[j]["handle_time"],style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:Text("")
                          // IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                          //   Map<String, dynamic> userData = new Map<String, dynamic>();
                          //   userData["data_id"] = response[j]["data_id"];
                          //   TNPSCService service = new TNPSCService();
                          //   Meta m = await service.processPostURL(
                          //       Constants.BaseUrlDev + "/exam/candidate-remarks/delete", userData,
                          //       Constants.AUTH_TOKEN);
                          //   if (m.statusCode == 200) {
                          //     Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          //     postMeeting["examid"] = widget.examId;
                          //     postMeeting["dayid"] = widget.dayId;
                          //     postMeeting["sessionid"]=widget.sessionId;
                          //     Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/candidate-remarks/list",postMeeting,Constants.AUTH_TOKEN);
                          //     if(m1.statusCode==200){
                          //       if(m1.response["status"]=="success") {
                          //         setState(() {
                          //           response = m1.response["data"] ?? [];
                          //         });
                          //       }
                          //     }
                          //   }
                          // },)

                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          width:MediaQuery.of(context).size.width*0.70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.lightGreen),
                              color: Colors.white
                          ),
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                  alignedDropdown: true,child:DropdownButton<String>(
                                style: TextStyle(color: Colors.green[900],fontSize: 16),
                                items: handleto.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: widget.reasonType,
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    widget.reasonType=value!;
                                  });

                                },
                              ))),

                        );}),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:InkWell(
                      onTap: (){
                        _selectHandleTime(context);
                      },
                      child:TextField(
                          controller: _handleTime,
                          decoration: InputDecoration(
                              isDense: true,
                              enabled: false,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero
                              ),
                              hintText: 'Handle Time',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w400
                              ),
                              suffixIcon: Icon(Icons.date_range_outlined,color: Colors.blue[800],)
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["handle_to"] = handleToTypes[handleto.indexOf(widget.reasonType)];;
                              userData["handle_time"]=_handleTime.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-booklet-handle", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["exam_id"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/booklet-handle/details",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     if(m1.response["data"]!=null){
                                  //       setState(() {
                                  //         response = m1.response["data"] ?? [];
                                  //       });
                                  //     }
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Booklet Handle Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  _selectHandleTime(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _handleTime.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
            _handleTime.text.toString(), DateTimeUtils.DD_MM_YYYY_Format,
            DateTimeUtils.YYYY_MM_DD_Format)
        ),
        firstDate: DateTime.now(),
        lastDate: DateTime
            .now()

    );
    if (selected != null) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),

      );
      String selectedTime = "";
      if (picked != null)
        setState(() {
          selectedTime =
              DateTimeUtils().dateToStringFormat(DateTime(
                  selected.year, selected.month, selected.day, picked.hour,
                  picked.minute), DateTimeUtils.DD_MM_YYYY_Format_Time);
        });
      _handleTime.text = selectedTime;
    }
  }
}

class QuestionDistributedPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String reasonType="No";
  QuestionDistributedPage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _QuestionDistributedPageState createState() => _QuestionDistributedPageState();
}

class _QuestionDistributedPageState extends State<QuestionDistributedPage> {
  List<dynamic> response=[];
  TextEditingController _comments=new TextEditingController();
  TextEditingController _handleTime=new TextEditingController();
  List<String> handleto=['No','Yes'];
  List<String> handleToTypes=['No','Yes'];
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (mcontext) {
                  return confirmDialog(context,mcontext);
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Question Distribution"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children:[getQuestionDistributedList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/qp-distributed/details",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getQuestionDistributedList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("qsndist_PageStorageKey"),
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
                            title: Text("Question Distributed: "+ response[j]["answer"]+"\nRemarks:"+ response[j]["remarks"],style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                            trailing:Text("")
                          // IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                          //   Map<String, dynamic> userData = new Map<String, dynamic>();
                          //   userData["data_id"] = response[j]["data_id"];
                          //   TNPSCService service = new TNPSCService();
                          //   Meta m = await service.processPostURL(
                          //       Constants.BaseUrlDev + "/exam/candidate-remarks/delete", userData,
                          //       Constants.AUTH_TOKEN);
                          //   if (m.statusCode == 200) {
                          //     Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          //     postMeeting["examid"] = widget.examId;
                          //     postMeeting["dayid"] = widget.dayId;
                          //     postMeeting["sessionid"]=widget.sessionId;
                          //     Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/candidate-remarks/list",postMeeting,Constants.AUTH_TOKEN);
                          //     if(m1.statusCode==200){
                          //       if(m1.response["status"]=="success") {
                          //         setState(() {
                          //           response = m1.response["data"] ?? [];
                          //         });
                          //       }
                          //     }
                          //   }
                          // },)

                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _comments.text="";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          width:MediaQuery.of(context).size.width*0.70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.lightGreen),
                              color: Colors.white
                          ),
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                  alignedDropdown: true,child:DropdownButton<String>(
                                style: TextStyle(color: Colors.green[900],fontSize: 16),
                                items: handleto.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: widget.reasonType,
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    widget.reasonType=value!;
                                  });

                                },
                              ))),

                        );}),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_comments ,
                        enabled: true,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Remarks",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["answer"] = handleToTypes[handleto.indexOf(widget.reasonType)];;
                              userData["remarks"]=_comments.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-qp-distributed", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["examid"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/qp-distributed/details",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     if(m1.response["data"]!=null){
                                  //       setState(() {
                                  //         response = m1.response["data"] ?? [];
                                  //       });
                                  //     }
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Booklet Handle Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class ISExamListPage extends StatefulWidget {
  int examId=0;
  String notificationName="";
  ISExamListPage({this.examId=0,this.notificationName=""});
  @override
  _ISExamListState createState() => _ISExamListState();
}

class _ISExamListState extends State<ISExamListPage> {
  List<dynamic> examData=[];
  TextEditingController _comments=new TextEditingController();
  TNPSCService service=new TNPSCService();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              examData = m?.response["data"] ?? [];
            }
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[900],
              title: Text(widget.notificationName),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 2)));
                },
              ),
            ),
            body:  SafeArea(
                child: Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: snapshot.hasData?Column(
                        children: [
                          getISExamList(),
                        ],
                      ):CircularProgressIndicator(),
                    )
                )
            ),
          );

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    //Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    //postMeeting["examid"] = widget.examId;
    Meta m=await service.processGetURL(Constants.BaseUrlDev+"/is-vd-examlist",Constants.AUTH_TOKEN);
    return m;
  }
  Widget getISExamList(){
    return
      //Expanded(child:
      ListView.builder(
          key: PageStorageKey("ExamIS_PageStorageKey"),
          shrinkWrap: true,
          physics:ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: examData.length,
          itemBuilder: (context, j) {

            // debugPrint(svg);

            return Container(
                padding: EdgeInsets.only(left:10,right:10,top:10),
                height: MediaQuery.of(context).size.height * 0.12,
                child:
                Card(
                  child:  InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            ISDaysListPage(examId:examData[j]["examid"],notificationName:examData[j]["notification_no"],)));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.09,
                        child:
                        Center(
                            child: ListTile(
                              leading: Icon(Icons.calendar_today,color: Colors.green,),
                              title: Container(
                                height: MediaQuery.of(context).size.height * 0.11,

                                child: Padding(padding:EdgeInsets.only(left: 10,top:10),child:Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [Text(examData[j]["exam_name"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                                      Padding(padding:EdgeInsets.only(top:5),child:Text("Notification - "+examData[j]["notification_no"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),)),
                                      Padding(padding:EdgeInsets.only(top:5),child:
                                      Text("Exam Date : "+examData[j]["exam_date"],style: TextStyle(fontSize: 14,color: Colors.green[900],fontWeight: FontWeight.bold)))])),
                              ),
                              trailing:Icon(Icons.check,color: Colors.white,),
                            )),
                      )
                  ),
                )
            );});
    //);

  }
}


class ISDaysListPage extends StatefulWidget {
  int examId=0;
  String notificationName="";
  String answerType="No";
  ISDaysListPage({this.examId=0,this.notificationName=""});
  @override
  _ISDaysListState createState() => _ISDaysListState();
}

class _ISDaysListState extends State<ISDaysListPage> {
  List<dynamic> examData=[];

  TextEditingController _comments=new TextEditingController();
  TextEditingController _remarks=new TextEditingController();
  TextEditingController _meetingDate=new TextEditingController();
  TextEditingController _dispatchedTime=new TextEditingController();
  TNPSCService service=new TNPSCService();
  List<String> answer=['No','Yes'];
  List<String> answerTypes=['No','Yes'];
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              examData = m?.response["data"] ?? [];
            }
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[900],
              title: Text(widget.notificationName),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 0)));
                },
              ),
            ),
            body:  SafeArea(
                child: Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: snapshot.hasData?examData!=null && examData.length>0?Column(
                        children: [
                          // Container(
                          //   padding: EdgeInsets.only(left:10,right:10,top:10),
                          //   child:
                          //   Card(
                          //       child:  InkWell(
                          //         splashColor: Colors.blue.withAlpha(30),
                          //         onTap: () async {
                          //           Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          //           postMeeting["exam_id"] = widget.examId;
                          //           Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is/arrangement/details",postMeeting,Constants.AUTH_TOKEN);
                          //           Map<String,dynamic> resp=Map<String,dynamic>();
                          //           if(m1.statusCode==200){
                          //             if(m1.response["status"]=="success") {
                          //               if(m1.response["data"]!=null){
                          //                 setState(() {
                          //                   resp = m1.response["data"] ?? {};
                          //                 });
                          //               }
                          //             }
                          //           }
                          //           if(resp!=null && resp["answer"]!=null){
                          //             widget.answerType=resp["answer"];
                          //             _comments.text=resp["remarks"];
                          //           }else{
                          //             widget.answerType="No";
                          //             _comments.text="";
                          //           }
                          //           showDialog(
                          //             barrierColor: Colors.black26,
                          //             context: context,
                          //             builder: (mcontext) {
                          //               return hallArrangementDialog(context,mcontext);
                          //             },
                          //           );
                          //         },
                          //         child: Container(
                          //             height: MediaQuery.of(context).size.height * 0.1,
                          //             child: Center(
                          //               child: ListTile(
                          //                 leading: Icon(Icons.checklist,color: Colors.green,),
                          //                 title: Text('Whether Arrangement made in the examination Hall/district is satisfactory?'),
                          //               ),
                          //             )
                          //         ),
                          //       )
                          //   ),
                          // ),
                          // Visibility(visible:!Constants.isChennaiCenter,child:Container(
                          //   padding: EdgeInsets.only(left:10,right:10,top:10),
                          //   child:
                          //   Card(
                          //       child:  InkWell(
                          //         splashColor: Colors.blue.withAlpha(30),
                          //         onTap: () async {
                          //           Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          //           postMeeting["exam_id"] = widget.examId;
                          //           Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is/date-time/details",postMeeting,Constants.AUTH_TOKEN);
                          //           String resp="";
                          //           if(m1.statusCode==200){
                          //             if(m1.response["status"]=="success") {
                          //               if(m1.response["data"]!=null){
                          //                 setState(() {
                          //                   resp = m1.response["data"] ?? "";
                          //                 });
                          //               }
                          //             }
                          //           }
                          //           if(resp!=null){
                          //             _meetingDate.text=resp;
                          //           }else{
                          //             _meetingDate.text="";
                          //           }
                          //           showDialog(
                          //             barrierColor: Colors.black26,
                          //             context: context,
                          //             builder: (mcontext) {
                          //               return meetingDateDialog(context,mcontext);
                          //             },
                          //           );
                          //         },
                          //         child: Container(
                          //             height: MediaQuery.of(context).size.height * 0.1,
                          //             child: Center(
                          //               child: ListTile(
                          //                 leading: Icon(Icons.checklist,color: Colors.green,),
                          //                 title: Text('Collector Meeting Date'),
                          //               ),
                          //             )
                          //         ),
                          //       )
                          //   ),
                          // )),

                          getExamDaysList(),
                          // Container(
                          //   padding: EdgeInsets.only(left:10,right:10,top:10),
                          //   child:
                          //   Card(
                          //       child:  InkWell(
                          //         splashColor: Colors.blue.withAlpha(30),
                          //         onTap: () async {
                          //           Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          //           postMeeting["exam_id"] = widget.examId;
                          //           Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is/time-despatch/details",postMeeting,Constants.AUTH_TOKEN);
                          //           String resp="";
                          //           if(m1.statusCode==200){
                          //             if(m1.response["status"]=="success") {
                          //               if(m1.response["data"]!=null){
                          //                 setState(() {
                          //                   resp = m1.response["data"] ?? "";
                          //                 });
                          //               }
                          //             }
                          //           }
                          //           if(resp!=null){
                          //             _dispatchedTime.text=resp;
                          //           }else{
                          //             _dispatchedTime.text="";
                          //           }
                          //           showDialog(
                          //             barrierColor: Colors.black26,
                          //             context: context,
                          //             builder: (mcontext) {
                          //               return dispatchTimeDialog(context,mcontext);
                          //             },
                          //           );
                          //         },
                          //         child: Container(
                          //             height: MediaQuery.of(context).size.height * 0.1,
                          //             child: Center(
                          //               child: ListTile(
                          //                 leading: Icon(Icons.checklist,color: Colors.green,),
                          //                 title: Text('Time Of Despatch'),
                          //               ),
                          //             )
                          //         ),
                          //       )
                          //   ),
                          // ),
                          // Container(
                          //   padding: EdgeInsets.only(left:10,right:10,top:10),
                          //   child:
                          //   Card(
                          //       child:  InkWell(
                          //         splashColor: Colors.blue.withAlpha(30),
                          //         onTap: () async {
                          //           Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          //           postMeeting["exam_id"] = widget.examId;
                          //           Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is/remarks/details",postMeeting,Constants.AUTH_TOKEN);
                          //           String resp="";
                          //           if(m1.statusCode==200){
                          //             if(m1.response["status"]=="success") {
                          //               if(m1.response["data"]!=null){
                          //                 setState(() {
                          //                   resp = m1.response["data"] ?? "";
                          //                 });
                          //               }
                          //             }
                          //           }
                          //           if(resp!=null){
                          //             _remarks.text=resp;
                          //           }else{
                          //             _remarks.text="";
                          //           }
                          //           showDialog(
                          //             barrierColor: Colors.black26,
                          //             context: context,
                          //             builder: (mcontext) {
                          //               return remarksDialog(context,mcontext);
                          //             },
                          //           );
                          //         },
                          //         child: Container(
                          //             height: MediaQuery.of(context).size.height * 0.1,
                          //             child: Center(
                          //               child: ListTile(
                          //                 leading: Icon(Icons.checklist,color: Colors.green,),
                          //                 title: Text('Additional Remarks'),
                          //               ),
                          //             )
                          //         ),
                          //       )
                          //   ),
                          // ),
                        ],
                      ):Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left:10,right:10,top:10),
                            child:
                            Card(
                                child: Container(
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(Icons.checklist,color: Colors.green,),
                                          title: Text('No Duty Alloted'),
                                        ),
                                      )
                                )
                            ),
                          ),

                        ],
                      ):CircularProgressIndicator(),
                    )
                )
            ),
          );

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["examid"] = widget.examId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/is-vd-dayslist",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getExamDaysList(){
    return
      //Expanded(child:
      ListView.builder(
          key: PageStorageKey("ExamNotify_PageStorageKey"),
          shrinkWrap: true,
          physics:ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: examData.length,
          itemBuilder: (context, j) {

            // debugPrint(svg);

            return Container(
                padding: EdgeInsets.only(left:10,right:10,top:10),
                height: MediaQuery.of(context).size.height * 0.12,
                child:
                Card(
                  child:  InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            ISExamDetailPage(examId:examData[j]["examid"],dayId:examData[j]["dayid"] ,notificationName: examData[j]["exam_name"].toString(),examName:examData[j]["exam_name"].toString() ,)));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.09,
                        child:
                        Center(
                            child: ListTile(
                              leading: Icon(Icons.calendar_today,color: Colors.green,),
                              title: Text("Date : " +examData[j]["examdate"]),
                              trailing:Icon(Icons.check,color: Colors.white,),
                            )),
                        // Padding(padding:EdgeInsets.only(left: 10,top:10),child:Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [Text("Date :" +examData[j]["examdate"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                        //       Padding(padding:EdgeInsets.only(top:5),child:
                        //       Text("Exam Name : "+examData[j]["exam_name"],style: TextStyle(fontSize: 14,color: Colors.green[900],fontWeight: FontWeight.bold)))
                        //     ])),
                      )
                  ),
                )
            );});
    //);

  }
  Widget hallArrangementDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Is Hall Arrangement Satisfactory?",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          width:MediaQuery.of(context).size.width*0.70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.lightGreen),
                              color: Colors.white
                          ),
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                  alignedDropdown: true,child:DropdownButton<String>(
                                style: TextStyle(color: Colors.green[900],fontSize: 16),
                                items: answer.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: widget.answerType,
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    widget.answerType=value!;
                                  });

                                },
                              ))),

                        );}),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_comments ,
                        enabled: true,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Comments",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["answer"] = answerTypes[answerTypes.indexOf(widget.answerType)];
                              userData["remarks"]=_comments.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/is/arrangement", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Hall arrangement Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget remarksDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Remarks",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_remarks ,
                        enabled: true,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Remarks",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["remarks"]=_remarks.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/is/add-remarks", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Remarks Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget dispatchTimeDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Time Of Despatch",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:InkWell(
                      onTap: (){
                        _selectDispatchedTime(context);
                      },
                      child:TextField(
                          controller: _dispatchedTime,
                          decoration: InputDecoration(
                              isDense: true,
                              enabled: false,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero
                              ),
                              hintText: 'Dispatch Time',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w400
                              ),
                              suffixIcon: Icon(Icons.date_range_outlined,color: Colors.blue[800],)
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["time"]=_dispatchedTime.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/is/add-time-despatch", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Dispatched Time Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget meetingDateDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Meeting Date",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:InkWell(
                      onTap: (){
                        _selectCollectorMeetingDate(context);
                      },
                      child:TextField(
                          controller: _meetingDate,
                          decoration: InputDecoration(
                              isDense: true,
                              enabled: false,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero
                              ),
                              hintText: 'Meeting Date',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w400
                              ),
                              suffixIcon: Icon(Icons.date_range_outlined,color: Colors.blue[800],)
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["date_time"]=_meetingDate.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/is/add-date-time", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Meeting Date Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  _selectCollectorMeetingDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _meetingDate.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
            _meetingDate.text.toString(), DateTimeUtils.DD_MM_YYYY_Format,
            DateTimeUtils.YYYY_MM_DD_Format)
        ),
        firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (selected != null) {
      _meetingDate.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      ;
    }
  }
  _selectDispatchedTime(BuildContext context) async{
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

    );
    if (picked != null)
      setState(() {
        _dispatchedTime.text =
            DateTimeUtils().dateToStringFormat(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day, picked.hour,
                picked.minute), DateTimeUtils.HH_MM_A_Format_Time);
      });
  }
}

class ISExamDetailPage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String notificationName="";
  String examName="";
  ISExamDetailPage({this.examId=0,this.dayId=0,this.notificationName="",this.examName=""});
  @override
  _ISExamDetailPageState createState() => _ISExamDetailPageState();
}

class _ISExamDetailPageState extends State<ISExamDetailPage> {
  Map<String,dynamic> meetingData={};
  int forenoonSessionId=0;
  String forenoonSessionType="";
  int afternoonSessionId=0;
  String afternoonSessionType="";
  late Future<HashMap<String,Meta>> _future;
  ReceivePort _port = ReceivePort();
  TextEditingController _hallcode=new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    HashMap<String,Meta> ed=new HashMap<String,Meta>();
    _future.then((value){
      ed=value;
      if(ed["session"]!=null) {
        Meta m=ed["session"]??new Meta();
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          meetingData = m.response;
          setState(() {
            if(meetingData!=null && meetingData["data"]!=null) {
              if(meetingData["data"].where((session) => session["session"] == "FN").toList().length>0) {
                forenoonSessionId =
                meetingData["data"].where((session) => session["session"] == "FN").toList()[0]['sessionid'];
                forenoonSessionType =
                meetingData["data"].where((session) => session["session"] == "FN").toList()[0]['type'];
              }
              if(meetingData["data"].where((session) => session["session"] == "AN").toList().length>0) {
                afternoonSessionId =
                meetingData["data"].where((session) => session["session"] == "AN").toList()[0]['sessionid'];
                afternoonSessionType =
                meetingData["data"].where((session) => session["session"] == "AN").toList()[0]['type'];
              }
            }
          });

        }
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text(widget.notificationName),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ISDaysListPage(examId: widget.examId,notificationName: widget.notificationName,)));
            },
          ),
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: Column(
                // children: [
                //   Container(
                //     height: MediaQuery.of(context).size.height*1.20,
                //     margin: EdgeInsets.all(15),
                //     child: ListView(
                children: <Widget>[
                  SizedBox(height: 5),
                  Visibility(visible:
                  forenoonSessionId>0?true:false
                      ,child:Card(
                          child:  InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () async {
                              if(forenoonSessionType=="is") {
                                Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                postMeeting["examid"] = widget.examId;
                                postMeeting["dayid"] = widget.dayId;
                                postMeeting["sessionid"]=forenoonSessionId;
                                TNPSCService service=new TNPSCService();
                                Map<String,dynamic>? response;
                                Meta m=await service.processPostURL(Constants.BaseUrlDev+"/show-is-hallcode",postMeeting,Constants.AUTH_TOKEN);
                                if(m?.statusCode==200){
                                  debugPrint(m?.response.toString());
                                  if(m?.response["status"]=="success") {
                                    response = m?.response["data"] ?? {};
                                  }
                                }
                                if(response!=null){
                                  _hallcode.text=response["hall_code"];
                                }else{
                                  _hallcode.text="";
                                }
                                if(_hallcode.text.toString()=="") {
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (mcontext) {
                                      return updateHallCodeDialog(
                                          context, mcontext,forenoonSessionId,"Forenoon (FN)");
                                    },
                                  );
                                }else {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          ISSessionDetailPage(
                                            examId: widget.examId,
                                            notificationName: widget
                                                .notificationName,
                                            dayId: widget.dayId,
                                            examName: widget.examName,
                                            sessionId: forenoonSessionId,
                                            sessionName: "Forenoon (FN)",)));
                                }
                              }else{
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        VDExamScanListPage(
                                          examId: widget.examId,
                                          notificationName: widget
                                              .notificationName,
                                          dayId: widget.dayId,
                                          examName: widget.examName,
                                          sessionId: forenoonSessionId,
                                          sessionName: "Forenoon (FN)",)));
                              }
                            },
                            child: Container(
                                height: MediaQuery.of(context).size.height * 0.1,
                                child: Center(
                                  child: ListTile(
                                    leading: Icon(Icons.wb_twighlight,color: Colors.green,),
                                    title: Text('Forenoon (FN) \n'+(forenoonSessionType=="is"?" Inspection Duty":"Van Duty")),
                                    trailing:Icon(Icons.check,color: Colors.white,),
                                  ),
                                )
                            ),
                          )
                      )),
                  SizedBox(height: 5),
                  Visibility(visible:
                  afternoonSessionId>0?true:false
                      ,child:Card(
                          child:  InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () async{
                              if(afternoonSessionType=="is") {
                                Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                postMeeting["examid"] = widget.examId;
                                postMeeting["dayid"] = widget.dayId;
                                postMeeting["sessionid"]=afternoonSessionId;
                                TNPSCService service=new TNPSCService();
                                Map<String,dynamic>? response;
                                Meta m=await service.processPostURL(Constants.BaseUrlDev+"/show-is-hallcode",postMeeting,Constants.AUTH_TOKEN);
                                if(m?.statusCode==200){
                                  debugPrint(m?.response.toString());
                                  if(m?.response["status"]=="success") {
                                    response = m?.response["data"] ?? {};
                                  }
                                }
                                if(response!=null){
                                  _hallcode.text=response["hall_code"];
                                }else{
                                  _hallcode.text="";
                                }
                                if(_hallcode.text.toString()=="") {
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (mcontext) {
                                      return updateHallCodeDialog(
                                          context, mcontext,afternoonSessionId,"Afternoon (AN)");
                                    },
                                  );
                                }else {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          ISSessionDetailPage(
                                            examId: widget.examId,
                                            notificationName: widget
                                                .notificationName,
                                            dayId: widget.dayId,
                                            examName: widget.examName,
                                            sessionId: afternoonSessionId,
                                            sessionName: "Afternoon (AN)",)));
                                }
                              }else{
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        VDExamScanListPage(
                                          examId: widget.examId,
                                          notificationName: widget
                                              .notificationName,
                                          dayId: widget.dayId,
                                          examName: widget.examName,
                                          sessionId: afternoonSessionId,
                                          sessionName: "Afternoon (AN)",)));
                              }
                            },
                            child: Container(
                                height: MediaQuery.of(context).size.height * 0.1,
                                child: Center(
                                  child: ListTile(
                                    leading: Icon(Icons.wb_sunny,color: Colors.green,),
                                    title: Text('Afternoon (AN)  \n'+(afternoonSessionType=="is"?" Inspection Duty":"Van Duty")),
                                    trailing:Icon(Icons.check,color: Colors.white,),
                                  ),
                                )
                            ),
                          )
                      )),
                ],
              ),
            )
          //],
          //),
          //)
        ));
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> examData= HashMap<String,Meta>();
    Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
    postExamDetail["examid"] = widget.examId;
    postExamDetail["dayid"] = widget.dayId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/is-vd-sessionlist",postExamDetail,Constants.AUTH_TOKEN);
    examData["session"]=m;
    return examData;
  }
  Widget updateHallCodeDialog(BuildContext mcontext,BuildContext buildContext,int sessionId,String sessionName){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Hall Code Update",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextField(
                        controller: _hallcode,
                        decoration: InputDecoration(
                          isDense: true,
                          enabled: true,
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero
                          ),
                          hintText: 'Hall Code',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w400
                          ),
                        )
                    ),

                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["examid"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = sessionId;
                              userData["hall_code"]=_hallcode.text.toString();
                              debugPrint(userData.toString());
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/update-is-hallcode", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          ISSessionDetailPage(
                                            examId: widget.examId,
                                            notificationName: widget
                                                .notificationName,
                                            dayId: widget.dayId,
                                            examName: widget.examName,
                                            sessionId: sessionId,
                                            sessionName: sessionName,)));
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Hallcode Updated Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class ISSessionDetailPage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String sessionName="";
  String notificationName="";
  String examName="";
  int sessionId=0;
  String reasonType="Mobile";
  String answerType="No";
  ISSessionDetailPage({this.examId=0,this.dayId=0,this.sessionName="",this.examName="",this.sessionId=0,this.notificationName=""});
  @override
  _ISSessionDetailPageState createState() => _ISSessionDetailPageState();
}

class _ISSessionDetailPageState extends State<ISSessionDetailPage> {
  Map<String,dynamic> questionData={};
  Map<String,dynamic> totalStaff={};
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _handleTime=new TextEditingController();
  TextEditingController _present=new TextEditingController();
  TextEditingController _absent=new TextEditingController();
  TextEditingController _hallcode=new TextEditingController();
  String totalInvigilators="";
  List<String> handleto=['Mobile','Staff','Officer'];
  List<String> handleToTypes=['Mobile','Staff','Officer'];
  TextEditingController _comments=new TextEditingController();
  List<String> answer=['No','Yes'];
  List<String> answerTypes=['No','Yes'];
  String hallCode="";
  TextEditingController _dispatchedTime=new TextEditingController();

  late Future<HashMap<String,Meta>> _future;
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    HashMap<String,Meta> ed;
    _future.then((value){
      ed=value;
      if(ed!=null) {
        Meta m=ed["questionData"]??new Meta();
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          questionData = m.response;
        }
        Meta m1=ed["totalstaff"]??new Meta();
        if (m1.statusCode == 200) {
          debugPrint(m1.response.toString());
          totalStaff = m1.response;
          if(totalStaff["data"]!=null) {
            if(totalStaff["data"]["total_invigilators"]!=null) {
              _candidate.text = totalStaff["data"]["total_invigilators"].toString();
              setState(() {
                totalInvigilators=totalStaff["data"]["total_invigilators"].toString();
              });
            }else{
              totalInvigilators="0";
              _candidate.text="0";
            }
          }
        }
        Meta m2=ed["hallcode"]??new Meta();
        if (m2.statusCode == 200) {
          debugPrint(m2.response.toString());
          Map<String,dynamic>? response;
          if(m2?.response["status"]=="success") {
            response = m2?.response["data"] ?? {};
            if(response!["hall_code"]!=null){
              setState(() {
                hallCode=response!["hall_code"];
              });
            }
          }
        }
      }

    });
    super.initState();
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> dataSet=new HashMap<String,Meta>();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/exam/material-received/details",postMeeting,Constants.AUTH_TOKEN);
    dataSet["questionData"]=m;
    Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/show-total-invigilators",postMeeting,Constants.AUTH_TOKEN);
    dataSet["totalstaff"]=m1;
    postMeeting["examid"] = widget.examId;
    Meta m2=await service.processPostURL(Constants.BaseUrlDev+"/show-is-hallcode",postMeeting,Constants.AUTH_TOKEN);
    dataSet["hallcode"]=m2;
    return dataSet;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text(widget.sessionName),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ISExamDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,)));
            },
          ),
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: Column(
                // children: [
                //   Container(
                //     height: MediaQuery.of(context).size.height*1.20,
                //     margin: EdgeInsets.all(15),
                //     child: ListView(
                children: <Widget>[
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async{
                          // Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          //     QuestionDistributedPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                          Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          postMeeting["examid"] = widget.examId;
                          postMeeting["dayid"] = widget.dayId;
                          postMeeting["sessionid"]=widget.sessionId;
                          TNPSCService service=new TNPSCService();
                          Map<String,dynamic>? response;
                          Meta m=await service.processPostURL(Constants.BaseUrlDev+"/show-is-hallcode",postMeeting,Constants.AUTH_TOKEN);
                          if(m?.statusCode==200){
                            debugPrint(m?.response.toString());
                            if(m?.response["status"]=="success") {
                              response = m?.response["data"] ?? {};
                            }
                          }
                          if(response!=null){
                            _hallcode.text=response["hall_code"];
                          }else{
                            _hallcode.text="";
                          }
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (mcontext) {
                              return updateHallCodeDialog(context,mcontext);
                            },
                          );
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Update HallCode \n Hall Code:'+hallCode),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ISExamSessionPreliminaryPage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Inspection Checklist'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ISAdditionalCandidatePage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Additional Candidate'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ISExamMalpracticePage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Malpractice'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async{
                          // Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          //     BookletHandlePage(examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId:widget.dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                          Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                          postMeeting["exam_id"] = widget.examId;
                          postMeeting["dayid"] = widget.dayId;
                          postMeeting["sessionid"]=widget.sessionId;
                          TNPSCService service=new TNPSCService();
                          Map<String,dynamic>? response;
                          Meta m=await service.processPostURL(Constants.BaseUrlDev+"/is/candidate-attendance-details",postMeeting,Constants.AUTH_TOKEN);
                          if(m?.statusCode==200){
                            debugPrint(m?.response.toString());
                            if(m?.response["status"]=="success") {
                              response = m?.response ?? {};
                            }
                          }
                          if(response!=null){
                            _present.text=response["present"]!;
                            _absent.text=response["absent"]!;
                          }
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (mcontext) {
                              return bookletHandleDialog(context,mcontext);
                            },
                          );
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,color: Colors.green,),
                                title: Text('Candidate Attendance'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.only(left:10,right:10,top:10),
                    child:
                    Card(
                        child:  InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () async {
                            Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                            postMeeting["exam_id"] = widget.examId;
                            TNPSCService service=new TNPSCService();
                            Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is/time-despatch/details",postMeeting,Constants.AUTH_TOKEN);
                            String resp="";
                            if(m1.statusCode==200){
                              if(m1.response["status"]=="success") {
                                if(m1.response["data"]!=null){
                                  setState(() {
                                    resp = m1.response["data"] ?? "";
                                  });
                                }
                              }
                            }
                            if(resp!=null){
                              _dispatchedTime.text=resp;
                            }else{
                              _dispatchedTime.text="";
                            }
                            showDialog(
                              barrierColor: Colors.black26,
                              context: context,
                              builder: (mcontext) {
                                return dispatchTimeDialog(context,mcontext);
                              },
                            );
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Center(
                                child: ListTile(
                                  leading: Icon(Icons.checklist,color: Colors.green,),
                                  title: Text('Time Of Despatch'),
                                ),
                              )
                          ),
                        )
                    ),
                  ),
                ],
              ),
            )
          //],
          //),
          //)
        ));
  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Total Invigilators",
                        )
                    ),
                  ),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      padding: EdgeInsets.only(top:20),
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      padding: EdgeInsets.only(top:20),
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["total_invigilators"] = _candidate.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/exam/add-total-invigilators", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> sresponse = m.response;
                                if (sresponse["status"] == "success" || sresponse["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["exam_id"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/exam/show-total-invigilators",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     setState(() {
                                  //       totalStaff = m1.response;
                                  //       if(totalStaff["data"]!=null) {
                                  //         if(totalStaff["data"]["total_invigilators"]!=null) {
                                  //           _candidate.text = totalStaff["data"]["total_invigilators"].toString();
                                  //           totalInvigilators=totalStaff["data"]["total_invigilators"].toString();
                                  //         }else{
                                  //           totalInvigilators="0";
                                  //           _candidate.text="0";
                                  //         }
                                  //       }
                                  //     });
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Total Invigilators updated successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget bookletHandleDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Candidates Present",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextField(
                          controller: _present,
                          decoration: InputDecoration(
                              isDense: true,
                              enabled: true,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero
                              ),
                              hintText: 'Present',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w400
                              ),
                          )
                      ),

                  ),
                  // SizedBox(height: 50),
                  // Container(
                  //   margin: EdgeInsets.only(left: 10),
                  //   width:MediaQuery.of(context).size.width*0.70,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(4),
                  //       border: Border.all(color: Colors.lightGreen),
                  //       color: Colors.white
                  //   ),
                  //   child:TextField(
                  //         controller: _absent,
                  //         decoration: InputDecoration(
                  //             isDense: true,
                  //             enabled: false,
                  //             border: const OutlineInputBorder(
                  //                 borderRadius: BorderRadius.zero
                  //             ),
                  //             hintText: 'Absent',
                  //             hintStyle: TextStyle(
                  //                 fontSize: 14,
                  //                 color: Color(0xFF555555),
                  //                 fontWeight: FontWeight.w400
                  //             ),
                  //         )
                  //     ),
                  // ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["present"] = _present.text.toString();
                              debugPrint(userData.toString());
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/is/add-candidate-attendance", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Attendance Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  _selectHandleTime(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _handleTime.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
            _handleTime.text.toString(), DateTimeUtils.DD_MM_YYYY_Format,
            DateTimeUtils.YYYY_MM_DD_Format)
        ),
        firstDate: DateTime.now(),
        lastDate: DateTime
            .now()

    );
    if (selected != null) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),

      );
      String selectedTime = "";
      if (picked != null)
        setState(() {
          selectedTime =
              DateTimeUtils().dateToStringFormat(DateTime(
                  selected.year, selected.month, selected.day, picked.hour,
                  picked.minute), DateTimeUtils.DD_MM_YYYY_Format_Time);
        });
      _handleTime.text = selectedTime;
    }
  }
  _selectDispatchedTime(BuildContext context) async{
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

    );
    if (picked != null)
      setState(() {
        _dispatchedTime.text =
            DateTimeUtils().dateToStringFormat(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day, picked.hour,
                picked.minute), DateTimeUtils.HH_MM_A_Format_Time);
      });
  }
  Widget dispatchTimeDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Time Of Despatch",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:InkWell(
                      onTap: (){
                        _selectDispatchedTime(context);
                      },
                      child:TextField(
                          controller: _dispatchedTime,
                          decoration: InputDecoration(
                              isDense: true,
                              enabled: false,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero
                              ),
                              hintText: 'Dispatch Time',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w400
                              ),
                              suffixIcon: Icon(Icons.date_range_outlined,color: Colors.blue[800],)
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["time"]=_dispatchedTime.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/is/add-time-despatch", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Dispatched Time Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
  Widget updateHallCodeDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Hall Code Update",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextField(
                        controller: _hallcode,
                        decoration: InputDecoration(
                          isDense: true,
                          enabled: true,
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero
                          ),
                          hintText: 'Hall Code',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w400
                          ),
                        )
                    ),

                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["examid"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["hall_code"]=_hallcode.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/update-is-hallcode", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Hallcode Updated Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }

}

class ISAdditionalCandidatePage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String mRadioValues="no";
  ISAdditionalCandidatePage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _ISAdditionalCandidatePageState createState() => _ISAdditionalCandidatePageState();
}

class _ISAdditionalCandidatePageState extends State<ISAdditionalCandidatePage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _name=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
              if(response.length>0){
                widget.mRadioValues="yes";
              }
            }
          }
          return Scaffold(floatingActionButton:
            Visibility(visible:true,
              child:FloatingActionButton(
            onPressed: () {
              if(widget.mRadioValues=="yes") {
                showDialog(
                  barrierColor: Colors.black26,
                  context: context,
                  builder: (mcontext) {
                    return confirmDialog(context, mcontext);
                  },
                );
              }else{
                showDialog(
                  barrierColor: Colors.black26,
                  context: context,
                  builder: (mcontext) {
                    return AlertDialog(
                        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

                        ),
                        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
                        elevation: 0,
                        titlePadding: const EdgeInsets.all(0),
                        backgroundColor: Colors.white,
                        content: Container(
                            height: MediaQuery.of(context).size.height * 0.30,
                            width: double.infinity,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width:MediaQuery.of(context).size.width*0.70,
                                    child:Text("Please select yes for adding additional candidates"
                                    ),
                                  ),
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
                                              Navigator.pop(mcontext);
                                            }
                                            ,
                                            child: Text("Ok",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                                          )
                                      )
                                  ),
                                    ])),
                                ],
                              ),
                            )
                        )
                    );
                  },
                );
              }
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          )),

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Additional Candidate"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ISSessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10,top:20),
                                width :  MediaQuery.of(context).size.width*0.97,
                                child:Text("Additional candidates allowed for the exam?",textAlign:TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                width : MediaQuery.of(context).size.width*0.97,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(8),
                                //     border: Border.all(color: Colors.grey),
                                //     color: Colors.white
                                // ),
                                child:StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Row(children:[Expanded(child:Theme(
                                          data: Theme.of(context).copyWith(
                                              unselectedWidgetColor: Colors.green[900],
                                              disabledColor: Colors.green[900],
                                              toggleableActiveColor:Colors.green[900]
                                          ),child:RadioListTile<String>(
                                        title: const Text('Yes'),
                                        value: "yes",
                                        groupValue: widget.mRadioValues,
                                        onChanged: (String? value) {
                                          // widget.mRadioValues = value!;
                                          setState(() {
                                            widget.mRadioValues=value!;
                                          });
                                          debugPrint("sfsdffdsfsdffdsfds"+widget.mRadioValues);
                                        },
                                      ))),
                                        Expanded(child:Theme(
                                            data: Theme.of(context).copyWith(
                                                unselectedWidgetColor: Colors.green[900],
                                                disabledColor: Colors.green[900],
                                                toggleableActiveColor:Colors.green[900]
                                            ),child:RadioListTile<String>(
                                          title: const Text('No'),
                                          value: "no",
                                          groupValue: widget.mRadioValues,
                                          onChanged: (String? value) {
                                            // widget.mRadioValues = value!;
                                            setState(() {
                                              widget.mRadioValues=value!;
                                            });
                                          },
                                        ))),
                                        ]);}
                                )),
                            Row(children:[getAdditionalCandidateList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["examid"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/is/additional-candidate/list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getAdditionalCandidateList(){
    if(response!=null && response.length>0){
        widget.mRadioValues="yes";
    }
    return Expanded(child: ListView.builder(
        key: PageStorageKey("addlcand_PageStorageKey"),
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
                          title: Text("Reg No: "+ response[j]["reg_no"]+" \n"+"Name: "+ response[j]["name"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["addcand_id"] = response[j]["addcand_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/is/additional-candidate/delete", userData,
                                Constants.AUTH_TOKEN);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["examid"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is/additional-candidate/list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    _name.text="";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Furnish the candidate's details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Reg. No",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_name ,
                        enabled: true,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Name",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["examid"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["reg_no"] = _candidate.text.toString();
                              userData["name"] = _name.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/is/add-additional-candidate", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "success" || response["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["examid"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is/additional-candidate/delete",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     if(m1.response["data"]!=null){
                                  //       setState(() {
                                  //         response = m1.response["data"] ?? [];
                                  //       });
                                  //     }
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Additional Candidate Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            }, child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class ISExamMalpracticePage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String sessionName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String mRadioValues="no";
  ISExamMalpracticePage({this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _ISExamMalpracticePageState createState() => _ISExamMalpracticePageState();
}

class _ISExamMalpracticePageState extends State<ISExamMalpracticePage> {
  List<dynamic> response=[];
  TextEditingController _candidate=new TextEditingController();
  TextEditingController _comments=new TextEditingController();
  TextEditingController _hallno=new TextEditingController();
  TextEditingController _regno=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
              if(response!=null && response.length>0){
                widget.mRadioValues="yes";
              }
            }
          }
          return Scaffold(floatingActionButton: snapshot.hasData?FloatingActionButton(
            onPressed: () {
              if(widget.mRadioValues=="yes") {
                showDialog(
                  barrierColor: Colors.black26,
                  context: context,
                  builder: (mcontext) {
                    return confirmDialog(context,mcontext);
                  },
                );
              }else{
                showDialog(
                  barrierColor: Colors.black26,
                  context: context,
                  builder: (mcontext) {
                    return AlertDialog(
                        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Add New",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

                        ),
                        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
                        elevation: 0,
                        titlePadding: const EdgeInsets.all(0),
                        backgroundColor: Colors.white,
                        content: Container(
                            height: MediaQuery.of(context).size.height * 0.30,
                            width: double.infinity,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width:MediaQuery.of(context).size.width*0.70,
                                    child:Text("Please select yes for adding malpractice candidates"
                                    ),
                                  ),
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
                                              Navigator.pop(mcontext);
                                            }
                                            ,
                                            child: Text("Ok",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                                          )
                                      )
                                  ),
                                  ])),
                                ],
                              ),
                            )
                        )
                    );
                  },
                );
              }
            },
            child: Icon(Icons.add, color: Colors.white, size: 29,),
            backgroundColor: Colors.green[900],
            tooltip: 'Capture QR',
            elevation: 5,
            splashColor: Colors.green[900],
          ):null,

              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text("Malpractice"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ISSessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));                  },
                ),
              ),
              body:SafeArea(
                  child:SingleChildScrollView(
                      child:
                      Center(
                        child: snapshot.hasData?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10,top:20),
                                width :  MediaQuery.of(context).size.width*0.97,
                                child:Text("Any malpractice incidents during the exam?",textAlign:TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                width : MediaQuery.of(context).size.width*0.97,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(8),
                                //     border: Border.all(color: Colors.grey),
                                //     color: Colors.white
                                // ),
                                child:StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Row(children:[Expanded(child:Theme(
                                          data: Theme.of(context).copyWith(
                                              unselectedWidgetColor: Colors.green[900],
                                              disabledColor: Colors.green[900],
                                              toggleableActiveColor:Colors.green[900]
                                          ),child:RadioListTile<String>(
                                        title: const Text('Yes'),
                                        value: "yes",
                                        groupValue: widget.mRadioValues,
                                        onChanged: (String? value) {
                                          // widget.mRadioValues = value!;
                                          setState(() {
                                            widget.mRadioValues=value!;
                                          });
                                          debugPrint("sfsdffdsfsdffdsfds"+widget.mRadioValues);
                                        },
                                      ))),
                                        Expanded(child:Theme(
                                            data: Theme.of(context).copyWith(
                                                unselectedWidgetColor: Colors.green[900],
                                                disabledColor: Colors.green[900],
                                                toggleableActiveColor:Colors.green[900]
                                            ),child:RadioListTile<String>(
                                          title: const Text('No'),
                                          value: "no",
                                          groupValue: widget.mRadioValues,
                                          onChanged: (String? value) {
                                            // widget.mRadioValues = value!;
                                            setState(() {
                                              widget.mRadioValues=value!;
                                            });
                                          },
                                        ))),
                                      ]);}
                                )),
                            Row(children:[getMalpractiveList()])
                          ],
                        ):CircularProgressIndicator(),
                      )
                  )));

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["examid"] = widget.examId;
    postMeeting["dayid"] = widget.dayId;
    postMeeting["sessionid"]=widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/is/malpractice/list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getMalpractiveList(){
    if(response!=null && response.length>0){
      widget.mRadioValues="yes";
    }
    return Expanded(child: ListView.builder(
        key: PageStorageKey("MalScan_PageStorageKey"),
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
                          title: Text("Reg No: "+ response[j]["candidate"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing:  IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["mal_id"] = response[j]["mal_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/is/malpractice/delete", userData,
                                Constants.AUTH_TOKEN);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["examid"] = widget.examId;
                              // postMeeting["dayid"] = widget.dayId;
                              // postMeeting["sessionid"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is/malpractice/list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget confirmDialog(BuildContext mcontext,BuildContext buildContext){
    _candidate.text="";
    _comments.text="";
    _regno.text="";
    _hallno.text="";
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Furnish the candidate's details",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.60,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_regno ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Reg. No",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_candidate ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Name",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_hallno ,
                        enabled: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Hall No",
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextFormField(
                        controller:_comments ,
                        enabled: true,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          labelText: "Remarks",
                        )
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["examid"] = widget.examId;
                              userData["dayid"] = widget.dayId;
                              userData["sessionid"] = widget.sessionId;
                              userData["reg_no"] = _regno.text.toString();
                              userData["remarks"] = _comments.text.toString();
                              userData["hall_no"] = _hallno.text.toString();
                              userData["name"] = _candidate.text.toString();
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/is/add-malpractice", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> resp = m.response;
                                if (resp["status"] == "success" || resp["status"] == "ok") {
                                  Navigator.pop(buildContext);
                                  // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                                  // postMeeting["examid"] = widget.examId;
                                  // postMeeting["dayid"] = widget.dayId;
                                  // postMeeting["sessionid"]=widget.sessionId;
                                  // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is/malpractice/list",postMeeting,Constants.AUTH_TOKEN);
                                  // if(m1.statusCode==200){
                                  //   if(m1.response["status"]=="success") {
                                  //     if(m1.response["data"]!=null){
                                  //       setState(() {
                                  //         response = m1.response["data"] ?? [];
                                  //       });
                                  //     }
                                  //   }
                                  // }
                                  _future=callAsyncMethod();
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Malpractice Saved Successfully"),
                                  ));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(mcontext).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403 || m.statusCode == 422 || m.statusCode == 400) {
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
                            child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}

class VDExamScanListPage extends StatefulWidget {
  int type=1;
  String returnedQrCode="";
  int examId=0;
  String notificationName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String sessionName="";
  VDExamScanListPage({this.type=1,this.returnedQrCode="",this.examId=0,this.notificationName="",this.examName="Exam Name",this.dayId=0,this.sessionId=0,this.sessionName=""});
  @override
  _VDExamScanListPageState createState() => _VDExamScanListPageState();
}

class _VDExamScanListPageState extends State<VDExamScanListPage> {
  List<dynamic> response=[];
  TextEditingController _hallcode=new TextEditingController();
  TextEditingController _centercode=new TextEditingController();
  late Future<Meta> _future;
  bool loaded=false;

  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meta>(
        future: _future,
        builder: (context, AsyncSnapshot<Meta> snapshot) {
          Meta? m=snapshot.data;
          if(m?.statusCode==200){
            debugPrint(m?.response.toString());
            if(m?.response["status"]=="success") {
              response = m?.response["data"] ?? [];
            }
          }
          return Scaffold(
              floatingActionButton: snapshot.hasData?FloatingActionButton(
                onPressed: () {
                  showDialog(
                    barrierColor: Colors.black26,
                    context: context,
                    builder: (mcontext) {
                      return updateHallCodeDialog(context,mcontext);
                    },
                  );
                },
                child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 29,),
                backgroundColor: Colors.green[900],
                tooltip: 'Capture QR',
                elevation: 5,
                splashColor: Colors.green[900],
              ):null,
              appBar: AppBar(
                backgroundColor: Colors.green[900],
                title: Text(widget.sessionName),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ISExamDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName)));
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

        }
    );

  }
  Future<Meta> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    Map<String, dynamic> postMeeting = new Map<String, dynamic>();
    postMeeting["exam_id"] = widget.examId;
    postMeeting["day_id"] = widget.dayId;
    postMeeting["session_id"] = widget.sessionId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/vd-info/list",postMeeting,Constants.AUTH_TOKEN);
    return m;
  }
  Widget getScanList(){
    return Expanded(child: ListView.builder(
        key: PageStorageKey("ExamScan_PageStorageKey"),
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
                          title: Text("Hall Code:"+response[j]["hall_code"]+"\nQR:"+response[j]["qr_details"],style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),),
                          trailing: IconButton(icon:Icon(Constants.delete,color: Colors.red,),onPressed:()async{
                            Map<String, dynamic> userData = new Map<String, dynamic>();
                            userData["exam_id"] = widget.examId;
                            userData["day_id"]=widget.dayId;
                            userData["session_id"]=widget.sessionId;
                            userData["data_id"] = response[j]["data_id"];
                            TNPSCService service = new TNPSCService();
                            Meta m = await service.processPostURL(
                                Constants.BaseUrlDev + "/vd-info/delete", userData,
                                Constants.AUTH_TOKEN);
                            if (m.statusCode == 200) {
                              // Map<String, dynamic> postMeeting = new Map<String, dynamic>();
                              // postMeeting["exam_id"] = widget.examId;
                              // postMeeting["day_id"]=widget.dayId;
                              // postMeeting["session_id"]=widget.sessionId;
                              // Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/vd-info/list",postMeeting,Constants.AUTH_TOKEN);
                              // if(m1.statusCode==200){
                              //   if(m1.response["status"]=="success") {
                              //     setState(() {
                              //       response = m1.response["data"] ?? [];
                              //     });
                              //   }
                              // }
                              _future=callAsyncMethod();
                              setState(() {

                              });
                            }
                          },),
                        )
                    )),
              )
          );}));

  }
  Widget updateHallCodeDialog(BuildContext mcontext,BuildContext buildContext){
    return AlertDialog(
        title: Container(padding:EdgeInsets.all(10),color:Colors.green[900], child:Text("Hall Code",style: TextStyle(color:Colors.white,fontSize: 20,backgroundColor: Colors.green[900])),

        ),
        insetPadding: EdgeInsets.only(left:15.0,right:15.0),
        elevation: 0,
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextField(
                        controller: _centercode,
                        decoration: InputDecoration(
                          isDense: true,
                          enabled: true,
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero
                          ),
                          hintText: 'Center Code',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w400
                          ),
                        )
                    ),

                  ),
                  SizedBox(height: 50),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width:MediaQuery.of(context).size.width*0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.lightGreen),
                        color: Colors.white
                    ),
                    child:TextField(
                        controller: _hallcode,
                        decoration: InputDecoration(
                          isDense: true,
                          enabled: true,
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero
                          ),
                          hintText: 'Hall Code',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w400
                          ),
                        )
                    ),

                  ),
                  SizedBox(height: 50),
                  Center(child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.black12,
                            onPressed: () async{
                              Navigator.pop(buildContext);
                            }
                            ,
                            child: Text("Cancel",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  ),Container(
                      child:ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900],
                            onPressed: ()async{
                              Navigator.pop(buildContext);
                              Navigator.pop(context);
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) =>
                                      QrPage(value: widget.type,examId: widget.examId,type: "add-vd-info",notificationName: widget.notificationName,examName:widget.examName,dayId: widget.dayId,sessionId: widget.sessionId,sessionName:widget.sessionName,hallcode:_hallcode.text.toString(),bundleLabel:_centercode.text.toString())));

                            },
                            child: Text("Ok",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )])),
                ],
              ),
            )
        )
    );
  }
}
class ISExamSessionPreliminaryPage extends StatefulWidget {
  int examId=0;
  int dayId=0;
  String notificationName="";
  String examName="";
  String sessionName="";
  int sessionId=0;
  List<dynamic> questions=[];
  List<dynamic> answer=[];
  Map<int,Map<String,String>> mTextValues=new Map<int,Map<String,String>>();
  Map<int, String> mRadioValues =
  new Map<int, String>();

  Map<int,Map<String,TextEditingController>> _textControllers=new Map<int,Map<String,TextEditingController>>();
  Map<int, String> _radioValues =
  new Map<int, String>();
  ISExamSessionPreliminaryPage({this.examId=0,this.dayId=0,this.notificationName="",this.examName="",this.sessionName="",this.sessionId=0});
  @override
  _ISExamSessionPreliminaryPageState createState() => _ISExamSessionPreliminaryPageState();
  void createControllers(List<dynamic> questions){
    for(var question in questions){
      _radioValues[question["qsn_id"]]="no";
      if(question["answer_format"]!=null) {
        question["answer_format"].forEach((k,v) {
          if(k!="qsn_id" && question["answer_format"][k]!="yes:no") {
            if (_textControllers[question["qsn_id"]] == null) {
              _textControllers[question["qsn_id"]] = new Map<
                  String,
                  TextEditingController>();
            }
            _textControllers[question["qsn_id"]]![k] =
            new TextEditingController();
          }
        });
      }
    }
  }
}

class _ISExamSessionPreliminaryPageState extends State<ISExamSessionPreliminaryPage> {
  Map<String,dynamic> prelimData={};
  Map<String,dynamic> ansData={};
  late Future<HashMap<String,Meta>> _future;
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    HashMap<String, Meta> ed = new HashMap<String, Meta>();
    _future.then((value) {
      ed = value;
      if (ed["question"] != null) {
        Meta m = ed["question"] ?? new Meta();
        Meta ans = ed["answer"] ?? new Meta();
        if (ans != null && ans.statusCode == 200) {
          ansData = ans.response;
        }
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          debugPrint(ans.response.toString());
          prelimData = m.response;
          setState(() {
            if (prelimData["data"] != null && prelimData["data"].length > 0) {
              widget.questions = prelimData["data"];
              widget.createControllers(widget.questions);
            }
            if (ansData["data"] != null && ansData["data"].length > 0) {
              widget.answer = ansData["data"];
            }
          });
        }
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text("Checklist"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ISSessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId: widget.sessionId,sessionName: widget.sessionName,)));            },
          ),
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: widget.questions!=null && widget.questions.length>0?Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children:[  getQuestionList()]),
                  Padding(padding:EdgeInsets.only(top:10),child:Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ButtonTheme(
                          height: MediaQuery.of(context).size.height * 0.06,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                            color: Colors.green[900] ,
                            onPressed: ()async{
                              Map<String, dynamic> userData = new Map<String, dynamic>();
                              userData["exam_id"] = widget.examId;
                              userData["dayid"]=widget.dayId;
                              userData["sessionid"]=widget.sessionId;
                              userData["checklist"]=[];
                              for(var question in widget.questions){
                                Map<String,dynamic> ans={};
                                ans["qsn_id"]=question["qsn_id"];
                                if(question["answer_format"]!=null) {
                                  question["answer_format"].forEach((k,v) {
                                    var key=k;
                                    if(k!="qsn_id") {
                                      if(k=="ans" && question["answer_format"]["ans"]=="yes:no") {
                                        try {
                                          if (widget
                                              ._radioValues[question["qsn_id"]] !=
                                              "")
                                            ans["ans"] = widget
                                                ._radioValues[question["qsn_id"]]
                                                .toString();
                                        } catch (e) {
                                          ans["ans"] = "no";
                                          // do nothing
                                        }
                                      }else{
                                        ans[key] = widget
                                            ._textControllers[question["qsn_id"]]![k]!
                                            .text.toString();
                                      }
                                    }
                                  });
                                }
                                userData["checklist"].add(ans);
                              }
                              debugPrint(userData.toString());
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/is-add-checklist", userData,
                                  Constants.AUTH_TOKEN);
                              if (m.statusCode == 200) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ISSessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
                              }
                            },
                            child: Text("Submit",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                          )
                      )
                  )),

                ],
              ):CircularProgressIndicator(),
            )
        ));
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    TNPSCService service=new TNPSCService();
    HashMap<String,Meta> prelimData= HashMap<String,Meta>();
    Map<String, dynamic> postExamDetail = new Map<String, dynamic>();
    postExamDetail["exam_id"] = widget.examId;
    Meta m=await service.processPostURL(Constants.BaseUrlDev+"/is-list-checklist",postExamDetail,Constants.AUTH_TOKEN);
    prelimData["answer"]=m;
    postExamDetail["examid"] = widget.examId;
    Meta m1=await service.processPostURL(Constants.BaseUrlDev+"/is-checklist-questions",postExamDetail,Constants.AUTH_TOKEN);
    prelimData["question"]=m1;
    return prelimData;
  }
  Widget getQuestionList(){
    for(var ans in widget.answer){
      if(widget._radioValues[ans["qsn_id"]]!=null) {
        widget._radioValues[ans["qsn_id"]] = ans["ans"].toString();
        // widget.mRadioValues[int.parse(ans["qsn_id"])] = ans["ans"].toString();
      }
      debugPrint(widget.questions.where((qsn) => qsn["qsn_id"] == ans["qsn_id"]).toString());
      List<dynamic> q=widget.questions.where((qsn) => qsn["qsn_id"] == ans["qsn_id"]).toList();

      if(q!=null && q.length>0) {
        Map<String, dynamic> question=q[0];
        if (question != null) {
          if (question["answer_format"] != null) {
            question["answer_format"].forEach((k, v) {
              if (k != "qsn_id" && question["answer_format"][k] != "yes:no") {
                // if(question["answer_format"]!=null && question["answer_format"]["ans"]!=null
                //     && question["answer_format"]["ans"]!="yes:no"
                //     && question["answer_format"]["ans"].length>8 && ans[k]!=""){
                //   widget._textControllers[question["qsn_id"]]![k]!.text =DateTimeUtils().dateToServerToDateFormat(
                //       ans[k], DateTimeUtils.YYYY_MM_DD_Format,
                //       DateTimeUtils.DD_MM_YYYY_Format);
                //
                // }else {
                  widget._textControllers[question["qsn_id"]]![k]!.text =
                  ans[k];
                // }
              }
            });
          }
        }
      }
      // if(ans["data"]!=null) {
      //   ans["data"].forEach((k,v) {
      //     var key=k;
      //     if(k=="ins_name" || k=="ins_desig" || k=="ins_dept"){
      //       key=k.replaceAll("ins_","");
      //     }
      //     widget._textControllers[int.parse(ans["qsn_id"])]![key]!.text=ans["data"][k];
      //     // if(widget.mTextValues[int.parse(ans["qsn_id"])]==null){
      //     //   widget.mTextValues[int.parse(ans["qsn_id"])]=new Map<String,String>();
      //     // }
      //     // widget.mTextValues[int.parse(ans["qsn_id"])]![key]=widget._textControllers[int.parse(ans["qsn_id"])]![key]!.text.toString();
      //   });
      // }
    }
    return Expanded(child:ListView.builder(
        key: PageStorageKey("ISExamSessionQtns_PageStorageKey"),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.questions.length,
        itemBuilder: (context, j) {
          if(widget.mRadioValues[widget.questions[j]["qsn_id"]]!=null) {
            widget._radioValues[widget.questions[j]["qsn_id"]] =
            widget.mRadioValues[widget.questions[j]["qsn_id"]]!;
          }else{
            widget.mRadioValues[widget.questions[j]["qsn_id"]]=widget._radioValues[widget.questions[j]["qsn_id"]].toString();
          }
          if(widget.questions[j]["answer_format"]!=null) {
            widget.questions[j]["answer_format"].forEach((k,v) {
            if (k != "qsn_id" && widget.questions[j]["answer_format"][k] != "yes:no") {
                var key = k;
                // if(k=="name" || k=="desig" || k=="dept"){
                //   key="ins_"+k;
                // }
                if (widget.mTextValues[widget.questions[j]["qsn_id"]] != null &&
                    widget.mTextValues[widget.questions[j]["qsn_id"]]![key] !=
                        null) {
                  widget._textControllers[widget.questions[j]["qsn_id"]]![key]!
                      .text =
                  widget.mTextValues[widget.questions[j]["qsn_id"]]![key]!;
                } else {
                  if (widget.mTextValues[widget.questions[j]["qsn_id"]] == null) {
                    widget.mTextValues[widget.questions[j]["qsn_id"]] =
                    new Map<String, String>();
                  }
                  widget.mTextValues[widget.questions[j]["qsn_id"]]![key]
                  = widget._textControllers[widget.questions[j]["qsn_id"]]![key]!
                      .text.toString();
                }
                widget._textControllers[widget.questions[j]["qsn_id"]]![key]!
                    .selection = TextSelection.fromPosition(TextPosition(
                    offset: widget._textControllers[widget
                        .questions[j]["qsn_id"]]![key]!.text.length));
                }
            });

          }
          // debugPrint(svg);
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.only(left:10,right:10,top:10),
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            width :  MediaQuery.of(context).size.width*0.97,
                            child:Text((j+1).toString()+"."+widget.questions[j]["question"],textAlign:TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
                        widget.questions[j]["answer_format"]!=null && widget.questions[j]["answer_format"]["ans"]!=null && widget.questions[j]["answer_format"]["ans"]=="yes:no"?
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 50,
                            width : MediaQuery.of(context).size.width*(widget.questions[j]["answer_format"]["ans"].contains(":NA")?0.97:0.97),
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(8),
                            //     border: Border.all(color: Colors.grey),
                            //     color: Colors.white
                            // ),
                            child:StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return Row(children:[Expanded(child:Theme(
                                      data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Colors.green[900],
                                          disabledColor: Colors.green[900],
                                          toggleableActiveColor:Colors.green[900]
                                      ),child:RadioListTile<String>(
                                    title: const Text('Yes'),
                                    value: "yes",
                                    groupValue: widget._radioValues[widget.questions[j]["qsn_id"]],
                                    onChanged: (String? value) {
                                      widget.mRadioValues[widget.questions[j]["qsn_id"]] = value!;
                                      setState(() {
                                        widget._radioValues[widget.questions[j]["qsn_id"]]=value!;
                                      });
                                    },
                                  ))),
                                    Expanded(child:Theme(
                                        data: Theme.of(context).copyWith(
                                            unselectedWidgetColor: Colors.green[900],
                                            disabledColor: Colors.green[900],
                                            toggleableActiveColor:Colors.green[900]
                                        ),child:RadioListTile<String>(
                                      title: const Text('No'),
                                      value: "no",
                                      groupValue: widget._radioValues[widget.questions[j]["qsn_id"]],
                                      onChanged: (String? value) {
                                        widget.mRadioValues[widget.questions[j]["qsn_id"]] = value!;
                                        setState(() {
                                          widget._radioValues[widget.questions[j]["qsn_id"]]=value!;
                                        });
                                      },
                                    ))),Visibility(visible:widget.questions[j]["answer_format"]["ans"].contains(":NA")?true:false,child:Expanded(child:Theme(
                                        data: Theme.of(context).copyWith(
                                            unselectedWidgetColor: Colors.green[900],
                                            disabledColor: Colors.green[900],
                                            toggleableActiveColor:Colors.green[900]
                                        ),child:RadioListTile<String>(
                                      title: const Text('NA'),
                                      value: "NA",
                                      groupValue: widget._radioValues[widget.questions[j]["qsn_id"]],
                                      onChanged: (String? value) {
                                        widget.mRadioValues[widget.questions[j]["qsn_id"]] = value!;
                                        setState(() {
                                          widget._radioValues[widget.questions[j]["qsn_id"]]=value!;
                                        });
                                      },
                                    ))))]);}
                            )):Visibility(visible:false,child: Text("None")),
                        widget.questions[j]["answer_format"]!=null && widget.questions[j]["answer_format"]["ans"]!=null
                            && widget.questions[j]["answer_format"]["ans"]!="yes:no"
                            && widget.questions[j]["answer_format"]["ans"].length>8?
                        Container(
                          padding: EdgeInsets.only(left:10,right:10,top:10),
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Container(
                                    margin: EdgeInsets.only(left: 10,top:10),
                                    height: 50,
                                    width :  MediaQuery.of(context).size.width*0.20,
                                    child:Text("Date",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 50,
                                    width : MediaQuery.of(context).size.width*0.60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white
                                    ),child:InkWell(
                                  onTap: (){
                                    _selectCollectorMeetingDate(context,widget._textControllers[widget.questions[j]["qsn_id"]]!["ans"],widget.questions[j]["qsn_id"]);
                                  },
                                  child:TextField(
                                      onChanged: (String? value) {
                                        widget.mTextValues[widget.questions[j]["qsn_id"]]!["ans"]=value!;
                                      },
                                      controller: widget._textControllers[widget.questions[j]["qsn_id"]]!["ans"],
                                      decoration: InputDecoration(
                                          isDense: true,
                                          enabled: false,
                                          border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.zero
                                          ),
                                          hintText: 'Meeting Date',
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w400
                                          ),
                                          suffixIcon: Icon(Icons.date_range_outlined,color: Colors.blue[800],)
                                      )
                                  ),
                                )
                                // TextFormField(
                                //   controller:widget._textControllers[widget.questions[j]["qsn_id"]]!["name"] ,
                                //   enabled: true,
                                //   keyboardType: TextInputType.text,
                                //   onChanged: (String? value) {
                                //     widget.mTextValues[widget.questions[j]["qsn_id"]]!["name"]=value!;
                                //     debugPrint(value);
                                //     // setState(() {
                                //     //   _textControllers[questions[j]["qsn_id"]]!["name"]!.text = value!;
                                //     // });
                                //   },
                                //   decoration: InputDecoration(
                                //     alignLabelWithHint: false,
                                //     labelText: "",
                                //   ),
                                // )
                                //
                                )]),

                        ):Visibility(visible:false,child: Text("None")),
                        widget.questions[j]["answer_format"]!=null && widget.questions[j]["answer_format"]["ans"]!=null
                            && widget.questions[j]["answer_format"]["ans"]!="yes:no"
                            && widget.questions[j]["answer_format"]["ans"].length<=8?
                        Container(
                          padding: EdgeInsets.only(left:10,right:10,top:10),
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Container(
                                    margin: EdgeInsets.only(left: 10,top:10),
                                    height: 50,
                                    width :  MediaQuery.of(context).size.width*0.20,
                                    child:Text("Time",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 50,
                                    width : MediaQuery.of(context).size.width*0.60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white
                                    ),child:InkWell(
                                  onTap: (){
                                    _selectDispatchedTime(context,widget._textControllers[widget.questions[j]["qsn_id"]]!["ans"],widget.questions[j]["qsn_id"]);
                                  },
                                  child:TextField(
                                      onChanged: (String? value) {
                                        widget.mTextValues[widget.questions[j]["qsn_id"]]!["ans"]=value!;
                                      },
                                      controller: widget._textControllers[widget.questions[j]["qsn_id"]]!["ans"],
                                      decoration: InputDecoration(
                                          isDense: true,
                                          enabled: false,
                                          border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.zero
                                          ),
                                          hintText: 'Despatch Time',
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w400
                                          ),
                                          suffixIcon: Icon(Icons.date_range_outlined,color: Colors.blue[800],)
                                      )
                                  ),
                                )
                                  // TextFormField(
                                  //   controller:widget._textControllers[widget.questions[j]["qsn_id"]]!["name"] ,
                                  //   enabled: true,
                                  //   keyboardType: TextInputType.text,
                                  //   onChanged: (String? value) {
                                  //     widget.mTextValues[widget.questions[j]["qsn_id"]]!["name"]=value!;
                                  //     debugPrint(value);
                                  //     // setState(() {
                                  //     //   _textControllers[questions[j]["qsn_id"]]!["name"]!.text = value!;
                                  //     // });
                                  //   },
                                  //   decoration: InputDecoration(
                                  //     alignLabelWithHint: false,
                                  //     labelText: "",
                                  //   ),
                                  // )
                                  //
                                )]),

                        ):Visibility(visible:false,child: Text("None")),
                        widget.questions[j]["answer_format"]!=null && widget.questions[j]["answer_format"]["remarks"]!=null?
                        Container(
                          padding: EdgeInsets.only(left:10,right:10,top:10),
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Container(
                                    margin: EdgeInsets.only(left: 10,top:10),
                                    height: 80,
                                    width :  MediaQuery.of(context).size.width*0.20,
                                    child:Text("Remarks",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 80,
                                    width : MediaQuery.of(context).size.width*0.60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white
                                    ),child:TextFormField(
                                  controller:widget._textControllers[widget.questions[j]["qsn_id"]]!["remarks"] ,
                                  enabled: true,
                                  maxLines: 4,
                                  keyboardType: TextInputType.text,
                                  onChanged: (String? value) {
                                    widget.mTextValues[widget.questions[j]["qsn_id"]]!["remarks"]=value!;
                                    debugPrint(value);
                                    // setState(() {
                                    //   _textControllers[questions[j]["qsn_id"]]!["name"]!.text = value!;
                                    // });
                                  },
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    alignLabelWithHint: false,
                                    labelText: "",
                                  ),
                                ))]),

                        ):Visibility(visible:false,child: Text("None")),
                      ]),

                );});
        }));

  }
  _selectCollectorMeetingDate(BuildContext context,TextEditingController? controller,int qsnId) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: controller?.text.toString() == ""
          ? DateTime.now()
          : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
          controller!.text!.toString(), DateTimeUtils.DD_MM_YYYY_Format,
          DateTimeUtils.YYYY_MM_DD_Format)
      ),
      firstDate: DateTime.now().add(Duration(days: -365)), lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (selected != null) {
      controller?.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      widget.mTextValues[qsnId]!["ans"]=controller!.text!.toString();
    }
  }
  _selectDispatchedTime(BuildContext context,TextEditingController? controller,int qsnId) async{
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

    );
    if (picked != null)
      debugPrint("dsffffffffffffffffff"+picked.toString());
      setState(() {
        controller?.text =
            DateTimeUtils().dateToStringFormat(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day, picked!.hour,
                picked!.minute), DateTimeUtils.HH_MM_A_Format_Time);
        widget.mTextValues[qsnId]!["ans"]=controller!.text!.toString();
      });
  }
}

