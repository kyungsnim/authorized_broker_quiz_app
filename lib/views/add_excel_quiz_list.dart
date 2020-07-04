import 'dart:typed_data';

import 'package:authorized_broker_quiz_app/services/database.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class AddExcelQuizList extends StatefulWidget {
  @override
  _AddExcelQuizListState createState() => _AddExcelQuizListState();
}

class _AddExcelQuizListState extends State<AddExcelQuizList> {
  Future<Directory> _tempDir;

  String quizId,
      question,
      option1,
      option2,
      option3,
      option4,
      option5,
      hint,
      hintImg,
      whenDid,
      fromWho,
      createDt,
      updateDt,
      questionImg;
  bool _isLoading = false;
  DatabaseService databaseService = new DatabaseService();

  @override
  initState() {
    super.initState();
  }

  uploadQuizData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
        "hint": hint,
        "whenDid": whenDid,
        "fromWho": fromWho,
        "createDt": createDt,
        "updateDt": updateDt,
        "questionImg": questionImg,
      };
      await databaseService
          .addQuestionData(questionMap, quizId)
          .then((value) => setState(() => _isLoading = false));
    } catch (e) {
      print(e.toString());
    }
  }

  uploadMockExamQuizData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> questionMap = {
        "question": question,
        "questionImg": questionImg,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
        "hint": hint,
        "hintImg": hintImg,
        "whenDid": whenDid,
        "fromWho": fromWho,
        "createDt": createDt,
        "updateDt": updateDt,
      };
      await databaseService
          .addMockExamQuestionData(questionMap, quizId)
          .then((value) => setState(() => _isLoading = false));
    } catch (e) {
      print(e.toString());
    }
  }

  importExcelData() async {
//    print("_appDir : ${_appDir.}");
    var file = "../../excel/quizDocuments_20200615.xlsx";
//    var file = "../excel/quizDocuments_20200615.xlsx";
//    var file = "Users/mac/quizDocuments.xlsx";
    var bytes = File(file).readAsBytesSync();
//    var excel = Excel.decodeBytes(bytes, update: true);
    var excel = Excel.decodeBytes(bytes);

    // 나는 sheet1의 데이터만 볼 것이니..
    for (var table in excel.tables.keys) {
      if (table.toString() == "Sheet2" || table.toString() == "Sheet3") {
        continue;
      }
      for (var row in excel.tables[table].rows) {
        List<dynamic> data = row.toList();
        if (data[0] == "구분") {
          continue;
        }
        // print(data);

        quizId = data[1].toString();
        question = data[2].toString();
        questionImg = data[3].toString();
        option1 = data[4].toString();
        option2 = data[5].toString();
        option3 = data[6].toString();
        option4 = data[7].toString();
        hint = data[8].toString();
        whenDid = data[9].toString();
        fromWho = data[10].toString();
        createDt = data[11].toString();
        updateDt = data[12].toString();

        uploadQuizData();
      }
    }
  }


  importMockExamExcelData() async {
//    print("_appDir : ${_appDir.}");
//    ByteData data = await rootBundle.load("assets/Declaratieformulier.xlsx");
//// This would be your equivalent bytes variable
//    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//
//// You can also copy it to the device when the app starts
//    final directory = await getApplicationDocumentsDirectory();
//    String filePath = join(directory, "Declaratieformulier.xlsx");
//    await File(filePath).writeAsBytes(bytes);

//    var file = await rootBundle.load("assets/quizDocuments_20200617.xlsx");
//    var file = "../excel/quizDocuments_20200615.xlsx";
//    var file = "Users/mac/quizDocuments.xlsx";
//    var bytes = File(file).readAsBytesSync();
//    var excel = Excel.decodeBytes(bytes, update: true);

    ByteData data = await rootBundle.load("assets/quizDocuments_20200617.xlsx");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//    var excel = Excel.decodeBytes(bytes, update: true);
    var excel = Excel.decodeBytes(bytes);

    // 나는 sheet1의 데이터만 볼 것이니..
    for (var table in excel.tables.keys) {
      if (table.toString() == "Sheet2" || table.toString() == "Sheet3") {
        continue;
      }
      for (var row in excel.tables[table].rows) {
        List<dynamic> data = row.toList();
        if (data[0] == "구분") {
          continue;
        }

        quizId = data[1].toString();
        question = data[2].toString();
        questionImg = data[3].toString();
        option1 = data[4].toString();
        option2 = data[5].toString();
        option3 = data[6].toString();
        option4 = data[7].toString();
        hint = data[8].toString();
        hintImg = data[9].toString();
        whenDid = data[10].toString();
        fromWho = data[11].toString();
        createDt = data[12].toString();
        updateDt = data[13].toString();

        uploadMockExamQuizData();
      }
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
        iconTheme: IconThemeData.fallback(), // 뒤로가기
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.indigo,
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("only administrator",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  SizedBox(
                    height: 15,
                  ),
//                  pathText(),
                  InkWell(
                    onTap: () {
                      // 여기서 엑셀파일 열어서 데이터들 가져와서 for문 돌리자
                      importExcelData();
                    },
                    child: blueButton(
                      context: context,
                      text: 'Add Questions',
                      buttonWidth: MediaQuery.of(context).size.width * 0.44,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      // 여기서 엑셀파일 열어서 데이터들 가져와서 for문 돌리자
                      importMockExamExcelData();
                    },
                    child: blueButton(
                      context: context,
                      text: 'Add Mock Exam Questions',
                      buttonWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget pathText() {
    FutureBuilder<Directory>(
      future: _tempDir,
      builder: (BuildContext context, AsyncSnapshot<Directory> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Text('path: ${snapshot.data.path}');
          } else {
            return const Text('path unavailable');
          }
        }
      },
    );
  }
}
