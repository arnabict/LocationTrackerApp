import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/SignUpSignIn/sign_up.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:location_tracker/show_info.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

void displayDialogSignIn(context, title, text) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
            title: Text(
              title,
              style: GoogleFonts.lato(),
            ),
            content: Text(
              text,
              style: GoogleFonts.lato(),
            ),
            actions: [
              FlatButton(
                child: Text("Okay", style: GoogleFonts.lato()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]));

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Location Tracker",
              style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ))),
          centerTitle: true,
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.50,
          child: Drawer(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Colors.black,
                    Color(0xff004080),
                  ])),
              // color: Color(0xff006400),
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.white,
                    ])),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            child: Image.asset(
                              "assets/my_location.png",
                              height: 128,
                              width: 128,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Sign In",
                          style: GoogleFonts.mcLaren(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => SignIn()));
                    },
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.white,
                    endIndent: 40.0,
                    thickness: 1.0,
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.dashboard_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "My Dashboard",
                          style: GoogleFonts.mcLaren(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        )
                      ],
                    ),
                    onTap: () {
                      if (myToken != null) {
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => ShowInfo()));
                      } else
                        displayDialogSignIn(
                            context, "You are not signed in!", "Please sign in.");
                    },
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.white,
                    endIndent: 40.0,
                    thickness: 1.0,
                  ),
                ],
              ),
            ),
          ),
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
          child: ListView(
            children: [
              Container(
                child: Image.asset("assets/earth.png"),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Image.asset("assets/salesman.png"),
                        iconSize: 80,
                        onPressed: () {}),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: 60,
                      child: RaisedButton(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black)),
                        child: Text(
                          "Sign Up as Sales Representative",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp()));
                        },
                        color: Color(0xff004080),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
