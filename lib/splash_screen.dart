import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
  static const routeName = '/splash_screen';
}

class _SplashScreenState extends State<SplashScreen> {
  var image = Image.asset(
    'assets/demo_logo.png',
    height: 256,
    width: 256,
  );

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height * 1.00,
      width: MediaQuery.of(context).size.width * 1.00,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.white,
          Colors.blueGrey,
        ],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(40.0),
            child: SpinKitFadingCube(
              color: Color(0xff004080),
              size: 64.0,
            ),
          ),
          Container(
            padding: EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("POWERED BY",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  height: 5.0,
                ),
                Image.asset(
                  "assets/tri_logo.png",
                  height: 93.0,
                  width: 140.5,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
