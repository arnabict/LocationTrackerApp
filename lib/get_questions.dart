import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracker/SignUpSignIn/sign_in.dart';
import 'package:location_tracker/google_map.dart';
import 'package:location_tracker/show_info.dart';

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
  bool submissionColor = false;
  bool submissionStatus = false;
  bool validate = false;

  // final TextEditingController ansController = TextEditingController();

  // Widget ansTextField() {
  //   final TextEditingController ansController = TextEditingController();
  //   answerControllers.add(ansController);
  //   return TextField(
  //     controller: ansController,
  //     maxLines: 2,
  //     keyboardType: TextInputType.multiline,
  //     style: GoogleFonts.lato(fontSize: 18, color: Colors.black),
  //     decoration: InputDecoration(
  //         // errorText: validateAnswers
  //         //     ? "Please answer the question"
  //         //     : null,
  //         filled: true,
  //         fillColor: Colors.white,
  //         contentPadding: const EdgeInsets.all(10.0),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Color(0xff004080), width: 3.0),
  //           borderRadius: BorderRadius.circular(5),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //             borderSide: BorderSide(color: Color(0xff004080), width: 3.0),
  //             borderRadius: BorderRadius.circular(5))),
  //   );
  // }

  // bool validateAnswers = false;
  // var validationVar;

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
    });

    if (response.statusCode == 200) {
      // print(myQuestionList);
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
        // 'token': accessToken,
      }),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Widget nextButton() {
    if (myQuestionList != null) {
      return FlatButton(
        color: Colors.green,
        child: Row(
          children: [
            Text("NEXT", style: GoogleFonts.pacifico(color: Colors.white)),
            SizedBox(width: 5.0),
            Icon(Icons.navigate_next)
          ],
        ),
        textColor: Colors.white,
        onPressed: () {
          // print(textEditingController);
          setState(() {
            Navigator.of(context).pushReplacementNamed(MyMap.routeName);
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
      content: const Text("Current answer submitted"),
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
              gradient: LinearGradient(
                  colors: [
                Colors.white,
                Colors.blueGrey,
              ],
                  stops: [
                0.0,
                1.0
              ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  tileMode: TileMode.repeated)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: Text(
                      "ANSWER ALL THE QUESTIONS",
                      style: GoogleFonts.mcLaren(
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
                      stringListReturnedFromApiCall.forEach((str) {
                        var textEditingController =
                            TextEditingController(text: str);
                        textEditingControllers.putIfAbsent(
                            str, () => textEditingController);
                        textEditingController.clear();
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
                      });
                      // print(stringListReturnedFromApiCall);
                      // answerControllers = [
                      //   for (int i = 0; i < myQuestionList.length; i++)
                      //     TextEditingController()
                      // ];
                      // print(myQuestionList[index]["name"].runtimeType);
                      // answerControllers
                      //     .map((e) => print(answerControllers.indexOf(e)))
                      //     .toList();
                      // collectiveIds = myQuestionList[index]["id"];
                      // collectiveAns = answerControllers[index].text;
                      // parsedJsonId.add(myQuestionList[index]["id"]);
                      // print(myQuestionList[index]["id"].runtimeType);
                      // print(answerControllers[index].text.runtimeType);
                      // parsedJsonId = [myQuestionList[index]["id"]];
                      // parsedJsonId[myQuestionList.length] = myQuestionList[index]["id"];
                      // print(parsedJsonId);
                      // parsedJsonAnswers.add(answerControllers[index].text);
                      // print(parsedJsonAnswers);
                      // validationVar = answerControllers[index].text.isEmpty
                      //     ? validateAnswers = true
                      //     : validateAnswers = false;
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
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  myQuestionList[index]["name"],
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      textStyle: TextStyle(fontSize: 16)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Column(
                                children: [
                                  Column(
                                    children: textFields,
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.teal),
                                  child: Text("Submit Here",
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 14))),
                                  onPressed: () {
                                    var currentId = myQuestionList[index]["id"];
                                    var currentText;
                                    stringListReturnedFromApiCall
                                        .forEach((element) {
                                      currentText =
                                          textEditingControllers[element].text;
                                      setState(() {
                                        currentText.isEmpty
                                            ? validate = true
                                            : validate = false;
                                      });
                                    });
                                    print(currentId);
                                    print(currentText);
                                    setState(() {
                                      futureSubmitAnswers = createSubmitAnswers(
                                          myUserId, currentId, currentText);
                                      futureSubmitAnswers.then(
                                          (value) => showSnackBar(context));
                                    });
                                  })
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
