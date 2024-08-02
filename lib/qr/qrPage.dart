import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tnpsc/core/constant.dart';
import 'package:tnpsc/core/meta.dart';
import 'package:tnpsc/core/tnpsc_Core.dart';
import 'package:tnpsc/home/home_page.dart';
import 'package:tnpsc/view/exam/alertbox.dart';
import 'package:tnpsc/view/exam/exam.dart';
import 'package:tnpsc/view/exam/exam_list.dart';
import 'package:tnpsc/view/meet/meeting.dart';

class QrPage extends StatefulWidget {

   QrPage({
    Key? key,
    required this.value,
     this.type="meeting",
     this.examId=0,
     this.notificationName="",
     this.examName="",
     this.dayId=0,
     this.sessionId=0,
     this.bundleName="",
     this.sessionName="",
     this.bundleLabel="",
     this.hallcode=""
   }) : super(key: key);

  int value;
  String type;
  int examId;
  String notificationName="";
  String examName="";
  int dayId=0;
  int sessionId=0;
  String bundleName="";
  String sessionName="";
  String bundleLabel="";
  String hallcode="";
  @override
  _QrPageState createState() => _QrPageState(message:value,type:type,examId:examId,dayId:dayId);
}

class _QrPageState extends State<QrPage> {

   _QrPageState({
     required this.message,
     required this.type,
     required this.examId,
     this.dayId=0
  });

