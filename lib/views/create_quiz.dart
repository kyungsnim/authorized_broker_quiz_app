import 'package:authorized_broker_quiz_app/services/database.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'add_question.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  String quizImgUrl, quizTitle, quizDesc, quizId;
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;

  createQuizOnline() async {
    try {
      if (_formKey.currentState.validate()) {
        quizId = randomAlphaNumeric(16); // 랜덤알파벳상수 16자 생성
        Map<String, String> quizMap = {
          "quizId": quizId,
          "quizImgUrl": quizImgUrl,
          "quizTitle": quizTitle,
          "quizDesc": quizDesc,
        };

        setState(() {
          _isLoading = true;
        });
        await databaseService.addQuizData(quizMap, quizId).then((value) {
          setState(() {
            _isLoading = false;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
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
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0.0,
          leading: Container(),
//          iconTheme: IconThemeData(color: Colors.black54),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.indigo,
                ),
              )
            : Form(
                key: _formKey, // form 사용할 땐 꼭 키 만들어줘야 함
                child: Container(
                    child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 25, 25, 5),
                        child: TextFormField(
                          cursorColor: Colors.indigo,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  // underline 색상 변경
                                  borderSide: BorderSide(color: Colors.indigo)),
                              icon: Icon(Icons.image, color: Colors.indigo),
                              hintText: 'Quiz Image Url'),
                          onChanged: (val) {
                            quizImgUrl = val;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                        child: TextFormField(
                          cursorColor: Colors.indigo,
                          validator: (val) {
                            return val.isEmpty
                                ? 'Enter correct quiz title'
                                : null;
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  // underline 색상 변경
                                  borderSide: BorderSide(color: Colors.indigo)),
                              icon: Icon(Icons.title, color: Colors.indigo),
                              hintText: 'Quiz Title'),
                          onChanged: (val) {
                            quizTitle = val;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 5, 25, 25),
                        child: TextFormField(
                          cursorColor: Colors.indigo,
                          validator: (val) {
                            return val.isEmpty
                                ? 'Enter correct quiz description'
                                : null;
                          },
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  // underline 색상 변경
                                  borderSide: BorderSide(color: Colors.indigo)),
                              focusColor: Colors.indigo,
                              icon: Icon(
                                Icons.description,
                                color: Colors.indigo,
                              ),
                              hintText: 'Quiz Description'),
                          onChanged: (val) {
                            quizDesc = val;
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          createQuizOnline();
                        },
                        child:
                            blueButton(context: context, text: 'Create Quiz'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )),
              ));
  }
}
