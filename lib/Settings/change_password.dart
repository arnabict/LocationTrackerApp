import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracker/LoadingScreens/loading_screen_password_change_success.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'dart:convert';
import 'package:location_tracker/home_screen.dart';

//Global
var myUpdatedPassword;

class PasswordReset {
  // String accessToken;
  int userId;
  String currentPassword;
  String newPassword;
  String confirmPassword;

  PasswordReset(
      {
      // this.accessToken,
      this.userId,
      this.currentPassword,
      this.newPassword,
      this.confirmPassword});

  PasswordReset.fromJson(Map<String, dynamic> json) {
    // accessToken = json["access_token"];
    userId = json['user_id'];
    currentPassword = json['current_password'];
    newPassword = json['new_password'];
    confirmPassword = json['confirm_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['access_token'] = this.accessToken;
    data['user_id'] = this.userId;
    data['current_password'] = this.currentPassword;
    data['new_password'] = this.newPassword;
    data['confirm_password'] = this.confirmPassword;
    return data;
  }
}

class ChangePassword extends StatefulWidget {
  static const routeName = '/change_password';

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Future _futurePasswordReset;

  Future createPasswordReset(
      // String accessToken,
      int myUserId,
      String myCurrentPassword,
      String myNewPassword,
      String myConfirmPassword) async {
    final http.Response response = await http.post(
      Uri.parse(
          "https://location.timetechri.co.uk/api/location/change/password"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "user_id": myUserId,
        "current_password": myCurrentPassword,
        "new_password": myNewPassword,
        "confirm_password": myConfirmPassword,
      }),
    );

    print(response.statusCode);
    print(response.body);
    return response.body;
  }

  @override
  void initState() {
    super.initState();
    print("MY PASSWORD: " + myPassword.toString());
    print("MY UPDATED PASSWORD: " + myUpdatedPassword.toString());
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  Widget submitButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      color: Color(0xff004080),
      textColor: Colors.white,
      elevation: 5.0,
      child: Text(
        "Submit",
        style: GoogleFonts.mcLaren(textStyle: TextStyle(fontSize: 16)),
      ),
      onPressed: () async {
        final form = _formKey.currentState;
        if (form.validate()) {
          setState(() {
            myUpdatedPassword = confirmPasswordController.text;
            _futurePasswordReset = createPasswordReset(
                myUserId,
                currentPasswordController.text,
                newPasswordController.text,
                confirmPasswordController.text);
          });
          _futurePasswordReset.then((value) => Navigator.of(context)
              .pushReplacementNamed(
                  LoadingScreenPasswordChangeSuccess.routeName));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Change Password",
            style: GoogleFonts.lato(),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.white,
                Colors.blueGrey,
              ])),
          child: Form(
            key: _formKey,
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
                              "Current password:",
                              style: GoogleFonts.mcLaren(fontSize: 16),
                            ),
                          ],
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Current password can't empty";
                            } else if (value != myPassword) {
                              return "Current password doesn't match";
                            } else
                              return null;
                          },
                          controller: currentPasswordController,
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  currentPasswordController.clear();
                                },
                                icon: Icon(Icons.cancel_outlined),
                              ),
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
                                      color: Colors.grey, width: 3.0),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              "Enter new password:",
                              style: GoogleFonts.mcLaren(fontSize: 16),
                            ),
                          ],
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "New password can't be empty";
                            } else if (value.length <= 5) {
                              return "Minimum 6 characters required";
                            }
                            return null;
                          },
                          controller: newPasswordController,
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  newPasswordController.clear();
                                },
                                icon: Icon(Icons.cancel_outlined),
                              ),
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
                                      color: Colors.grey, width: 3.0),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              "Confirm new password:",
                              style: GoogleFonts.mcLaren(fontSize: 16),
                            ),
                          ],
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty ||
                                value != newPasswordController.text) {
                              return "Password doesn't match";
                            }
                            return null;
                          },
                          controller: confirmPasswordController,
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  confirmPasswordController.clear();
                                },
                                icon: Icon(Icons.cancel_outlined),
                              ),
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
                                      color: Colors.grey, width: 3.0),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        submitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
