import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:location_tracker/home_screen.dart';

class AccountCreation extends StatelessWidget {
  static const routeName = '/account_creation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Creation", style: GoogleFonts.lato()),
        automaticallyImplyLeading: false,
        actions: [
          FlatButton(
            color: Colors.teal,
            child: Row(
              children: [
                Text("Home", style: GoogleFonts.pacifico(color: Colors.white)),
                SizedBox(width: 5.0),
                Icon(Icons.home_outlined)
              ],
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          )
        ],
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
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),
              Text(
                "Congratulations, your account has been created successfully.",
                style: GoogleFonts.comicNeue(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                elevation: 5.0,
                child: Text("Sign In Now",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(SignIn.routeName);
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
