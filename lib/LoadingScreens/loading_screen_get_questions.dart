import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location_tracker/get_questions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreenGetQuestions extends StatefulWidget {
  @override
  _LoadingScreenGetQuestionsState createState() => _LoadingScreenGetQuestionsState();
  static const routeName = '/loading_screen_get_questions';
}

class _LoadingScreenGetQuestionsState extends State<LoadingScreenGetQuestions> {
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
    Navigator.of(context).pushReplacementNamed(GetQuestions.routeName);
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
