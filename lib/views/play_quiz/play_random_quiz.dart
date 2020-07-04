import 'dart:math';

import 'package:authorized_broker_quiz_app/models/question_model.dart';
import 'package:authorized_broker_quiz_app/services/database.dart';
import 'package:authorized_broker_quiz_app/widgets/quiz_play_widgets.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../home.dart';
//import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';

int total = 0;
List<bool> correct;
List<bool> incorrect;
int _correct = 0;
int _correct1 = 0;
int _correct3 = 0;
int _correct4 = 0;
int totalQuizLength = part1QuizLength + part3QuizLength + part4QuizLength;
int part1QuizLength = 10;
int part3QuizLength = 10;
int part4QuizLength = 30;
var part1IndexList;
var part3IndexList;
var part4IndexList;
var optionShuffleIndexList;
var submitCnt; // 총 제출 횟수
var correctCnt; // 정답 횟수

bool isViewAnswer = false; // 정답보기 모드
bool isReset = false; // 정답본 후에 다시 풀기 모드

class PlayRandomQuiz extends StatefulWidget {
  @override
  _PlayRandomQuizState createState() => _PlayRandomQuizState();
}

class _PlayRandomQuizState extends State<PlayRandomQuiz> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionSnapshot;
  QuerySnapshot questionSnapshot1;
  QuerySnapshot questionSnapshot3;
  QuerySnapshot questionSnapshot4;
  bool isLoading = true;

  String part1QuizId = "JRcTMidvFKyG1zN2v5tT";
  String part3QuizId = "VIpWAqrKDrgIhDf8CodX";
  String part4QuizId = "trfj9a5i1KKUw4hzCOH0";
  var randomIndex = new Random();

  @override
  void initState() {
    correct = List.generate(totalQuizLength, (index) => false);
    incorrect = List.generate(totalQuizLength, (index) => false);
    isLoading = true;
    total = totalQuizLength;
    if (!isViewAnswer) {
      databaseService.getRandomQuizData(part1QuizId).then((val) {
        setState(() {
          questionSnapshot1 = val;
        });
      });
      databaseService.getRandomQuizData(part3QuizId).then((val) {
        setState(() {
          questionSnapshot3 = val;
        });
      });
      databaseService.getRandomQuizData(part4QuizId).then((val) {
        setState(() {
          questionSnapshot4 = val;
          isLoading = false;
        });
      });
    }
    super.initState();
  }

  QuestionModel getQuestionModelFromDataSnapshot(
      DocumentSnapshot questionSnapshot, int index) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot.data["question"];
    List<String> options = [
      questionSnapshot.data["option1"],
      questionSnapshot.data["option2"],
      questionSnapshot.data["option3"],
      questionSnapshot.data["option4"],
    ];
    // optionsShuffleIndexList에 랜덤 보기 담아놓고 options 불러올때 랜덤으로 부르기
    questionModel.option1 = options[optionShuffleIndexList[index][0]];
    questionModel.option2 = options[optionShuffleIndexList[index][1]];
    questionModel.option3 = options[optionShuffleIndexList[index][2]];
    questionModel.option4 = options[optionShuffleIndexList[index][3]];
    questionModel.correctOption = questionSnapshot.data["option1"];
    questionModel.hint = questionSnapshot.data["hint"];
    if (questionSnapshot.data["hintImg"] != null &&
        questionSnapshot.data["hintImg"] != "" &&
        questionSnapshot.data["hintImg"] != "null") {
      questionModel.hintImg = questionSnapshot.data["hintImg"];
    } else {
      questionModel.hintImg = "";
    }
    if (questionSnapshot.data["questionImg"] != null &&
        questionSnapshot.data["questionImg"] != "" &&
        questionSnapshot.data["questionImg"] != "null") {
      questionModel.questionImg = questionSnapshot.data["questionImg"];
    } else {
      questionModel.questionImg = "";
    }
    if (questionSnapshot.data["whenDid"] != null &&
        questionSnapshot.data["whenDid"] != "" &&
        questionSnapshot.data["whenDid"] != "null") {
      questionModel.whenDid = "[${questionSnapshot.data["whenDid"]}]";
    } else {
      questionModel.whenDid = "";
    }
    if (questionSnapshot.data["fromWho"] != null &&
        questionSnapshot.data["fromWho"] != "" &&
        questionSnapshot.data["fromWho"] != "null") {
      questionModel.fromWho = " 출처: ${questionSnapshot.data["fromWho"]}";
    } else {
      questionModel.fromWho = "";
    }
    if (questionSnapshot.data["correctCnt"] != 0 &&
        questionSnapshot.data["correctCnt"] != null) {
      questionModel.correctCnt = questionSnapshot.data["correctCnt"];
    } else {
      questionModel.correctCnt = 0;
    }
    if (questionSnapshot.data["submitCnt"] != 0 &&
        questionSnapshot.data["submitCnt"] != null) {
      questionModel.submitCnt = questionSnapshot.data["submitCnt"];
    } else {
      questionModel.submitCnt = 0;
    }
    questionModel.answered = false;
    return questionModel;
  }

  Widget resultRichText(String part, double fontSize1, int correctPart,
      int partLength, double fontSize2) {
    return Column(
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: part,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize1,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '$correctPart',
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize2,
                ),
              ),
              TextSpan(
                  text: ' / $partLength',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize2,
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(right: 10),
          backgroundColor: Colors.white,
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Stack(alignment: Alignment.center, children: <Widget>[
            ClipRRect(
              // 이미지 테두리반경 등 설정시 필요
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                    imageUrl:
                        "https://images.unsplash.com/photo-1510925751334-0fe90906839b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.cover),
//              child: PinchZoomImage(
//                image: CachedNetworkImage(
//                    imageUrl:
//                    "https://images.unsplash.com/photo-1510925751334-0fe90906839b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
//                    width: MediaQuery.of(context).size.width * 1,
//                    height: MediaQuery.of(context).size.height * 0.4,
//                    fit: BoxFit.cover),
//                zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
//                hideStatusBarWhileZooming: true,
//              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black54, // 스택이기 때문에 이미지 위에 올 것임
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Your score is\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$_correct',
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 60,
                          ),
                        ),
                        TextSpan(
                            text: ' / $total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 60,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  resultRichText('Part1\t', 30, _correct1, part1QuizLength, 25),
                  resultRichText('Part3\t', 30, _correct3, part3QuizLength, 25),
                  resultRichText('Part4\t', 30, _correct4, part4QuizLength, 25),
                ],
              ),
            ),
          ]),
          actions: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      // 여기서 뭔가... 정답보기 상태로 바꾸어주면
                      // 팝업 닫히면서 정답, 해설이 다 보이게 하는건 안되려나?
                      setState(() {
                        isViewAnswer = true; // 정답보기 모드
                      });
                      Navigator.pop(context);
                    },
                    child: blueButton(
                        context: context,
                        text: "정답&풀이 보기",
                        buttonWidth: MediaQuery.of(context).size.width * 0.5),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: blueButton(
                          context: context,
                          text: "홈으로 이동",
                          buttonWidth:
                              MediaQuery.of(context).size.width * 0.5)),
                ]),
          ],
        );
      },
    );
  }

  // back 버튼 클릭시 종료할건지 물어보는
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("홈으로 이동하시겠습니까?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "예",
                  style: TextStyle(fontSize: 18, color: Colors.indigo),
                ),
                onPressed: () {
                  setState(() {
                    isViewAnswer = false;
                  });
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text(
                  "아니요",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget makeRandomQuiz() {
    // 정답 화면 호출시 번호변경 없음
//    if (!isViewAnswer && !isReset) { // 정답보기 후 다시풀기 기능 잠시 보류
    if (!isViewAnswer) {
      // 각 파트의 총 문제수 내에서 랜덤으로 번호 추출 (중복index 제거 로직 추가, 2020-06-06)
      part1IndexList = new List<int>(part1QuizLength);
      part3IndexList = new List<int>(part3QuizLength);
      part4IndexList = new List<int>(part4QuizLength);
      optionShuffleIndexList = new List<List>(totalQuizLength);

      for (int insertIndex = 0; insertIndex < part1QuizLength; insertIndex++) {
        part1IndexList[insertIndex] =
            randomIndex.nextInt(questionSnapshot1.documents.length);
        for (int searchIndex = 0; searchIndex < insertIndex; searchIndex++) {
          if (part1IndexList[searchIndex] == part1IndexList[insertIndex]) {
            insertIndex--;
            break;
          }
        }
      }
      for (int insertIndex = 0; insertIndex < part3QuizLength; insertIndex++) {
        part3IndexList[insertIndex] =
            randomIndex.nextInt(questionSnapshot3.documents.length);
        for (int searchIndex = 0; searchIndex < insertIndex; searchIndex++) {
          if (part3IndexList[searchIndex] == part3IndexList[insertIndex]) {
            insertIndex--;
            break;
          }
        }
      }
      for (int insertIndex = 0; insertIndex < part4QuizLength; insertIndex++) {
        part4IndexList[insertIndex] =
            randomIndex.nextInt(questionSnapshot4.documents.length);
        for (int searchIndex = 0; searchIndex < insertIndex; searchIndex++) {
          if (part4IndexList[searchIndex] == part4IndexList[insertIndex]) {
            insertIndex--;
            break;
          }
        }
      }
      // 보기 순서 바꿔줄 때 쓰이는 용도
      for (int insertIndex = 0; insertIndex < totalQuizLength; insertIndex++) {
        optionShuffleIndexList[insertIndex] = new List<int>(4);
        optionShuffleIndexList[insertIndex][0] = 0;
        optionShuffleIndexList[insertIndex][1] = 1;
        optionShuffleIndexList[insertIndex][2] = 2;
        optionShuffleIndexList[insertIndex][3] = 3;

        optionShuffleIndexList[insertIndex].shuffle();
      }
    }

    return Container(
        child: Scrollbar(
      // 문제 리스트에 스크롤 보이게
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          // The getter 'documents' was called on null. 오류 남
          ListView.builder(
            primary: true,
            padding: EdgeInsets.symmetric(horizontal: 24),
            shrinkWrap: true,
            // 'visible' was called on null 방지
            physics: ClampingScrollPhysics(),
            // 'visible' was called on null 방지
            itemCount: totalQuizLength,
            itemBuilder: (context, index) {
              if (index < part1QuizLength) {
                // Part1
                questionSnapshot = questionSnapshot1;
                return QuizPlayTile(
                    questionModel: getQuestionModelFromDataSnapshot(
                        questionSnapshot.documents[part1IndexList[index]],
                        index),
                    index: index);
              } else if (index < part1QuizLength + part3QuizLength) {
                // Part3
                questionSnapshot = questionSnapshot3;
                return QuizPlayTile(
                    questionModel: getQuestionModelFromDataSnapshot(
                        questionSnapshot
                            .documents[part3IndexList[index - part1QuizLength]],
                        index),
                    index: index);
              } else {
                // Part4
                questionSnapshot = questionSnapshot4;
                return QuizPlayTile(
                    questionModel: getQuestionModelFromDataSnapshot(
                        questionSnapshot.documents[part4IndexList[
                            index - (part1QuizLength + part3QuizLength)]],
                        index),
                    index: index);
              }
            },
          ),
        ],
      ),
    ));
  }

  // 50문제 다 안풀었는데 제출하려고 할 때
  Future<bool> _onPressedSubmitYn(checkCnt) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: checkCnt == 50
                ? Text("최종 제출하시겠습니까?\n", style: TextStyle(fontSize: 18))
                : RichText(
                    text: TextSpan(
                        text: "최종 제출하시겠습니까?\n모든 문항의 답이 체크되어야\n정답률에 반영됩니다.\n",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: "현재 체크: $checkCnt개, ",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.indigo)),
                          TextSpan(
                              text: "미체크: ${totalQuizLength - checkCnt}개\n",
                              style: TextStyle(fontSize: 18, color: Colors.red))
                        ]),
                  ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "예",
                  style: TextStyle(fontSize: 18, color: Colors.indigo),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
              FlatButton(
                child: Text(
                  "아니요",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ) ??
        false;
  }

  // 10문제 넘게 풀었는지 체크
  Future<bool> _underCntAlert() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:
                Text("10문제 이상 풀어야 제출이 가능합니다.", style: TextStyle(fontSize: 18)),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "예",
                  style: TextStyle(fontSize: 18, color: Colors.indigo),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: appBar(context),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData.fallback(), // 뒤로가기
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.indigo,
                ),
              )
            : questionSnapshot1 == null ||
                    questionSnapshot3 == null ||
                    questionSnapshot4 == null
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.indigo,
                    ),
                  )
                : makeRandomQuiz(),
        floatingActionButton: isViewAnswer
            ? Container()
