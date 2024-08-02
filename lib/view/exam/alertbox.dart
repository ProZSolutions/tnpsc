import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnpsc/home/home_page.dart';
import 'package:tnpsc/theme/customIcons.dart';
import 'package:tnpsc/view/meet/meeting.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.type,
    this.message=0,
    this.examId=0
  }) : super(key: key);

  final String title, description,type;
  final int message,examId;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
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
                "${widget.title}",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text("${widget.description}"),
              SizedBox(height: 50),
              Container(
                  child:ButtonTheme(
                      height: MediaQuery.of(context).size.height * 0.06,
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 1,
                        color: Colors.green[900],
                        onPressed: (){
                          setState(() {
                            Navigator.pop(context);
                            // if(widget.type=="meeting-attendance") {
                            //   Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 1,)));
                            // }else if(widget.type=="meeting") {
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            //       ScanListPage(type: widget.message, returnedQrCode: "",examId: widget.examId,)));
                            // }else{
                            //   Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(currentIndex: 2,)));
                            // }
                          }
                          );
                        },
                        child: Text("Done",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                      )
                  )
              ),
              SizedBox(height: 20),
            ],
          ),
        )
      )
    );
  }
}