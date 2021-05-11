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

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Location Tracker",
              style: GoogleFonts.mcLaren(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold))),
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
                              "assets/demo_logo.png",
                              height: 100,
                              width: 100,
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
                          Icons.list_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("My Listings",
                            style: GoogleFonts.mcLaren(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 18)))
                      ],
                    ),
                    onTap: () {},
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
                      Navigator.of(context)
                          .pushReplacementNamed(SignIn.routeName);
                    },
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
                Colors.white,
              ],
            )),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(SignUp.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff004080),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  ElevatedButton(
                    child: Text(
                      "Show Info",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(ShowInfo.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff004080),
                    ),
                  ),
                ],
              ),
            )));
  }
}