  int message;
  String type;
  int examId=0;
  int dayId=0;

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          Navigator.pop(context);
          // Navigator.pop(context);
          if(type=="meeting-attendance") {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                HomePage(currentIndex: 1,)));
          }else if(type=="meeting") {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ScanListPage(type: message, returnedQrCode: result?.code ?? "",examId: examId,notificationName: widget.notificationName,examName: widget.examName,)));
          }else if(type=="verify-qa-qr") {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ExamScanListPage(type: message, returnedQrCode: result?.code ?? "",examId: examId,notificationName: widget.notificationName,examName: widget.examName,dayId:dayId)));
          }else if(type=="add-bundle-packing") {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ExamBundleScanListPage(examId: examId,notificationName: widget.notificationName,examName: widget.examName,dayId:dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
          }else if(type=="add-material-received") {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));
          }else if(type=="add-vd-info") {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> VDExamScanListPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 2,)));
          }
          return true;
        } ,child:Container(
      child: _buildQrView(context),
    ));
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery
        .of(context)
        .size
        .width < 400 ||
        MediaQuery
            .of(context)
            .size
            .height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData)async {
      result = scanData;
      controller.pauseCamera();
      String serviceName=type;
      if(result!=null) {
        Map<String, dynamic> userData = new Map<String, dynamic>();
        if(type!="meeting-attendance" && type!="verify-qa-qr") {
          userData["id"] = examId;
          userData["type"] = message;
        }
        if(type=="verify-qa-qr"){
          serviceName="exam/"+type;
          userData["exam_id"]=examId;
          userData["dayid"]=dayId;
          userData["type"]=message;
        }
        if(type=="add-bundle-packing"){
          serviceName="exam/"+type;
          userData["exam_id"]=examId;
          userData["dayid"]=dayId;
          userData["sessionid"]=widget.sessionId;
          userData["bundle_name"]=widget.bundleName;
        }
        if(type=="add-material-received"){
          serviceName="exam/"+type;
          userData["exam_id"]=examId;
          userData["dayid"]=dayId;
          userData["sessionid"]=widget.sessionId;
        }
        if(type=="add-vd-info"){
          serviceName=type;
          userData["exam_id"]=examId;
          userData["day_id"]=dayId;
          userData["session_id"]=widget.sessionId;
          userData["hall_code"]=widget.hallcode;
          userData["center_code"]=widget.bundleLabel;
        }
        userData["qr_details"] = result?.code ?? "";
        TNPSCService service = new TNPSCService();
        Meta m = await service.processPostURL(
            Constants.BaseUrlDev + "/"+serviceName, userData,
            Constants.AUTH_TOKEN);
        debugPrint("GGGGGGGGGGGGGHHHHHHHH"+m.statusMsg.toString());
        if (m.statusCode == 200) {
          debugPrint(m.response.toString());
          Map<String, dynamic> response = m.response;
          if (response["status"] == "success" || response["status"] == "ok") {
            Navigator.pop(context);
            // Navigator.pop(context);
            if(type=="meeting-attendance") {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  HomePage(currentIndex: 1,)));
            }else if(type=="meeting") {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  ScanListPage(type: message, returnedQrCode: result?.code ?? "",examId: examId,notificationName: widget.notificationName,examName: widget.examName,)));
            }else if(type=="verify-qa-qr") {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  ExamScanListPage(type: message, returnedQrCode: result?.code ?? "",examId: examId,notificationName: widget.notificationName,examName: widget.examName,dayId:dayId)));
            }else if(type=="add-bundle-packing") {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  ExamBundleScanListPage(examId: examId,notificationName: widget.notificationName,examName: widget.examName,dayId:dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
            }else if(type=="add-material-received") {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));
            }else if(type=="add-vd-info") {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> VDExamScanListPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 2,)));
            }
            if(type=="add-bundle-packing"){
              String bundleType=widget.bundleLabel;
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: bundleType+" has been",
                    description: "successfully verified.",
                    type: type,
                    message: message,
                    examId: examId,
                  );
                },
              );
            }else if(type=="add-material-received"){
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: "QP Box Open time has been",
                    description: "successfully submitted.",
                    type: type,
                    message: message,
                    examId: examId,
                  );
                },
              );
            }else if(type=="add-vd-info"){
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: widget.hallcode+" Booklet has been",
                    description: "successfully verified.",
                    type: type,
                    message: message,
                    examId: examId,
                  );
                },
              );
            }else {
              (message == 1) ? showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: "Thanks for attending the meeting.",
                    description: "Your attendance has been registered.",
                    type: type,
                    message: message,
                    examId: examId,
                  );
                },
              ) : (message == 2) ? showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: "Question Paper Box QR scanning ",
                    description: "has been successfully verified.",
                    type: type,
                    message: message,
                    examId: examId,
                  );
                },
              ) : showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: "Answer sheet packet QR scanning ",
                    description: "has been successfully verified.",
                    type: type,
                    message: message,
                    examId: examId,
                  );
                },
              );
            }
          } else {
            //util.customGetSnackBarWithOutActionButton("Login", "Invalid username/password", context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Values not updated"),
            ));
          }
        } else if(m.statusCode==403 || m.statusCode==422 || m.statusCode==400) {
          Map<String, dynamic> response = jsonDecode(m.statusMsg);
          Navigator.pop(context);
          // Navigator.pop(context);
          if(type=="meeting-attendance") {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 1,)));
          }else if(type=="meeting") {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ScanListPage(type: message, returnedQrCode: "",examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName)));
          }else if(type=="verify-qa-qr") {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ExamScanListPage(type: message, returnedQrCode: "",examId: widget.examId,notificationName: widget.notificationName,examName: widget.examName,dayId: dayId,)));
          }else if(type=="add-bundle-packing") {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ExamBundleScanListPage(examId: examId,notificationName: widget.notificationName,examName: widget.examName,dayId:dayId,sessionName: widget.sessionName,sessionId: widget.sessionId,)));
          }else if(type=="add-material-received") {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionDetailPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));
          }else if(type=="add-vd-info") {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> VDExamScanListPage(examId: widget.examId,notificationName: widget.notificationName,dayId: widget.dayId,examName: widget.examName,sessionId:widget.sessionId ,sessionName: widget.sessionName,)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 2,)));
          }
          //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response["error"]),
          ));
        }else {
          Map<String, dynamic> response = jsonDecode(m.statusMsg);
          //util.customGetSnackBarWithOutActionButton("Login", response["message"], context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: response["message"]!=null?Text(response["message"]):Text("Values not updated"),
          ));
        }

      }
    });

  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }
   @override
   void dispose() {
     controller?.dispose();
     super.dispose();
   }
}

