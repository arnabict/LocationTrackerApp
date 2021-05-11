import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location_tracker/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image.image, context);
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
        body: Center(
          // child: image,
          child: SpinKitFadingCube(
            color: Color(0xff004080),
            size: 80.0,
          ),
        )
    );
  }
}
