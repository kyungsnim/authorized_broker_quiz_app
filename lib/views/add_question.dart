import 'package:authorized_broker_quiz_app/services/database.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddQuestion extends StatefulWidget {
  final String quizId; // 전 화면에서 넘어올 때 quizId 받아와서 그걸로 firestore에 저장하기 위함
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  String question,
      option1,
      option2,
      option3,
      option4,
      hint,
      whenDid,
      questionImg;
  bool _isLoading = false;
  DatabaseService databaseService = new DatabaseService();
  TextEditingController questionController = new TextEditingController();
  TextEditingController option1Controller = new TextEditingController();
  TextEditingController option2Controller = new TextEditingController();
  TextEditingController option3Controller = new TextEditingController();
  TextEditingController option4Controller = new TextEditingController();
  TextEditingController hintController = new TextEditingController();
  TextEditingController whenDidController = new TextEditingController();

  uploadQuizData() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        Map<String, Object> questionMap = {
          "question": question,
          "option1": option1,
          "option2": option2,
          "option3": option3,
          "option4": option4,
          "hint": hint,
          "whenDid": whenDid,
          "questionImg": questionImg,
        };

        await databaseService
            .addQuestionData(questionMap, widget.quizId)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Container(),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.indigo,
                ),
              )
            : Form(
                key: _formKey,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 25, 25, 5),
                      child: TextFormField(
                        controller: questionController,
                        cursorColor: Colors.indigo,
                        validator: (val) {
                          return val.isEmpty ? 'Enter question' : null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                // underline 색상 변경
                                borderSide: BorderSide(color: Colors.indigo)),
                            icon: Icon(Icons.mode_edit, color: Colors.indigo),
                            hintText: 'Question'),
                        onChanged: (val) {
                          question = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        controller: option1Controller,
                        cursorColor: Colors.indigo,
                        validator: (val) {
                          return val.isEmpty ? 'Enter option1' : null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                // underline 색상 변경
                                borderSide: BorderSide(color: Colors.indigo)),
                            icon: Icon(Icons.arrow_right, color: Colors.indigo),
                            hintText: 'Option1 (Correct answer)'),
                        onChanged: (val) {
                          option1 = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        controller: option2Controller,
                        cursorColor: Colors.indigo,
                        validator: (val) {
                          return val.isEmpty ? 'Enter option2' : null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                // underline 색상 변경
                                borderSide: BorderSide(color: Colors.indigo)),
                            icon: Icon(Icons.arrow_right, color: Colors.indigo),
                            hintText: 'Option2'),
                        onChanged: (val) {
                          option2 = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        controller: option3Controller,
                        cursorColor: Colors.indigo,
                        validator: (val) {
                          return val.isEmpty ? 'Enter option3' : null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                // underline 색상 변경
                                borderSide: BorderSide(color: Colors.indigo)),
                            icon: Icon(Icons.arrow_right, color: Colors.indigo),
                            hintText: 'Option3'),
                        onChanged: (val) {
                          option3 = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        controller: option4Controller,
                        cursorColor: Colors.indigo,
                        validator: (val) {
                          return val.isEmpty ? 'Enter option4' : null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                // underline 색상 변경
                                borderSide: BorderSide(color: Colors.indigo)),
                            icon: Icon(Icons.arrow_right, color: Colors.indigo),
                            hintText: 'Option4'),
                        onChanged: (val) {
                          option4 = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        controller: hintController,
                        cursorColor: Colors.indigo,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                // underline 색상 변경
                                borderSide: BorderSide(color: Colors.indigo)),
                            icon: Icon(Icons.arrow_right, color: Colors.indigo),
                            hintText: 'hint'),
                        onChanged: (val) {
                          hint = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: TextFormField(
                        controller: whenDidController,
                        cursorColor: Colors.indigo,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                // underline 색상 변경
                                borderSide: BorderSide(color: Colors.indigo)),
                            icon: Icon(Icons.arrow_right, color: Colors.indigo),
                            hintText: 'When did came?'),
                        onChanged: (val) {
                          whenDid = val;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: blueButton(
                            context: context,
                            text: 'Submit',
                            buttonWidth:
                                MediaQuery.of(context).size.width * 0.44,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            uploadQuizData();
                          },
                          child: blueButton(
                            context: context,
                            text: 'Add Questions',
                            buttonWidth:
                                MediaQuery.of(context).size.width * 0.44,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ));
  }
}
