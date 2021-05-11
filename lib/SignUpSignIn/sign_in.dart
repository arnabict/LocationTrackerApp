import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/sign_in';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool passwordVisible;

  @override
  void initState() {
    passwordVisible = false;
    super.initState();
  }

  // Map<String, String> _authData = {'email': '', 'password': ''};

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            title: Text("An Error Occurred!", style: GoogleFonts.lato()),
            content: Text(msg),
            actions: [
              FlatButton(
                child: Text("Okay", style: GoogleFonts.lato()),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ]));
  }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState.validate()) {
  //     return;
  //   }
  //   _formKey.currentState.save();
  //
  //   try {
  //     await Provider.of<Authentication>(context, listen: false)
  //         .login(_authData['email'], _authData['password']);
  //     Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  //   } catch (error) {
  //     var errorMessage = "Authentication failed! Please try again.";
  //     _showErrorDialog(errorMessage);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In", style: GoogleFonts.lato()),
        actions: [
          FlatButton(
            child: Row(
              children: [
                Text("Sign Up", style: GoogleFonts.lato()),
                SizedBox(width: 5.0),
                Icon(Icons.person_add)
              ],
            ),
            textColor: Colors.white,
            onPressed: () {
              // Navigator.of(context).pushReplacementNamed(SignUp.routeName);
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
                width: MediaQuery.of(context).size.width * 0.80,
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Email
                        TextFormField(
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
                              return "Enter email correctly";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // _authData['email'] = value;
                          },
                        ),
                        //Password
                        TextFormField(
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
                                  textStyle:
                                  TextStyle(fontWeight: FontWeight.bold))),
                          onPressed: () {
                            // _submit();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.green,
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
