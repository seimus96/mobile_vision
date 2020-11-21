import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_example/main.dart';
//import 'package:flutkart/utils/flutkart.dart';
//import 'package:flutkart/utils/my_navigator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //Timer(Duration(seconds: 5), () => Navigator.pushNamed(context, "/home"));
    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => MyApp())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: azulUPS),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Image.asset(
                          'assets/img/scan_text.png',
                          color: amarilloUPS,
                        ),
                        /*Icon(
                          Icons.center_focus_weak, //format_shapes
                          color: amarilloUPS,
                          size: 70.0,
                        ),*/
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Book's Recognition",
                        style: TextStyle(
                            color: amarilloUPS,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: amarilloUPS,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Book's Scanner",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: amarilloUPS),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
