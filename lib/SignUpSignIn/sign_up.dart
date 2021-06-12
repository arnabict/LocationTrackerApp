import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location_tracker/account_creation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Global
var currentSelectedValue;
var currentSelectedValueDistrict;
// final storage = FlutterSecureStorage();
// final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

Future<SignUpRequest> createRequest(
    dynamic userRole,
    dynamic firstName,
    dynamic lastName,
    dynamic gender,
    dynamic phone,
    dynamic profession,
    dynamic upazillaId,
    dynamic email,
    dynamic address,
    dynamic password) async {
  final http.Response response = await http.post(
    Uri.parse("https://location.timetechri.co.uk/api/user_register"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'user_role': userRole,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'phone': phone,
      'profession': profession,
      'upazilla_id': upazillaId,
      'email': email,
      'address': address,
      'password': password,
    }),
  );

  // var resposeBody = response.body;
  // if (resposeBody == "Email Existed") {
  //   Scaffold.of(context).showSnackBar(SnackBar(
  //     content: Text("Email already exists"),
  //   ));
  // } else {
  //   Scaffold.of(context).showSnackBar(SnackBar(
  //     content: Text("Processing..."),
  //   ));
  // }

  var res = json.decode(response.body);
  if (response.statusCode == 200) {
    return SignUpRequest.fromJson(res[0]);
  } else {
    throw Exception("!!!!!!!!!!!!!!!!!!");
  }
}

class SignUpRequest {
  SignUpRequest({
    this.userRole,
    this.firstName,
    this.lastName,
    this.phone,
    this.profession,
    this.gender,
    this.upazillaId,
    this.unionId,
    this.address,
    this.email,
    this.emailVerifiedAt,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int userRole;
  dynamic firstName;
  dynamic lastName;
  dynamic phone;
  dynamic profession;
  dynamic gender;
  dynamic upazillaId;
  dynamic unionId;
  dynamic address;
  String email;
  dynamic emailVerifiedAt;
  int status;
  dynamic createdAt;
  dynamic updatedAt;

  factory SignUpRequest.fromJson(Map<String, dynamic> json) => SignUpRequest(
        userRole: json["user_role"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        profession: json["profession"],
        gender: json["gender"],
        upazillaId: json["upazilla_id"],
        unionId: json["union_id"],
        email: json["email"],
        address: json["address"],
        emailVerifiedAt: json["email_verified_at"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "user_role": userRole,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "profession": profession,
        "gender": gender,
        "upazilla_id": upazillaId,
        "union_id": unionId,
        "address": address,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);
  static const routeName = '/sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Future<SignUpRequest> _futureSignUpRequest;

  List districtList = List();

  Future getDistrictList() async {
    var res = await http.get(
        Uri.parse(
            "https://location.timetechri.co.uk/api/location/district/list"),
        headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      districtList = resBody;
    });
    return resBody;
  }

  @override
  void initState() {
    super.initState();
    getDistrictList();
  }

  //Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  child: Text("Okay", style: GoogleFonts.lato()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]));

  _dropdownButtonFormField() {
    return FormField<String>(
      validator: (value) {
        if (value == null) {
          return "Please enter your gender";
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
                  value: currentSelectedValue,
                  onChanged: (String newValue) {
                    state.didChange(newValue);
                    setState(() {
                      currentSelectedValue = newValue;
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

  _dropdownButtonFormFieldDistrict() {
    return FormField<String>(
      validator: (value) {
        if (value == null) {
          return "Please enter assigned district";
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
                child: DropdownButton(
                  isExpanded: true,
                  hint: Center(
                    child: Text(
                      "Assigned District",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mcLaren(
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  value: currentSelectedValueDistrict,
                  onChanged: (newValue) {
                    state.didChange(newValue);
                    setState(() {
                      currentSelectedValueDistrict = newValue;
                    });
                  },
                  items: districtList.map((item) {
                    return DropdownMenuItem(
                      child: Center(
                        child: Text(
                          item['name'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(),
                        ),
                      ),
                      value: item['name'].toString(),
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

  String validateMobileNumber(String value) {
    String pattern = r'^(\+?(88))?(01)[3-9]\d{8}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "Please enter your mobile number";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter valid mobile number";
    }
    return null;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sign Up", style: GoogleFonts.lato()),
        actions: [
          FlatButton(
            child: Row(
              children: [
                Text("SIGN IN", style: GoogleFonts.lato(color: Colors.white)),
                SizedBox(width: 5.0),
                Icon(Icons.login)
              ],
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(SignIn.routeName);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                Color(0xff004080),
              ],
            )),
          ),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.90,
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //First Name
                        TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                              labelText: "First Name",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.lato(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your first name";
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                        //Last Name
                        TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                              labelText: "Last Name",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.lato(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your last name";
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        //Gender
                        _dropdownButtonFormField(),
                        //Mobile Number
                        TextFormField(
                          controller: mobileNumberController,
                          decoration: InputDecoration(
                              labelText: "Mobile Number",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.lato(),
                          validator: validateMobileNumber,
                          onSaved: (value) {},
                        ),
                        //Profession
                        TextFormField(
                          controller: professionController,
                          decoration: InputDecoration(
                              labelText: "Profession",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.lato(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Enter your profession";
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                        //Email
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.lato(),
                          validator: (value) {
                            if (value.isEmpty ||
                                !value.contains("@") ||
                                !value.contains(".com")) {
                              return "Enter your email correctly";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // _authData['email'] = value;
                          },
                        ),
                        //Address
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                              labelText: "Address",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.lato(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Enter your email correctly";
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        _dropdownButtonFormFieldDistrict(),
                        //Password
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty || value.length <= 5) {
                              return "Invalid password. Minimum 6 characters required.";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // _authData['password'] = value;
                          },
                        ),
                        //Confirm Password
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty ||
                                value != passwordController.text) {
                              return "Password doesn't match";
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        //Submit
                        RaisedButton(
                          elevation: 5.0,
                          child: Text("SIGN UP",
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                          onPressed: () {
                            final form = _formKey.currentState;
                            if (form.validate()) {
                              setState(() {
                                _futureSignUpRequest = createRequest(
                                    "2",
                                    firstNameController.text,
                                    lastNameController.text,
                                    currentSelectedValue,
                                    mobileNumberController.text,
                                    professionController.text,
                                    "1",
                                    emailController.text,
                                    addressController.text,
                                    passwordController.text);
                              });
                              _futureSignUpRequest.then((value) {
                                Future.delayed(Duration(milliseconds: 2500),
                                    () {
                                  setState(() {
                                    Navigator.of(context).pushReplacementNamed(
                                        AccountCreation.routeName);
                                  });
                                });
                              });
                            }
                            if (!form.validate()) {
                              return displayDialog(context, "Error Occurred!",
                                  "Enter data correctly.");
                            } else {
                              Future.delayed(Duration(seconds: 5), () {
                                setState(() {
                                  displayDialog(context, "Error Occurred!",
                                      "Email already exists.");
                                });
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Color(0xff004080),
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
