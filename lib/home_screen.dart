import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_settings.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_show_info.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:location_tracker/show_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Global
int myUserId;
var imageUrl;
var myImageUrl;

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
  Future<SignInRequest> futureUserData;

  Future<SignInRequest> createRequestWithToken(
      String email, String password, String accessToken) async {
    final http.Response response = await http.post(
      Uri.parse("https://location.timetechri.co.uk/api/location/me"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'token': accessToken,
      }),
    );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      myUserId = parsedJson["id"];
      imageUrl = parsedJson["image"];
      print(response.body);
      myImageUrl = "https://location.timetechri.co.uk/" + imageUrl.toString();
      print("FINAL MY IMAGE URL: " + myImageUrl.toString());
      return SignInRequest.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    print("MY USER ID INIT: " + myUserId.toString());
    print("MY TOKEN INIT: " + myToken.toString());
    if (myToken != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          futureUserData = createRequestWithToken(
              emailController.text, passwordController.text, myToken);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var displayImage = FutureBuilder(
        future: futureUserData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ClipOval(
              child: imageUrl == null
                  ? ClipOval(
                      child: Image.asset(
                        "assets/dummy_user.png",
                        height: 128,
                        width: 128,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.network(
                      myImageUrl.toString(),
                      // "https://www.pixsy.com/wp-content/uploads/2021/04/ben-sweet-2LowviVHZ-E-unsplash-1.jpeg",
                      height: 128,
                      width: 128,
                      fit: BoxFit.cover,
                    ),
            );
          } else if (snapshot.hasError) {
            Text(
              "ERROR OCCURRED FETCHING IMAGE!",
              style: GoogleFonts.mcLaren(color: Colors.white),
            );
          } else if (myToken == null) {
            return ClipOval(
              child: Image.asset(
                "assets/my_location.png",
                height: 128,
                width: 128,
                fit: BoxFit.cover,
              ),
            );
          }
          return CircularProgressIndicator(
            backgroundColor: Colors.blueGrey,
            // valueColor: AlwaysStoppedAnimation(Color(0xff004080)),
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 5,
          );
        });
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
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                          Colors.black,
                          Color(0xff004080),
                        ])),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // userImage(),
                          displayImage,
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.login_outlined,
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
                          Icons.settings,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Settings",
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
                                builder: (BuildContext context) =>
                                    LoadingScreenSettings()));
                      } else
                        displayDialogSignIn(context, "You are not signed in!",
                            "Please sign in.");
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
              // Container(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       IconButton(
              //           icon: Image.asset("assets/salesman.png"),
              //           iconSize: 64,
              //           onPressed: () {}),
              //       Container(
              //         width: MediaQuery.of(context).size.width * 0.60,
              //         height: 60,
              //         child: RaisedButton(
              //           elevation: 5.0,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10.0),
              //               side: BorderSide(color: Colors.black)),
              //           child: Text(
              //             "Sign In as Sales Representative",
              //             textAlign: TextAlign.center,
              //             style: GoogleFonts.lato(
              //                 textStyle: TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 18,
              //                     fontWeight: FontWeight.bold)),
              //           ),
              //           onPressed: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (BuildContext context) => SignIn()));
              //           },
              //           color: Color(0xff004080),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Image.asset("assets/my_location.png"),
                        iconSize: 64,
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
                          "Share My Info",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        onPressed: () {
                          if (myToken != null) {
                            return Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoadingScreenShowInfo()));
                          } else
                            displayDialogSignIn(context,
                                "You are not signed in!", "Please sign in.");
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
