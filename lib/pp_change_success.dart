import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_home_screen.dart';

class PPChangeSuccess extends StatelessWidget {
  static const routeName = '/pp_change_success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Picture Changed", style: GoogleFonts.lato()),
        automaticallyImplyLeading: false,
      ),
      body: Container(
          height: double.infinity,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              Text(
                "Profile picture has been changed.",
                style: GoogleFonts.comicNeue(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                elevation: 5.0,
                child: Text("Home",
                    style: GoogleFonts.mcLaren(
                        textStyle: TextStyle(fontSize: 16))),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoadingScreenHomeScreen.routeName);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Color(0xff004080),
                textColor: Colors.white,
              )
            ],
          )),
    );
  }
}
