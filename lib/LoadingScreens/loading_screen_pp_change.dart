import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location_tracker/Settings/change_password.dart';
import 'package:location_tracker/Settings/change_profile_picture.dart';

class LoadingScreenPPChange extends StatefulWidget {
  @override
  _LoadingScreenPPChangeState createState() =>
      _LoadingScreenPPChangeState();
  static const routeName = '/loading_screen_pp_change';
}

class _LoadingScreenPPChangeState
    extends State<LoadingScreenPPChange> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(ChangeProfilePicture.routeName);
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
