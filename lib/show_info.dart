import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowInfo extends StatefulWidget {
  static const routeName = '/show_info';

  @override
  _ShowInfoState createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  String latitudeData = "";
  String longitudeData = "";

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    final myLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitudeData = "${myLocation.latitude}";
      longitudeData = "${myLocation.longitude}";
      print(latitudeData);
      print(longitudeData);
    });
  }

  // getProgressIndicatorLatitude() async {
  //   setState(() {
  //     if (latitudeData.isNotEmpty) {
  //       Text(latitudeData);
  //     } else {
  //       LinearProgressIndicator(
  //         backgroundColor: Colors.black,
  //         valueColor: AlwaysStoppedAnimation(Color(0xff004080)),
  //       );
  //     }
  //   });
  // }
  //
  // getProgressIndicatorLongitude() async {
  //   setState(() {
  //     if (longitudeData.isNotEmpty) {
  //       Text(longitudeData);
  //     } else {
  //       LinearProgressIndicator(
  //         backgroundColor: Colors.black,
  //         valueColor: AlwaysStoppedAnimation(Color(0xff004080)),
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Data",
            style: GoogleFonts.mcLaren(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold))),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Position: ",
              style: GoogleFonts.lato(
                  textStyle:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Latitude: ",
                  style: GoogleFonts.mcLaren(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  latitudeData,
                  style: GoogleFonts.mcLaren(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textStyle: TextStyle(color: Color(0xff004080))),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Longitude: ",
                  style: GoogleFonts.mcLaren(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  longitudeData,
                  style: GoogleFonts.mcLaren(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textStyle: TextStyle(color: Color(0xff004080))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
