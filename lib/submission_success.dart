import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/home_screen.dart';

class SubmissionSuccess extends StatelessWidget {
  static const routeName = '/submission_success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Successful Submission", style: GoogleFonts.lato()),
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
                "Information submitted successfully.",
                style: GoogleFonts.comicNeue(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                elevation: 5.0,
                child: Text("HOME",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(HomeScreen.routeName);
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
