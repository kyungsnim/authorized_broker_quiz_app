import 'dart:math';

import 'package:authorized_broker_quiz_app/models/question_model.dart';
import 'package:authorized_broker_quiz_app/services/database.dart';
import 'package:authorized_broker_quiz_app/services/firebase_provider.dart';
import 'package:authorized_broker_quiz_app/widgets/quiz_play_widgets.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';
import 'package:random_string/random_string.dart';

import '../home.dart';

// ignore: must_be_immutable
class PlayMockExamQuiz extends StatefulWidget {
  String quizId;
  int inputQuizLength;

  PlayMockExamQuiz(quizId, inputQuizLength) {
    this.quizId = quizId;
    quizLength = inputQuizLength;
  }

  @override
  _PlayMockExamQuizState createState() => _PlayMockExamQuizState();
}

// 실시간으로 상단에 퀴즈 푸는 현황 보여주기 위한 스트림
Stream infoStream;

List<bool> correct;
List<bool> incorrect;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int quizLength = 0;
var optionShuffleIndexList;
bool isViewAnswer = false; // 정답보기 모드
var indexList;

class _PlayMockExamQuizState extends State<PlayMockExamQuiz> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionSnapshot;
  bool isLoading = true;
  FirebaseProvider fp;

  var randomIndex = new Random();

  @override
  void initState() {
    correct = List.generate(quizLength, (index) => false);
    incorrect = List.generate(quizLength, (index) => false);
    isLoading = true;
    databaseService.getMockExamQuizData(widget.quizId).then((val) {
      setState(() {
        questionSnapshot = val;

        isLoading = false;
      });
    });
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
    questionModel.answered = false;
    return questionModel;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
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
//              PinchZoomImage(
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
                            text: ' / $quizLength',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 60,
                            )),
                      ],
                    ),
                  ),
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
                        Navigator.push(context,
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
    if (!isViewAnswer) {
      // 각 파트의 총 문제수 내에서 랜덤으로 번호 추출 (중복index 제거 로직 추가, 2020-06-06)
      indexList = new List<int>(quizLength);
      optionShuffleIndexList = new List<List>(quizLength);

      for (int insertIndex = 0; insertIndex < quizLength; insertIndex++) {
        indexList[insertIndex] =
            randomIndex.nextInt(questionSnapshot.documents.length);
        for (int searchIndex = 0; searchIndex < insertIndex; searchIndex++) {
          if (indexList[searchIndex] == indexList[insertIndex]) {
            insertIndex--;
            break;
          }
        }
      }
      // 보기 순서 바꿔줄 때 쓰이는 용도
      for (int insertIndex = 0; insertIndex < quizLength; insertIndex++) {
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
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
//              questionSnapshot == null ? Center(
//                  child: CircularProgressIndicator(
//                    backgroundColor: Colors.indigo,
//                  ))
//                  :
//              InfoHeader(
//                length: questionSnapshot.documents.length,
//              ),
          questionSnapshot == null
              ? Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.indigo,
                ))
              :
              // questionSnapshot.documents == null 이렇게 표현하면
              // The getter 'documents' was called on null. 오류 남
              ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  shrinkWrap: true,
                  // 'visible' was called on null 방지
                  physics: ClampingScrollPhysics(),
                  // 'visible' was called on null 방지
                  itemCount: quizLength,
                  itemBuilder: (context, index) {
                    return QuizPlayTile(
                        questionModel: getQuestionModelFromDataSnapshot(
                            questionSnapshot.documents[indexList[index]],
                            index),
                        index: index);
                  },
                ),
        ],
      ),
    ));
  }

  Future<bool> _onPressedSubmitYn(checkCnt) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: checkCnt == 50
                ? Text("최종 제출하시겠습니까?\n", style: TextStyle(fontSize: 18))
                : RichText(
                    text: TextSpan(
                        text: "최종 제출하시겠습니까?\n모든 문항의 답이 체크되어야\n랭킹에 반영됩니다.\n",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: "현재 체크: $checkCnt개, ",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.indigo)),
                          TextSpan(
                              text: "미체크: ${quizLength - checkCnt}개\n",
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
    fp = Provider.of<FirebaseProvider>(context);

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
            : questionSnapshot == null
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.indigo,
                    ),
                  )
                : makeRandomQuiz(),
        floatingActionButton: isViewAnswer
            ? Container()
            : FloatingActionButton(
                backgroundColor: Colors.indigo,
                child: Icon(Icons.check),
                onPressed: () async {
                  // 문제 푼 갯수 카운트
                  var cnt = 0;
                  for (int i = 0; i < quizLength; i++) {
                    if (correct[i] || incorrect[i]) {
                      cnt++;
                    }
                  }
                  var submitYn = false; // 50문제 확인용
                  _correct = 0;

                  // 10문제 미만으로 풀고 제출하면 alert
                  if (cnt < 10) {
                    _underCntAlert();
                  } else {
                    // 최종 제출확인 팝업 (50개 다 풀었으면 db에 결과 반영, 다 안풀었으면 점수만 공개)
                    submitYn = await _onPressedSubmitYn(cnt);
                  }

                  if (submitYn) {
                    // 정답보고 다시 채점할 때 중복돼서 더해지면 안됨
                    _correct = 0;
                    _incorrect = 0;

                    for (int i = 0; i < correct.length; i++) {
                      if (correct[i] == true) {
                        _correct++;
                      }
                      if (incorrect[i] == true) {
                        _incorrect++;
                      }
                    }

                    if (cnt == quizLength) {
                      // 랭킹에 점수 반영하는 부분 넣어야 함
                      Map<String, dynamic> resultMap = {
                        "userId" : fp.getUser().email.replaceAll('@miracom.co.kr', '').replaceAll('a', '*').replaceAll('c', '*').replaceAll('e', '*').replaceAll('i', '*').replaceAll('m', '*').replaceAll('w', '*').replaceAll('o', '*'),
                        "score" : _correct,
                        "createDt" : Timestamp.now()
                      };
                      var resultId = randomAlphaNumeric(16); // 랜덤알파벳상수 16자 생성
                      databaseService.addMockExamResultData(
                        resultMap,
                        widget.quizId,
                      );
                    }
                    _showDialog();
                  }
                },
              ),
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({@required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoStream,
      builder: (context, snapshot) {
        return Container(
            height: 30,
            margin: EdgeInsets.only(left: 14),
            child: ListView(
              scrollDirection: Axis.horizontal, // 좌우 슬라이드,
              shrinkWrap: true,
              children: <Widget>[
                InfoQuestion(
                  text: "checked",
                  number: _correct + _incorrect,
                ),
                InfoQuestion(
                  text: "unchecked",
                  number: _notAttempted,
                ),
              ],
            ));
      },
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
//                          imageUrl: widget.questionModel.questionImg.trim(),
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
                  _notAttempted--;
                });
              } else {
                setState(() {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = false;
                  correct[widget.index] = false;
                  incorrect[widget.index] = true;
                  _notAttempted--;
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
                  _notAttempted--;
                });
              } else {
                setState(() {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = false;
                  correct[widget.index] = false;
                  incorrect[widget.index] = true;
                  _notAttempted--;
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
                  _notAttempted--;
                });
              } else {
                setState(() {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = false;
                  correct[widget.index] = false;
                  incorrect[widget.index] = true;
                  _notAttempted--;
                });
              }
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
                  _notAttempted--;
                });
              } else {
                setState(() {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = false;
                  correct[widget.index] = false;
                  incorrect[widget.index] = true;
                  _notAttempted--;
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
              ? widget.questionModel.hintImg != "null" &&
                      widget.questionModel.hintImg != "" &&
                      widget.questionModel.hintImg != null
                  ? Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        // 이미지 테두리반경 등 설정시 필요
                        borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                      imageUrl: widget.questionModel.hintImg,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.25,
                      fit: BoxFit.fill),
//                        child: PinchZoomImage(
//                          image: CachedNetworkImage(
//                              imageUrl: widget.questionModel.hintImg.trim(),
//                              width: MediaQuery.of(context).size.width * 0.8,
//                              height: MediaQuery.of(context).size.height * 0.25,
//                              fit: BoxFit.fill),
//                          zoomedBackgroundColor:
//                              Color.fromRGBO(240, 240, 240, 1.0),
//                          hideStatusBarWhileZooming: true,
//                        ),
                      ),
                    )
                  : Container(
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
      // 정답보기 모드
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
