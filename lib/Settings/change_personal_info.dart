import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracker/LoadingScreens/loading_screen_personal_info_success.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'dart:convert';
import 'package:location_tracker/home_screen.dart';

class ChangePersonalInfo extends StatefulWidget {
  static const routeName = '/change_personal_info';

  @override
  _ChangePersonalInfoState createState() => _ChangePersonalInfoState();
}

class _ChangePersonalInfoState extends State<ChangePersonalInfo> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Future _futurePasswordReset;

  var genderSelection;

  void displayDialog(context, title, text) => showDialog(
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
                  child: Text("Okay", style: GoogleFonts.mcLaren()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]));

  Future createPersonalInfo(
      // String accessToken,
      int myUserId,
      String myFirstName,
      String myLastName,
      String myGender,
      String myAddress,
      String myImage) async {
    final http.Response response = await http.post(
      Uri.parse(
          "https://location.timetechri.co.uk/api/location/update/profile"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "user_id": myUserId,
        "first_name": myFirstName,
        "last_name": myLastName,
        "gender": myGender,
        "address": myAddress,
        "image": myImage,
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
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
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
            _futurePasswordReset = createPersonalInfo(
                myUserId,
                firstNameController.text,
                lastNameController.text,
                genderSelection,
                addressController.text,
                null);
          });
          _futurePasswordReset
              .then((value) => Navigator.of(context)
                  .pushReplacementNamed(LoadingScreenPersonalInfoSuccess.routeName))
              .catchError((e) {
            displayDialog(context, "Error Occurred!", "Try again later.");
          });
        }
      },
    );
  }

  _dropdownButtonFormField() {
    return FormField<String>(
      validator: (value) {
        if (value == null) {
          return "Select gender";
        }
        return null;
      },
      onSaved: (value) {},
      builder: (
        FormFieldState<String> state,
      ) {
        return Column(
          children: <Widget>[
            Container(
              decoration: ShapeDecoration(
                //color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Color(0xff004080),
                        width: 3.0,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Center(
                    child: Text(
                      "Gender",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mcLaren(
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  value: genderSelection,
                  onChanged: (String newValue) {
                    state.didChange(newValue);
                    setState(() {
                      genderSelection = newValue;
                    });
                  },
                  items:
                      <String>["Male", "Female", "Other"].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Personal Information",
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
                              "First Name:",
                              style: GoogleFonts.mcLaren(fontSize: 16),
                            ),
                          ],
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "First Name can't empty";
                            } else
                              return null;
                          },
                          controller: firstNameController,
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  firstNameController.clear();
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
                              "Last Name:",
                              style: GoogleFonts.mcLaren(fontSize: 16),
                            ),
                          ],
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Last Name can't be empty";
                            } else
                              return null;
                          },
                          controller: lastNameController,
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  lastNameController.clear();
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
                              "Gender",
                              style: GoogleFonts.mcLaren(fontSize: 16),
                            ),
                          ],
                        ),
                        _dropdownButtonFormField(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              "Address",
                              style: GoogleFonts.mcLaren(fontSize: 16),
                            ),
                          ],
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Address can't be empty";
                            } else
                              return null;
                          },
                          controller: addressController,
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  addressController.clear();
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
