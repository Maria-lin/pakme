import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:smart_parking/resevation/reservationavance.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'mapmain.dart';

class GeneratePage extends StatefulWidget {
  final  String?  value;
  final  String?  email;
  GeneratePage({Key? key , this.value, this.email }): super(key: key);
  @override
  State<StatefulWidget> createState() => GeneratePageState(value: '');
}

class GeneratePageState extends State<GeneratePage> {

  String qr=
      "";
  String Data =
      "";
  TextEditingController dateinput = TextEditingController();
  final String?  value; final  String?  email;
  GeneratePageState({ this.value , this.email});
  String qrData =
      "grandeur initial ";
  @override void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {

            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF1C0527),
            size: 24,
          ),
        ),
        title: Text(
          'votre qr code ',
          style: FlutterFlowTheme.of(context).subtitle2.override(
            fontFamily: 'Lexend Deca',
            color: FlutterFlowTheme.of(context).tertiaryColor,
          ),
        ),

        actions: [],
        centerTitle: false,
        elevation: 0,
      ),

      body: Container(
        padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            QrImageView(
              //plce where the QR Image will be shown
              data: qrData,

            ),

            SizedBox(
              height: 20.0,
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 0),

              child:TextButton(
                onPressed: () async {
                  MaterialPageRoute(builder: (context) => MapScreen());
                  setState(() {
                    String datetime = DateTime.now().toString();
                    qrData = widget.value!;
                    Text(
                      "New QR Link Generator",
                      style: TextStyle(fontSize: 10.0),
                    );
                  });
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(15.0),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.deepPurpleAccent,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    Colors.deepPurpleAccent.withOpacity(0.2),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      side: BorderSide(color: Colors.deepPurpleAccent, width: 3.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: Text(
                  "Generate QR",
                ),
              ),
            ),
            Text(
              "ps : veulliez capturer votre qr code et le scanner à l'acceuil du parking afin que vous puissiez rentrer  ",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );


  }


}


