import 'package:flutter/material.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_get_map.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_get_questions.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_show_info.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_submission.dart';
import 'package:location_tracker/SignUpSignIn/sign_up.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:location_tracker/account_creation.dart';
import 'package:location_tracker/check_internet.dart';
import 'package:location_tracker/get_questions.dart';
import 'package:location_tracker/google_map.dart';
import 'package:location_tracker/home_screen.dart';
import 'package:location_tracker/show_info.dart';
import 'package:location_tracker/splash_screen.dart';
import 'package:location_tracker/submission_success.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Location Tracker",
      theme: ThemeData(primaryColor: Color(0xff004080)),
      home: CheckInternet(),
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        SignUp.routeName: (ctx) => SignUp(),
        SignIn.routeName: (ctx) => SignIn(),
        ShowInfo.routeName: (ctx) => ShowInfo(),
        MyMap.routeName: (ctx) => MyMap(),
        AccountCreation.routeName: (ctx) => AccountCreation(),
        SubmissionSuccess.routeName: (ctx) => SubmissionSuccess(),
        GetQuestions.routeName: (ctx) => GetQuestions(),
        LoadingScreenShowInfo.routeName: (ctx) => LoadingScreenShowInfo(),
        LoadingScreenGetQuestions.routeName: (ctx) => LoadingScreenGetQuestions(),
        LoadingScreenGetMap.routeName: (ctx) => LoadingScreenGetMap(),
        LoadingScreenSubmission.routeName: (ctx) => LoadingScreenSubmission(),
      },
    );
  }
}
