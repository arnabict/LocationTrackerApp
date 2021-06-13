import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:location_tracker/splash_screen.dart';

class CheckInternet extends StatefulWidget {
  @override
  _CheckInternetState createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckInternet> {
  @override
  void initState() {
    super.initState();
    initTimer();
  }

  void initTimer() async {
    if (await checkInternet()) {
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed(SplashScreen.routeName);
      });
    }
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
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
      alignment: Alignment.center,
      child: FutureBuilder(
          future: checkInternet(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  "Connecting...",
                  style: GoogleFonts.mcLaren(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.data == true) {
              return Center(
                child: Text(
                  "Connecting...",
                  style: GoogleFonts.mcLaren(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_outlined,
                    size: 100,
                    color: Colors.red,
                  ),
                  Text(
                    "Your device is not connected to the internet!",
                    style: GoogleFonts.comicNeue(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.teal[400]),
                      onPressed: () {
                        setState(() {
                          initTimer();
                        });
                      },
                      child: Text(
                        "Try after enabling the internet",
                        style: GoogleFonts.comicNeue(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ))
                ],
              );
            }
          }),
    ));
  }
}
