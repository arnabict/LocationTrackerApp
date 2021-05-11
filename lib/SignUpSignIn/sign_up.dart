import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _passwordController = TextEditingController();
  var genders;
  var _currentSelectedValue;
  // Map<String, String> _authData = {
  //   'email': '',
  //   'password': '',
  // };

  //POST

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
                      style: GoogleFonts.mcLaren(
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  value: _currentSelectedValue,
                  onChanged: (String newValue) {
                    state.didChange(newValue);
                    setState(() {
                      _currentSelectedValue = newValue;
                    });
                  },
                  items:
                      <String>["Male", "Female", "Other"].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        child: Text(
                          value,
                          style: GoogleFonts.lato(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15.0),
            //   child: Text(
            //     state.hasError ? state.errorText : '',
            //     style:
            //         GoogleFonts.mcLaren(color: Colors.red[800], fontSize: 12),
            //   ),
            // )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up", style: GoogleFonts.lato()),
        actions: [
          FlatButton(
            child: Row(
              children: [
                Text("Login", style: GoogleFonts.lato()),
                SizedBox(width: 5.0),
                Icon(Icons.login)
              ],
            ),
            textColor: Colors.white,
            onPressed: () {
              // Navigator.of(context).pushReplacementNamed(Login.routeName);
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
                width: MediaQuery.of(context).size.width * 0.80,
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //First Name
                        TextFormField(
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
                          decoration: InputDecoration(
                              labelText: "Last Name",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.mcLaren(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your last name";
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                        SizedBox(height: 10.0,),
                        //Gender
                        _dropdownButtonFormField(),
                        //Mobile Number
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Mobile Number",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.lato(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Enter your mobile number";
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                        //Profession
                        TextFormField(
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
                          decoration: InputDecoration(
                              labelText: "Address",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.lato(),
                          onSaved: (value) {},
                        ),
                        //Password
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: GoogleFonts.mcLaren(
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          obscureText: true,
                          controller: _passwordController,
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
                                value != _passwordController.text) {
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
                          child: Text("REGISTER",
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
