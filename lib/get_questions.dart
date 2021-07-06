import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracker/LoadingScreens/loading_screen_get_map.dart';
import 'package:location_tracker/home_screen.dart';

class GetQuestions extends StatefulWidget {
  GetQuestions({Key key}) : super(key: key);
  static const routeName = '/get_questions';

  @override
  _GetQuestionsState createState() => _GetQuestionsState();
}

class QuestionList {
  QuestionList({
    this.id,
    this.type,
    this.name,
    this.details,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int type;
  String name;
  dynamic details;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  factory QuestionList.fromJson(Map<String, dynamic> json) => QuestionList(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        details: json["details"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "details": details,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class _GetQuestionsState extends State<GetQuestions> {
  //Variables
  List myQuestionList;
  Future<QuestionList> futureQuestionList;
  Future futureSubmitAnswers;
  bool validate = false;

  // var dropDownValue;
  var selectedOption;

  @override
  void initState() {
    super.initState();
    futureQuestionList = createQuestionRequest();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<QuestionList> createQuestionRequest() async {
    final http.Response response = await http.get(
      Uri.parse("https://location.timetechri.co.uk/api/location/question/list"),
    );

    this.setState(() {
      myQuestionList = json.decode(response.body);
      print(myQuestionList);
    });

    if (response.statusCode == 200) {
      return QuestionList.fromJson(myQuestionList[0]);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future createSubmitAnswers(
    int userId,
    int questionId,
    String questionAns,
  ) async {
    final http.Response response = await http.post(
      Uri.parse(
          "https://location.timetechri.co.uk/api/location/question/submit"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'user_question_id': userId,
        'question_id': questionId,
        'question_ans': questionAns,
      }),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      return (json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Widget nextButton() {
    if (myQuestionList != null) {
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
          // print(textEditingController);
          setState(() {
            Navigator.of(context)
                .pushReplacementNamed(LoadingScreenGetMap.routeName);
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

  void showSnackBar(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: const Text("Current answer submitted. Answer next question."),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Questions",
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
              gradient: LinearGradient(colors: [
            Colors.white,
            Colors.blueGrey,
          ], tileMode: TileMode.repeated)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: Text(
                      "ANSWER ALL THE QUESTIONS",
                      style: GoogleFonts.comicNeue(
                          textStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    )),
                ListView.builder(
                    padding: EdgeInsets.all(20.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount:
                        myQuestionList == null ? 0 : myQuestionList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var stringListReturnedFromApiCall = [
                        myQuestionList[index]["name"]
                      ];
                      Map<dynamic, TextEditingController>
                          textEditingControllers = {};
                      var textFields = <TextField>[];
                      var dropDownOptionsList = [
                        myQuestionList[index]["option1"],
                        myQuestionList[index]["option2"],
                        myQuestionList[index]["option3"],
                        myQuestionList[index]["option4"]
                      ];
                      var dropDownList = <Column>[];
                      var radioButtons = <Column>[];
                      // var selectedOption;
                      var dropDownValue;
                      stringListReturnedFromApiCall.forEach((str) {
                        var textEditingController =
                            TextEditingController(text: str);
                        textEditingControllers.putIfAbsent(
                            str, () => textEditingController);
                        textEditingController.clear();
                        if (myQuestionList[index]["type"] == 1) {
                          return textFields.add(TextField(
                            controller: textEditingController,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            style: GoogleFonts.lato(
                                fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                                errorText: validate
                                    ? "Answers can't be empty. Write the answers correctly."
                                    : null,
                                hintText: "Enter your answer here",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    textEditingController.clear();
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
                          ));
                        } else if (myQuestionList[index]["type"] == 2) {
                          return dropDownList.add(Column(
                            children: <Widget>[
                              // ListView.builder(
                              //   shrinkWrap: true,
                              //   itemCount: 5,
                              //   itemBuilder:
                              //       (BuildContext context, int index) {
                              //     for (int i = 0; i < myQuestionList.length; i++) {
                              //       selectedItemValue.add("Select an option");
                              //       return DropdownButton(
                              //         value:
                              //             selectedItemValue[index].toString().isNotEmpty ? selectedItemValue[index].toString(): null,
                              //         onChanged: (value) {
                              //           selectedItemValue[index] = value;
                              //           setState(() {});
                              //         },
                              //         items: dropDownOptionsList.map((item) {
                              //           return DropdownMenuItem(
                              //             child: Center(
                              //               child: Text(
                              //                 item,
                              //                 textAlign: TextAlign.center,
                              //                 style: GoogleFonts.lato(),
                              //               ),
                              //             ),
                              //             value: item.toString(),
                              //           );
                              //         }).toList(),
                              //       );
                              //     }
                              //     return null;
                              //   },
                              // ),
                              Container(
                                decoration: ShapeDecoration(
                                  //color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Color(0xff004080),
                                          width: 3.0,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Center(
                                      child: Text(
                                        "Select an option",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    value: dropDownValue,
                                    onChanged: (value) {
                                      setState(() {
                                        dropDownValue = value;
                                        print(dropDownValue);
                                      });
                                    },
                                    items: dropDownOptionsList.map((item) {
                                      return DropdownMenuItem(
                                        child: Center(
                                          child: Text(
                                            item,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(),
                                          ),
                                        ),
                                        value: item.toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ));
                        } else if (myQuestionList[index]["type"] == 3) {
                          return radioButtons.add(Column(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    activeColor: Color(0xff004080),
                                    value: myQuestionList[index]["option1"],
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value;
                                        print(selectedOption);
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      myQuestionList[index]["option1"],
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    activeColor: Color(0xff004080),
                                    value: myQuestionList[index]["option2"],
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value;
                                        print(selectedOption);
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      myQuestionList[index]["option2"],
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    activeColor: Color(0xff004080),
                                    value: myQuestionList[index]["option3"],
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value;
                                        print(selectedOption);
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      myQuestionList[index]["option3"],
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    activeColor: Color(0xff004080),
                                    value: myQuestionList[index]["option4"],
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value;
                                        print(selectedOption);
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      myQuestionList[index]["option4"],
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ));
                        }
                      });
                      return Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              gradient: LinearGradient(colors: [
                                Colors.blueGrey,
                                Colors.white,
                              ])),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  myQuestionList[index]["name"],
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Column(
                                children: [
                                  Column(
                                    children: textFields,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Column(
                                    children: dropDownList,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Column(
                                    children: radioButtons,
                                  )
                                ],
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xff004080)),
                                  child: Text("Submit Here",
                                      style: GoogleFonts.mcLaren(
                                          textStyle: TextStyle(fontSize: 14))),
                                  onPressed: () {
                                    var currentId = myQuestionList[index]["id"];
                                    if (myQuestionList[index]["type"] == 1) {
                                      var currentText;
                                      stringListReturnedFromApiCall
                                          .forEach((element) {
                                        currentText =
                                            textEditingControllers[element]
                                                .text;
                                        setState(() {
                                          currentText.isEmpty
                                              ? validate = true
                                              : validate = false;
                                        });
                                      });
                                      print(currentId);
                                      print(currentText);
                                      setState(() {
                                        futureSubmitAnswers =
                                            createSubmitAnswers(myUserId,
                                                currentId, currentText);
                                        futureSubmitAnswers.then(
                                            (value) => showSnackBar(context));
                                      });
                                    } else if (myQuestionList[index]["type"] ==
                                        2) {
                                      var currentId =
                                          myQuestionList[index]["id"];
                                      var currentSelected;
                                      stringListReturnedFromApiCall
                                          .forEach((element) {
                                        currentSelected = dropDownValue;
                                        print(currentId);
                                        print(currentSelected);
                                        setState(() {
                                          futureSubmitAnswers =
                                              createSubmitAnswers(
                                            myUserId,
                                            currentId,
                                            currentSelected,
                                          );
                                          futureSubmitAnswers.then(
                                              (value) => showSnackBar(context));
                                        });
                                      });
                                    } else if (myQuestionList[index]["type"] ==
                                        3) {
                                      var currentId =
                                          myQuestionList[index]["id"];
                                      var currentOption;
                                      stringListReturnedFromApiCall
                                          .forEach((element) {
                                        currentOption = selectedOption;
                                        setState(() {});
                                      });
                                      print(currentId);
                                      print(currentOption);
                                      setState(() {
                                        futureSubmitAnswers =
                                            createSubmitAnswers(myUserId,
                                                currentId, currentOption);
                                        futureSubmitAnswers.then(
                                            (value) => showSnackBar(context));
                                      });
                                    }
                                  }),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }
}
