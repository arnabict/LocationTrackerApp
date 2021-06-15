import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/LoadingScreens/loading_screen_get_questions.dart';
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
  bool validateShop = false;
  bool validateShopDetails = false;

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

    print("MY TOKEN: " + myToken.toString());
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      myUserId = parsedJson["id"];
      print(response.body);
      print("MY USER ID: " + myUserId.toString());
      return SignInRequest.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    shopNameController.clear();
    shopDetailsController.clear();
    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        _futureUserData = createRequestWithToken(
            emailController.text, passwordController.text, myToken);
      });
    });
    getCurrentLocation();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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

  Widget nextButton() {
    if (latitudeData.isNotEmpty && longitudeData.isNotEmpty) {
      return FlatButton(
        color: Colors.teal,
        child: Row(
          children: [
            Text("NEXT",
                style: GoogleFonts.comicNeue(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 5.0),
            Icon(Icons.navigate_next)
          ],
        ),
        onPressed: () {
          setState(() {
            if (shopNameController.text.isEmpty) {
              validateShop = true;
            }
            if (shopDetailsController.text.isEmpty) {
              validateShopDetails = true;
            }
            if (shopNameController.text.isNotEmpty &&
                shopDetailsController.text.isNotEmpty) {
              validateShop = false;
              validateShopDetails = false;
              Navigator.of(context)
                  .pushReplacementNamed(LoadingScreenGetQuestions.routeName);
            }
            // shopNameController.text.isEmpty
            //     ? validateShop = true
            //     : validateShop = false;
            // shopDetailsController.text.isEmpty
            //     ? validateShopDetails = true
            //     : validateShopDetails = false;
          });
        },
      );
    } else
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blueGrey,
          valueColor: AlwaysStoppedAnimation(Color(0xff004080)),
          strokeWidth: 5,
        ),
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
              fontSize: 18,
            ))),
        actions: [
          nextButton(),
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
                          style: GoogleFonts.mcLaren(fontSize: 16),
                        ),
                      ],
                    ),
                    TextField(
                      controller: shopNameController,
                      style:
                          GoogleFonts.lato(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              shopNameController.clear();
                            },
                            icon: Icon(Icons.cancel_outlined),
                          ),
                          errorText:
                              validateShop ? "Shop name can't be empty" : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff004080), width: 3.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 3.0),
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Enter details about the shop:",
                          style: GoogleFonts.mcLaren(fontSize: 16),
                        ),
                      ],
                    ),
                    TextField(
                      controller: shopDetailsController,
                      maxLines: 6,
                      maxLength: 1000,
                      keyboardType: TextInputType.multiline,
                      style:
                          GoogleFonts.lato(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              shopDetailsController.clear();
                            },
                            icon: Icon(Icons.cancel_outlined),
                          ),
                          errorText: validateShopDetails
                              ? "Shop Details can't be empty"
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff004080), width: 3.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 3.0),
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
                child: Card(
                  child: Container(
                    color: Colors.grey[600],
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "My Position: ",
                          style: GoogleFonts.mcLaren(
                              color: Colors.white,
                              textStyle: TextStyle(fontSize: 16)),
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
                                  textStyle:
                                      TextStyle(color: Color(0xff004080))),
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
                                  textStyle:
                                      TextStyle(color: Color(0xff004080))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              // nextButton(),
            ],
          ),
        ),
      ),
    );
  }
}
