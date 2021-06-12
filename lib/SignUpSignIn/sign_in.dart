import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/SignUpSignIn/sign_up.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_tracker/show_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Global
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
var myToken;

class Token {
  Token({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  String accessToken;
  String tokenType;
  int expiresIn;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
      };
}

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);
  static const routeName = '/sign_in';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Future<Token> createToken(String email, String password) async {
    final http.Response response = await http.post(
      Uri.parse("https://location.timetechri.co.uk/api/location/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      myToken = parsedJson["access_token"];
      return Token.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool passwordVisible;
  Future<Token> _futureToken;
  Future<SignInRequest> _futureSignInRequest;

  @override
  void initState() {
    passwordVisible = false;
    super.initState();
  }

  // void _submit() {
  //   setState(() {
  //     _futureSignInRequest =
  //         createRequest(emailController.text, passwordController.text, myToken);
  //   });
  // }

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

  @override
  Widget build(BuildContext context) {
    String pattern = r'^(\+?(88))?(01)[3-9]\d{8}$';
    RegExp regExp = RegExp(pattern);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In", style: GoogleFonts.lato()),
        actions: [
          FlatButton(
            child: Row(
              children: [
                Text("SIGN UP", style: GoogleFonts.lato(color: Colors.white)),
                SizedBox(width: 5.0),
                Icon(Icons.person_add)
              ],
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(SignUp.routeName);
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
                height: MediaQuery.of(context).size.height * 0.29,
                width: MediaQuery.of(context).size.width * 0.90,
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Email
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          style: GoogleFonts.lato(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Enter email or mobile number";
                            } else if (value.contains("@") &&
                                value.contains(".com")) {
                              return null;
                            } else
                              return "Enter email correctly";
                          },
                          onSaved: (value) {
                            // _authData['email'] = value;
                          },
                        ),
                        //Password
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              )),
                          obscureText: !passwordVisible,
                          validator: (value) {
                            if (value.isEmpty || value.length <= 5) {
                              return "Enter password correctly";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // _authData['password'] = value;
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        //Submit
                        RaisedButton(
                          elevation: 5.0,
                          child: Text("Sign In",
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                          onPressed: () async {
                            setState(() {
                              _futureToken = createToken(
                                emailController.text,
                                passwordController.text,
                              );
                              Navigator.of(context)
                                  .pushReplacementNamed(ShowInfo.routeName);
                            });
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