//              FloatingActionButton( // 정답보기 이후 다시풀기 기능인데 보류
//                backgroundColor: Colors.indigo,
//                child: Icon(Icons.refresh),
//                onPressed: () {
//                  // 다 초기화 시키고 다시 풀도록 동작
//                  setState(() {
//                    isViewAnswer = false;
//                    isReset = true;
//                    correct = List.generate(totalQuizLength, (index) => false);
//                    incorrect = List.generate(totalQuizLength, (index) => false);
//                  });
//                },
//              )
            : FloatingActionButton(
                backgroundColor: Colors.indigo,
                child: Icon(Icons.check),
                onPressed: () async {
                  // 문제 푼 갯수 카운트
                  var cnt = 0;
                  for (int i = 0; i < totalQuizLength; i++) {
                    if (correct[i] || incorrect[i]) {
                      cnt++;
                    }
                  }
                  var submitYn = false; // 50문제 확인용
                  _correct = 0;
                  _correct1 = 0; // 결과화면 Part1 정답개수
                  _correct3 = 0; // 결과화면 Part3 정답개수
                  _correct4 = 0; // 결과화면 Part4 정답개수

                  // 10문제 미만으로 풀고 제출하면 alert
                  if (cnt < 10) {
                    _underCntAlert();
                  } else {
                    // 최종 제출확인 팝업 (50개 다 풀었으면 db에 결과 반영, 다 안풀었으면 점수만 공개)
                    submitYn = await _onPressedSubmitYn(cnt);
                  }

                  // 50문제 다 푼게 맞다면 정답률에 반영하고 결과 보여주자
                  if (submitYn && cnt == totalQuizLength) {
                    try {
                      // 정답 체크한 것에 한해 정답률에 반영하기!! 머리 빠개지는줄 알았네
                      for (int i = 0; i < correct.length; i++) {
                        // 정답 맞춘 경우
                        if (correct[i] == true) {
                          _correct++;

                          // db에 update할 map 작성하기 (part1)
                          if (i < part1QuizLength) {
                            _correct1++;
                            Map<String, int> resultMap = {
                              // 최초로 푸는 경우(해당 컬럼이 비어있거나 0인 경우)
                              "correctCnt": questionSnapshot1
                                              .documents[part1IndexList[i]]
                                              .data["correctCnt"] ==
                                          null ||
                                      questionSnapshot1
                                              .documents[part1IndexList[i]]
                                              .data["correctCnt"] ==
                                          0
                                  ? 1
                                  : questionSnapshot1
                                          .documents[part1IndexList[i]]
                                          .data["correctCnt"] +
                                      1,
                              "submitCnt": questionSnapshot1
                                              .documents[part1IndexList[i]]
                                              .data["submitCnt"] ==
                                          null ||
                                      questionSnapshot1
                                              .documents[part1IndexList[i]]
                                              .data["submitCnt"] ==
                                          0
                                  ? 1
                                  : questionSnapshot1
                                          .documents[part1IndexList[i]]
                                          .data["submitCnt"] +
                                      1,
                            };
                            databaseService.addResultData(
                                resultMap,
                                part1QuizId,
                                questionSnapshot1
                                    .documents[part1IndexList[i]].documentID);
                          } else if (i < part1QuizLength + part3QuizLength) {
                            // db에 update할 map 작성하기 (part3)
                            _correct3++;
                            Map<String, int> resultMap = {
                              "correctCnt": questionSnapshot3
                                              .documents[part3IndexList[
                                                  i - part1QuizLength]]
                                              .data["correctCnt"] ==
                                          null ||
                                      questionSnapshot3
                                              .documents[part3IndexList[
                                                  i - part1QuizLength]]
                                              .data["correctCnt"] ==
                                          0
                                  ? 1
                                  : questionSnapshot3
                                          .documents[part3IndexList[
                                              i - part1QuizLength]]
                                          .data["correctCnt"] +
                                      1,
                              "submitCnt": questionSnapshot3
                                              .documents[part3IndexList[
                                                  i - part1QuizLength]]
                                              .data["submitCnt"] ==
                                          null ||
                                      questionSnapshot3
                                              .documents[part3IndexList[
                                                  i - part1QuizLength]]
                                              .data["submitCnt"] ==
                                          0
                                  ? 1
                                  : questionSnapshot3
                                          .documents[part3IndexList[
                                              i - part1QuizLength]]
                                          .data["submitCnt"] +
                                      1,
                            };
                            databaseService.addResultData(
                                resultMap,
                                part3QuizId,
                                questionSnapshot3
                                    .documents[
                                        part3IndexList[i - part1QuizLength]]
                                    .documentID);
                          } else if (i < totalQuizLength) {
                            // db에 update할 map 작성하기 (part4)
                            _correct4++;
                            Map<String, int> resultMap = {
                              "correctCnt": questionSnapshot4
                                              .documents[part4IndexList[i -
                                                  (part1QuizLength +
                                                      part3QuizLength)]]
                                              .data["correctCnt"] ==
                                          null ||
                                      questionSnapshot4
                                              .documents[part4IndexList[i -
                                                  (part1QuizLength +
                                                      part3QuizLength)]]
                                              .data["correctCnt"] ==
                                          0
                                  ? 1
                                  : questionSnapshot4
                                          .documents[part4IndexList[i -
                                              (part1QuizLength +
                                                  part3QuizLength)]]
                                          .data["correctCnt"] +
                                      1,
                              "submitCnt": questionSnapshot4
                                              .documents[part4IndexList[i -
                                                  (part1QuizLength +
                                                      part3QuizLength)]]
                                              .data["submitCnt"] ==
                                          null ||
                                      questionSnapshot4
                                              .documents[part4IndexList[i -
                                                  (part1QuizLength +
                                                      part3QuizLength)]]
                                              .data["submitCnt"] ==
                                          0
                                  ? 1
                                  : questionSnapshot4
                                          .documents[part4IndexList[i -
                                              (part1QuizLength +
                                                  part3QuizLength)]]
                                          .data["submitCnt"] +
                                      1,
                            };
                            databaseService.addResultData(
                                resultMap,
                                part4QuizId,
                                questionSnapshot4
                                    .documents[part4IndexList[i -
                                        (part1QuizLength + part3QuizLength)]]
                                    .documentID);
                          }
                        } else {
                          // 정답 못맞춘 경우에는 제출횟수만 늘려주기
                          if (i < part1QuizLength) {
                            Map<String, int> resultMap = {
                              "submitCnt": questionSnapshot1
                                              .documents[part1IndexList[i]]
                                              .data["submitCnt"] ==
                                          null ||
                                      questionSnapshot1
                                              .documents[part1IndexList[i]]
                                              .data["submitCnt"] ==
                                          0
                                  ? 1
                                  : questionSnapshot1
                                          .documents[part1IndexList[i]]
                                          .data["submitCnt"] +
                                      1,
                            };
                            databaseService.addResultData(
                                resultMap,
                                part1QuizId,
                                questionSnapshot1
                                    .documents[part1IndexList[i]].documentID);
                          } else if (i < part1QuizLength + part3QuizLength) {
                            Map<String, int> resultMap = {
                              "submitCnt": questionSnapshot3
                                              .documents[part3IndexList[
                                                  i - part1QuizLength]]
                                              .data["submitCnt"] ==
                                          null ||
                                      questionSnapshot3
                                              .documents[part3IndexList[
                                                  i - part1QuizLength]]
                                              .data["submitCnt"] ==
                                          0
                                  ? 1
                                  : questionSnapshot3
                                          .documents[part3IndexList[
                                              i - part1QuizLength]]
                                          .data["submitCnt"] +
                                      1,
                            };
                            databaseService.addResultData(
                                resultMap,
                                part3QuizId,
                                questionSnapshot3
                                    .documents[
                                        part3IndexList[i - part1QuizLength]]
                                    .documentID);
                          } else if (i < totalQuizLength) {
                            Map<String, int> resultMap = {
                              "submitCnt": questionSnapshot4
                                              .documents[part4IndexList[i -
                                                  (part1QuizLength +
                                                      part3QuizLength)]]
                                              .data["submitCnt"] ==
                                          null ||
                                      questionSnapshot4
                                              .documents[part4IndexList[i -
                                                  (part1QuizLength +
                                                      part3QuizLength)]]
                                              .data["submitCnt"] ==
                                          0
                                  ? 1
                                  : questionSnapshot4
                                          .documents[part4IndexList[i -
                                              (part1QuizLength +
                                                  part3QuizLength)]]
                                          .data["submitCnt"] +
                                      1,
                            };
                            databaseService.addResultData(
                                resultMap,
                                part4QuizId,
                                questionSnapshot4
                                    .documents[part4IndexList[i -
                                        (part1QuizLength + part3QuizLength)]]
                                    .documentID);
                          }
                        }
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                    _showDialog();
                  } else if (submitYn) {
                    // 50개 다 안풀었는데 그냥 제출한다고 할 때 결과만 보여주자
                    for (int i = 0; i < correct.length; i++) {
                      if (correct[i] == true) {
                        _correct++;
                        if (i < part1QuizLength) {
                          _correct1++;
                        } else if (i < part1QuizLength + part3QuizLength) {
                          _correct3++;
                        } else if (i < totalQuizLength) {
                          _correct4++;
                        }
                      }
                    }
                    _showDialog();
                  }
                },
              ),
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({this.questionModel, this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
              text: TextSpan(
            style: TextStyle(fontSize: 12, color: Colors.black54),
            children: <TextSpan>[
              TextSpan(
                  text: "정답률: " +
                      (widget.questionModel.submitCnt == 0 ||
                              widget.questionModel.submitCnt == null
                          ? "-"
                          : (widget.questionModel.correctCnt /
                                  widget.questionModel.submitCnt *
                                  100)
                              .toInt()
                              .toString()) +
                      "% (총 제출 ${widget.questionModel.submitCnt}회 중 ${widget.questionModel.correctCnt}회 정답)\n",
                  style: TextStyle(
                      color: (widget.questionModel.submitCnt == 0 ||
                              widget.questionModel.submitCnt == null)
                          ? Colors.blueGrey
                          : (widget.questionModel.correctCnt /
                                          widget.questionModel.submitCnt *
                                          100)
                                      .toInt() <
                                  40
                              ? Colors.deepOrange
                              : (widget.questionModel.correctCnt /
                                              widget.questionModel.submitCnt *
                                              100)
                                          .toInt() <
                                      60
                                  ? Colors.orange
                                  : Colors.green)),
              TextSpan(
                text:
                    "${widget.questionModel.whenDid}${widget.questionModel.fromWho}",
              )
            ],
          )),
          Text(
            """${widget.index + 1}. ${widget.questionModel.question.toString().replaceAll('\\n', '\n').replaceAll('"""', '')}""",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          // 이미지 있는 경우
          widget.questionModel.questionImg != "null" &&
                  widget.questionModel.questionImg != "" &&
                  widget.questionModel.questionImg != null
              ? Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    // 이미지 테두리반경 등 설정시 필요
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                          imageUrl: widget.questionModel.questionImg,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.25,
                          fit: BoxFit.fill),
//                    child: PinchZoomImage(
//                      image: CachedNetworkImage(
//                          imageUrl: widget.questionModel.questionImg,
//                          width: MediaQuery.of(context).size.width * 0.8,
//                          height: MediaQuery.of(context).size.height * 0.25,
//                          fit: BoxFit.fill),
//                      zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
//                      hideStatusBarWhileZooming: true,
//                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 15,
          ),
          // String option, description, correctAnswer, optionSelected
          GestureDetector(
            onTap: () {
              if (widget.questionModel.option1 ==
                  widget.questionModel.correctOption) {
                setState(() {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  correct[widget.index] = true;
                  incorrect[widget.index] = false;
                });
              } else {
                setState(() {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = false;
                  correct[widget.index] = false;
                  incorrect[widget.index] = true;
                });
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option1,
              option: "1",
              optionSelected: optionSelected,
              isViewAnswer: isViewAnswer,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // String option, description, correctAnswer, optionSelected
          GestureDetector(
            onTap: () {
              if (widget.questionModel.option2 ==
                  widget.questionModel.correctOption) {
                setState(() {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  correct[widget.index] = true;
                  incorrect[widget.index] = false;
                });
              } else {
                setState(() {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = false;
                  correct[widget.index] = false;
                  incorrect[widget.index] = true;
                });
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option2,
              option: "2",
              optionSelected: optionSelected,
              isViewAnswer: isViewAnswer,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // String option, description, correctAnswer, optionSelected
          GestureDetector(
            onTap: () {
              if (widget.questionModel.option3 ==
                  widget.questionModel.correctOption) {
                setState(() {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  correct[widget.index] = true;
                  incorrect[widget.index] = false;
                });
              } else {
                setState(() {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = false;
                  correct[widget.index] = false;
                  incorrect[widget.index] = true;
                });
              }
//            }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option3,
              option: "3",
              optionSelected: optionSelected,
              isViewAnswer: isViewAnswer,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // String option, description, correctAnswer, optionSelected
          GestureDetector(
            onTap: () {
              if (widget.questionModel.option4 ==
                  widget.questionModel.correctOption) {
                setState(() {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  correct[widget.index] = true;
                  incorrect[widget.index] = false;
                });
              } else {
                setState(() {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = false;
                  correct[widget.index] = false;
                  incorrect[widget.index] = true;
                });
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option4,
              option: "4",
              optionSelected: optionSelected,
              isViewAnswer: isViewAnswer,
            ),
          ),
          // 정답보기 모드일 때 해설 나오는 부
          isViewAnswer
              ? Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white10),
                  child: RichText(
                      text: TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.indigo),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.questionModel.hint == null
                            ? ""
                            : """${widget.questionModel.hint.toString().replaceAll('\\n', '\n').replaceAll('"""', '')}""",
                      )
                    ],
                  )),
                )
              : Container(),
          SizedBox(
            height: 30,
          ),
        ],
      )),
      isViewAnswer
          ? (correct[widget.index]
              ? Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.panorama_fish_eye,
                    color: Colors.red.withOpacity(0.5),
                    size: 200,
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: Icon(Icons.clear,
                      color: Colors.red.withOpacity(0.5), size: 200),
                ))
          : Container(),
    ]);
  }
}