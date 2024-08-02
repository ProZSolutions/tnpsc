import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tnpsc/core/constant.dart';
import 'package:tnpsc/core/meta.dart';
import 'package:tnpsc/core/tnpsc_Core.dart';
import 'package:tnpsc/qr/qrPage.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  Map<String,dynamic> meetingData={};
  Map<String,dynamic> bundleData={};
  String questionBoxQr="";
  String answersheetQr="";
  String bundleA1="";
  String bundleA2="";
  String bundleA="";
  String bundleB1="";
  String bundleB2="";
  String bundleB="";
  String bundleI="";

  late Future<HashMap<String,Meta>> _future;
  @override
  void initState() {
    // TODO: implement initState
    _future = callAsyncMethod();
    HashMap<String,Meta> ed=new HashMap<String,Meta>();
    _future.then((value){
      ed=value;
      if(ed["preliminary"]!=null) {
        Meta m=ed["preliminary"]??new Meta();
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          meetingData = m.response;
        }
        setState(() {
          if (meetingData != null && meetingData["questionpaper_qr"] != null) {
            questionBoxQr = meetingData["questionpaper_qr"];
          }
          if (meetingData != null && meetingData["present"] != null) {
            answersheetQr = meetingData["answersheet_qr"];
          }
        });
      }
      if(ed["closing"]!=null) {
        Meta m=ed["closing"]??new Meta();
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          bundleData = m.response;
        }
        setState(() {
          if (bundleData != null && bundleData["bundle_a1"] != null) {
            bundleA1 = bundleData["bundle_a1"];
          }
          if (bundleData != null && bundleData["bundle_a2"] != null) {
            bundleA2 = bundleData["bundle_a2"];
          }
          if (bundleData != null && bundleData["bundle_a"] != null) {
            bundleA = bundleData["bundle_a"];
          }
          if (bundleData != null && bundleData["bundle_b1"] != null) {
            bundleB1 = bundleData["bundle_b1"];
          }
          if (bundleData != null && bundleData["bundle_b2"] != null) {
            bundleB2 = bundleData["bundle_b2"];
          }
          if (bundleData != null && bundleData["bundle_b"] != null) {
            bundleB = bundleData["bundle_b"];
          }
          if (bundleData != null && bundleData["bundle_1"] != null) {
            bundleI = bundleData["bundle_1"];
          }
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:SingleChildScrollView(
        child: Column(
          // children: [
          //   Container(
          //     height: MediaQuery.of(context).size.height*1.20,
          //     margin: EdgeInsets.all(15),
          //     child: ListView(
                children: <Widget>[
                  /*Card(
                    child:  InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        print('Preliminary Checklist');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: ListTile(
                            leading: FlutterLogo(),
                            title: Text('Preliminary Checklist'),
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
                          print('Staff Attendance');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: FlutterLogo(),
                                title: Text('Staff Attendance'),
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
                          print('Hall List with Staff Allocation');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: FlutterLogo(),
                                title: Text('Hall List with Staff Allocation'),
                              ),
                            )
                        ),
                      )
                  ),
                  SizedBox(height: 5),*/
                  Card(
                      child:  InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              CandidatePage()));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.assignment_turned_in,color: Colors.green,),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(value : 2,type:"preliminary")));
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
                          print('Scan Question Box');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                title: Text('Scan Question Paper QR'),
                                trailing:(questionBoxQr != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(value : 3,type:"preliminary")));
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
                          print('Check Answer Sheet Box');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                title: Text('Scan Answer Packet QR'),
                                trailing: (answersheetQr != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(value : 1,type:"closing")));
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
                          // print('Check Answer Sheet Box');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                title: Text('Scan QR - Cover A'),
                                trailing: (bundleA1 != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(value : 2,type:"closing")));
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
                          print('Check Answer Sheet Box');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                title: Text('Scan QR - Cover B'),
                                trailing: (bundleA2 != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(value : 3,type:"closing")));
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
                          print('Check Answer Sheet Box');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                title: Text('Scan QR - Bundle I'),
                                trailing: (bundleA != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(value : 4,type:"closing")));
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
                          print('Check Answer Sheet Box');
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.qr_code_scanner,color: Colors.green,),
                                title: Text('Scan QR - Bundle II'),
                                trailing: (bundleB1 != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
                              ),
                            )
                        ),
                      )
                  ),
                  // SizedBox(height: 5),
                  // Card(
                  //     child:  InkWell(
                  //       splashColor: Colors.blue.withAlpha(30),
                  //       onTap: () {
                  //         Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(value : 5,type:"closing")));
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
                  //               title: Text('Closing Bundle B2'),
                  //               trailing: (bundleB2 != "")? Icon(Icons.check,color: Colors.green,): Icon(Icons.check,color: Colors.white,),
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
    );
  }
  Future<HashMap<String,Meta>> callAsyncMethod() async{
    HashMap<String,Meta> examData= HashMap<String,Meta>();
    TNPSCService service=new TNPSCService();
    Meta m=await service.processGetURL(Constants.BaseUrlDev+"/preliminary",Constants.AUTH_TOKEN);
    examData["preliminary"]=m;
    Meta mb=await service.processGetURL(Constants.BaseUrlDev+"/closing",Constants.AUTH_TOKEN);
    examData["closing"]=mb;
    return examData;
  }
}
class CandidatePage extends StatefulWidget {
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
        future: callAsyncMethod(),
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
                              userData["present"] = widget._pcontroller.text.toString();
                              debugPrint(userData.toString());
                              TNPSCService service = new TNPSCService();
                              Meta m = await service.processPostURL(
                                  Constants.BaseUrlDev + "/candidate-att", userData,
                                  Constants.AUTH_TOKEN);
                              debugPrint(m.response.toString());
                              debugPrint(m.statusMsg.toString());
                              if (m.statusCode == 200) {
                                debugPrint(m.response.toString());
                                Map<String, dynamic> response = m.response;
                                if (response["status"] == "ok") {
                                  Navigator.pop(context);
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //     ExamPage()));
                                } else {
                                  //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Values not updated"),
                                  ));
                                }
                              } else if (m.statusCode == 403) {
                                Navigator.pop(context);
                                // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                //     ExamPage()));
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
    Meta m=await service.processGetURL(Constants.BaseUrlDev+"/candidate-att",Constants.AUTH_TOKEN);
    return m;
  }
}
