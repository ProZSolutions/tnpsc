import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnpsc/home/home_page.dart';
import 'package:tnpsc/view/meet/meeting.dart';

class ConfirmAlertDialog extends StatefulWidget {
  const ConfirmAlertDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.type,
    this.message=0,
    this.examId=0,
    this.examName=""
  }) : super(key: key);

  final String title, description,type;
  final int message,examId;
  final String examName;
  @override
  _ConfirmAlertDialogState createState() => _ConfirmAlertDialogState();
}

class _ConfirmAlertDialogState extends State<ConfirmAlertDialog> {
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
              FlutterLogo(size: 80),
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
              Row(children:[Container(
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
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewMeet(examId: widget.examId,type:4,examName: widget.examName,)));
                          }
                          );
                        },
                        child: Text("Yes",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                      )
                  )
              ),Container(
                  child:ButtonTheme(
                      height: MediaQuery.of(context).size.height * 0.06,
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 1,
                        color: Colors.grey[900],
                        onPressed: (){
                          setState(() {
                            Navigator.pop(context);
                          }
                          );
                        },
                        child: Text("No",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),),
                      )
                  )
              )]),
              SizedBox(height: 20),
            ],
          ),
        )
      )
    );
  }
}