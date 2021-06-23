import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_password_change.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_personal_info.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_pp_change.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: GoogleFonts.lato()),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.white,
              Colors.blueGrey,
            ])),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                        LoadingScreenPersonalInfo.routeName);
                  },
                  child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            gradient: LinearGradient(colors: [
                              Colors.blueGrey,
                              Colors.white,
                            ])),
                        child: Text(
                          "Edit personal information",
                          style: GoogleFonts.mcLaren(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                        LoadingScreenPPChange.routeName);
                  },
                  child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            gradient: LinearGradient(colors: [
                              Colors.blueGrey,
                              Colors.white,
                            ])),
                        child: Text(
                          "Change profile picture",
                          style: GoogleFonts.mcLaren(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                        LoadingScreenPasswordChange.routeName);
                  },
                  child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            gradient: LinearGradient(colors: [
                              Colors.blueGrey,
                              Colors.white,
                            ])),
                        child: Text(
                          "Change password",
                          style: GoogleFonts.mcLaren(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
