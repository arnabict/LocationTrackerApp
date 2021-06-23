import 'package:flutter/material.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_get_map.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_get_questions.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_home_screen.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_password_change.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_password_change_success.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_personal_info.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_pp_change.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_settings.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_show_info.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_submission.dart';
import 'package:location_tracker/Settings/change_password.dart';
import 'package:location_tracker/Settings/change_personal_info.dart';
import 'package:location_tracker/Settings/change_profile_picture.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:location_tracker/check_internet.dart';
import 'package:location_tracker/get_questions.dart';
import 'package:location_tracker/google_map.dart';
import 'package:location_tracker/home_screen.dart';
import 'package:location_tracker/password_reset_success.dart';
import 'package:location_tracker/show_info.dart';
import 'package:location_tracker/splash_screen.dart';
import 'package:location_tracker/submission_success.dart';
import 'package:location_tracker/Settings/settings.dart';

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
        // SignUp.routeName: (ctx) => SignUp(),
        SignIn.routeName: (ctx) => SignIn(),
        ShowInfo.routeName: (ctx) => ShowInfo(),
        MyMap.routeName: (ctx) => MyMap(),
        // AccountCreation.routeName: (ctx) => AccountCreation(),
        SubmissionSuccess.routeName: (ctx) => SubmissionSuccess(),
        GetQuestions.routeName: (ctx) => GetQuestions(),
        LoadingScreenHomeScreen.routeName: (ctx) => LoadingScreenHomeScreen(),
        LoadingScreenShowInfo.routeName: (ctx) => LoadingScreenShowInfo(),
        LoadingScreenGetQuestions.routeName: (ctx) =>
            LoadingScreenGetQuestions(),
        LoadingScreenGetMap.routeName: (ctx) => LoadingScreenGetMap(),
        LoadingScreenSubmission.routeName: (ctx) => LoadingScreenSubmission(),
        LoadingScreenPasswordChange.routeName: (ctx) =>
            LoadingScreenPasswordChange(),
        LoadingScreenSettings.routeName: (ctx) => LoadingScreenSettings(),
        LoadingScreenPasswordChangeSuccess.routeName: (ctx) =>
            LoadingScreenPasswordChangeSuccess(),
        LoadingScreenPersonalInfo.routeName: (ctx) =>
            LoadingScreenPersonalInfo(),
        LoadingScreenPPChange.routeName: (ctx) => LoadingScreenPPChange(),
        ChangePersonalInfo.routeName: (ctx) => ChangePersonalInfo(),
        ChangeProfilePicture.routeName: (ctx) => ChangeProfilePicture(),
        ChangePassword.routeName: (ctx) => ChangePassword(),
        PasswordResetSuccess.routeName: (ctx) => PasswordResetSuccess(),
        Settings.routeName: (ctx) => Settings(),
      },
    );
  }
}
