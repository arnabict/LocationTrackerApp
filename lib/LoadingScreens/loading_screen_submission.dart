import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location_tracker/show_info.dart';
import 'package:location_tracker/submission_success.dart';

class LoadingScreenSubmission extends StatefulWidget {
  @override
  _LoadingScreenSubmissionState createState() => _LoadingScreenSubmissionState();
  static const routeName = '/loading_screen_submission';
}

class _LoadingScreenSubmissionState extends State<LoadingScreenSubmission> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(SubmissionSuccess.routeName);
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
        child: Center(
          child: SpinKitCubeGrid(
            color: Color(0xff004080),
            size: 81.0,
          ),
        ),
      ),
    );
  }
}
