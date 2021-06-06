import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/google_map.dart';
import 'package:location_tracker/home_screen.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Global
List res;
int myUserId;
final storage = FlutterSecureStorage();
final TextEditingController shopNameController = TextEditingController();
final TextEditingController shopDetailsController = TextEditingController();
double latDouble;
double longDouble;

class ShowInfo extends StatefulWidget {
  ShowInfo({Key key}) : super(key: key);
  static const routeName = '/show_info';

  @override
  _ShowInfoState createState() => _ShowInfoState();
}

class SignInRequest {
  SignInRequest({
    this.id,
    this.phone,
    this.email,
    this.password,
    this.accessToken,
  });

  int id;
  String phone;
  String email;
  String password;
  String accessToken;

  factory SignInRequest.fromJson(Map<String, dynamic> json) => SignInRequest(
        id: json["id"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        accessToken: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "email": email,
        "password": password,
        "token": accessToken,
      };
}

class _ShowInfoState extends State<ShowInfo> {
  String latitudeData = "";
  String longitudeData = "";
  bool validate = false;

  Future<SignInRequest> _futureUserData;

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

    print(myToken);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      myUserId = parsedJson["id"];
      print(response.body);
      print("MY USER ID:" + myUserId.toString());
      return SignInRequest.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  @override
  void dispose() {
    // text.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // questionWidget();
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _futureUserData = createRequestWithToken(
            emailController.text, passwordController.text, myToken);
      });
    });
    getCurrentLocation();
    // getDistrict();
    // futureQuestionList = getRequest();
  }

  getCurrentLocation() async {
    final myLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitudeData = "${myLocation.latitude}";
      longitudeData = "${myLocation.longitude}";
      latDouble = double.parse("$latitudeData");
      longDouble = double.parse("$longitudeData");
      print(latitudeData);
      print(longitudeData);
    });
  }

  // Widget questionWidget() {
  //   if (res == null) {
  //     return Container(
  //       padding: EdgeInsets.all(10.0),
  //       child: CircularProgressIndicator(
  //         backgroundColor: Colors.blueGrey,
  //         valueColor: AlwaysStoppedAnimation(Color(0xff004080)),
  //         strokeWidth: 5,
  //       ),
  //     );
  //   } else if (res != null) {
  //     return ListView.builder(
  //       padding: EdgeInsets.all(15.0),
  //       scrollDirection: Axis.vertical,
  //       shrinkWrap: true,
  //       physics: ClampingScrollPhysics(),
  //       itemCount: res == null ? 0 : res.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Card(
  //           elevation: 5.0,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(5.0),
  //           ),
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.all(
  //                   Radius.circular(5.0),
  //                 ),
  //                 gradient: LinearGradient(colors: [
  //                   Colors.white,
  //                   Colors.indigoAccent,
  //                 ])),
  //             padding: EdgeInsets.all(10.0),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   res[index]["name"],
  //                   style: GoogleFonts.lato(
  //                       textStyle: TextStyle(
  //                           fontWeight: FontWeight.bold, fontSize: 18)),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 TextField(
  //                   controller: text,
  //                   style: GoogleFonts.lato(fontSize: 18, color: Colors.black),
  //                   decoration: InputDecoration(
  //                       errorText: validate ? "Enter required info" : null,
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       contentPadding: const EdgeInsets.all(10.0),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide:
  //                             BorderSide(color: Color(0xff004080), width: 3.0),
  //                         borderRadius: BorderRadius.circular(5),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(
  //                               color: Color(0xff004080), width: 3.0),
  //                           borderRadius: BorderRadius.circular(5))),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
  //   return null;
  // }

  Widget nextButton() {
    if (latitudeData.isNotEmpty && longitudeData.isNotEmpty) {
      return RaisedButton(
        elevation: 5.0,
        child: Text("NEXT",
            style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 16))),
        onPressed: () {
          setState(() {
            // text.text.isEmpty ? validate = true : validate = false;
            // if (text.text.isNotEmpty) {
            Navigator.of(context).pushReplacementNamed(MyMap.routeName);
            // }
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Color(0xff004080),
        textColor: Colors.white,
      );
    } else
      return CircularProgressIndicator(
        backgroundColor: Colors.blueGrey,
        valueColor: AlwaysStoppedAnimation(Color(0xff004080)),
        strokeWidth: 5,
      );
  }

  // Widget getDistrict() {
  //   if (district.toString() == null) {
  //     return Text(
  //       "No district has been assigned",
  //       style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 14)),
  //     );
  //   } else
  //     return Text(
  //       district.toString(),
  //       style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 14)),
  //     );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Queries and Position",
            style: GoogleFonts.mcLaren(
                textStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ))),
        actions: [
          FlatButton(
            color: Colors.red,
            child: Row(
              children: [
                Text("SIGN OUT", style: GoogleFonts.lato(color: Colors.white)),
                SizedBox(width: 5.0),
                Icon(Icons.login)
              ],
            ),
            textColor: Colors.white,
            onPressed: () {
              storage.deleteAll();
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          )
        ],
      ),
      body: Container(
        height: double.infinity,
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
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Enter the name of the shop:",
                          style: GoogleFonts.mcLaren(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    TextField(
                      controller: shopNameController,
                      style:
                          GoogleFonts.lato(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff004080), width: 3.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff004080), width: 3.0),
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Enter details about the shop:",
                          style: GoogleFonts.mcLaren(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    TextField(
                      controller: shopDetailsController,
                      maxLines: 8,
                      maxLength: 1000,
                      keyboardType: TextInputType.multiline,
                      style:
                          GoogleFonts.lato(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff004080), width: 3.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff004080), width: 3.0),
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ],
                ),
              ),
              // questionWidget(),
              // Container(
              //   padding: EdgeInsets.all(20.0),
              //   child: Row(
              //     children: [
              //       Text(
              //         "Assigned District: ",
              //         style: GoogleFonts.lato(
              //             textStyle: TextStyle(
              //                 fontSize: 14, fontWeight: FontWeight.bold)),
              //       ),
              //       getDistrict(),
              //     ],
              //   ),
              // ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "My Position: ",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Latitude: ",
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          latitudeData,
                          style: GoogleFonts.lato(
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
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          longitudeData,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              textStyle: TextStyle(color: Color(0xff004080))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              nextButton(),
            ],
          ),
        ),
      ),
    );
  }
}
