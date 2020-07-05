import 'package:authorized_broker_quiz_app/services/database.dart';
import 'package:authorized_broker_quiz_app/services/firebase_provider.dart';
import 'package:authorized_broker_quiz_app/shared/globals.dart';
import 'package:authorized_broker_quiz_app/views/add_excel_authorized_quiz_list.dart';
import 'package:authorized_broker_quiz_app/views/play_quiz/play_quiz.dart';
import 'package:authorized_broker_quiz_app/views/play_quiz/play_random_quiz.dart';
import 'package:authorized_broker_quiz_app/views/play_quiz/play_section1_random_quiz.dart';
import 'package:authorized_broker_quiz_app/views/play_quiz/play_section2_random_quiz.dart';
import 'package:authorized_broker_quiz_app/views/play_quiz/play_section_part_random_quiz.dart';
import 'package:authorized_broker_quiz_app/views/score_history/score_history.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'board/notice_page.dart';
import 'play_quiz/play_mock_exam_quiz.dart';

HomeState pageState;

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    pageState = HomeState();
    return pageState;
  }
}

class HomeState extends State<Home> {
  FirebaseProvider fp;
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  // firebase에 저장된 데이터 가지고 온다. (쿼리 스냅샷 형태로 넘겨줄 것임)
  // 쿼리 스냅샷으로 받자.

  Widget titleText(String titleText) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: titleText,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                  color: Colors.black87,
//                shadows: [
//                  Shadow(
//                    offset: Offset(0.5, 0.5),
//                    blurRadius: 2,
//                  ),
//                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quizList() {
    return ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
//          Row(
//            children: [
//              titleText("랜덤문제 풀기"),
//            ]
//          ),
          AllRandomQuizTile(),
//          MockExamQuizTile(),
//          titleText("기출문제별 풀기"),
          StreamBuilder(
              // 내가 스트리밍 업데이트할 때마다 실시간으로 반영
              stream: quizStream,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Container()
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return QuizTile(
                              imgUrl: snapshot
                                  .data.documents[index].data["quizImgUrl"],
                              title: snapshot
                                  .data.documents[index].data["quizTitle"],
                              desc: snapshot
                                  .data.documents[index].data["quizDesc"],
                              quizId: snapshot
                                  .data.documents[index].data["quizId"]);
                        },
                      );
              }),
          SizedBox(height: 10)
          //titleText("기출회차별로 풀기"),
//        StreamBuilder(
//          // 내가 스트리밍 업데이트할 때마다 실시간으로 반영
//            stream: quizStream,
//            builder: (context, snapshot) {
//              return snapshot.data == null
//                  ? Container()
//                  : Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                child: ListView.builder(
//                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                    scrollDirection: Axis.horizontal,
//                    itemCount: snapshot.data.documents.length,
//                    shrinkWrap: true,
//                    itemBuilder: (context, index) {
//                      return Row(
//                        children: <Widget>[
//                          QuizTile(
//                              imgUrl: snapshot
//                                  .data.documents[index].data["quizImgUrl"],
//                              title: snapshot
//                                  .data.documents[index].data["quizTitle"],
//                              desc: snapshot
//                                  .data.documents[index].data["quizDesc"],
//                              quizId: snapshot
//                                  .data.documents[index].data["quizId"]
//                          ),
//                          SizedBox(width: 10,),
//                        ],
//                      );
//                    }),
//              );
//            }),
        ]);
  }

  // back 버튼 클릭시 종료할건지 물어보는
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("앱을 종료하시겠습니까?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "예",
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
                onPressed: () {
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

  @override
  void initState() {
    databaseService.getQuizListData().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {

  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
                title: appBar(context),
                backgroundColor: Colors.white,
                elevation: 0.0,
                leading: Container(),
                actions: <Widget>[
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("로그아웃 하시겠습니까?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "예",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blueGrey),
                                ),
                                onPressed: () {
                                  fp.signOut();
                                  Navigator.pop(context, true);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "아니요",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blueGrey),
                                ),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Icon(
                          Icons.exit_to_app,
                          color: Colors.blueGrey,
                        ),
                      )),
                ],
            ),
            body: Container(
              color: Colors.white,
              child: TabBarView(
                children: <Widget>[
                  quizList(),
                  NoticePage(),
  //                Board(),
                  ScoreHistory(),
  //                Container(),
                ],
              ),
            ),
//        widget.isAdmin ? Container() : Provicer 배우고 다시 수정하자 (관리자일때만 보여주는 기능)
            floatingActionButton:
                // 관리자만 버튼 보이게
                fp.getUser().email == 'skyboom86@naver.com'
                    ? FloatingActionButton(
                        backgroundColor: Global.redSun,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddExcelAuthorizedQuizList()));
                        },
                      )
                    : Container(),
            bottomNavigationBar: Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: Global.redSun,
                labelColor: Global.blueGrey,
                indicatorWeight: 5,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.home),
                    text: 'Home',
                  ),
                  Tab(icon: Icon(Icons.record_voice_over), text: 'Board'),
                  Tab(icon: Icon(Icons.assessment), text: 'Ranking'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MockExamQuizTile extends StatefulWidget {
  @override
  _MockExamQuizTileState createState() => _MockExamQuizTileState();
}

class _MockExamQuizTileState extends State<MockExamQuizTile> {
  final String quizId = '00vITuTIW2ZBC1KUAZkV'; // Firebase의 MockExamQuiz collection의 documentId
  int inputQuizLength = 50;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              // quizTile 클릭했을 때 해당 quizId를 알아야 해당 퀴즈목록 가져옴..
                builder: (context) => PlayMockExamQuiz(quizId, inputQuizLength)));
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                // 이미지 테두리반경 등 설정시 필요
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                    imageUrl:
                    "https://images.unsplash.com/photo-1580582932707-520aed937b7b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60",
                    width: MediaQuery.of(context).size.width * 1,
                    fit: BoxFit.cover),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black54, // 스택이기 때문에 이미지 위에 올 것임
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Mock Exam (',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '50',
                            style: TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: ' Problems)'),
                        ],
                      ),
                    ),
                    Text(
                      "duration: '20.06.17 ~ '20.06.30",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class RandomQuizTile extends StatefulWidget {
  @override
  _RandomQuizTileState createState() => _RandomQuizTileState();
}

class _RandomQuizTileState extends State<RandomQuizTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              // quizTile 클릭했을 때 해당 quizId를 알아야 해당 퀴즈목록 가져옴..
                builder: (context) => PlayRandomQuiz()));
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                // 이미지 테두리반경 등 설정시 필요
                borderRadius: BorderRadius.circular(10),
                child:
                CachedNetworkImage(
                    imageUrl:
                    "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80",
                    width: MediaQuery.of(context).size.width * 1,
                    fit: BoxFit.cover),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black54, // 스택이기 때문에 이미지 위에 올 것임
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Random Quiz (',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '50',
                            style: TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: ' Problems)'),
                        ],
                      ),
                    ),
                    Text(
                      "Part1: 10, Part3: 10, Part4: 30",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class QuizTile extends StatefulWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;

  QuizTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.desc,
      @required this.quizId});

  @override
  _QuizTileState createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  int inputQuizLength = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
          height: 150,
          child: ClipRRect(
            // 이미지 테두리반경 등 설정시 필요
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
                imageUrl: widget.imgUrl,
                width: MediaQuery.of(context).size.width * 1,
                fit: BoxFit.cover),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20),
          height: 150,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black54, // 스택이기 때문에 이미지 위에 올 것임
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                """${widget.desc.toString().replaceAll('\\n', '\n').replaceAll('"""', '')}""",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 0, right: 10),
          height: 150,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                child: Text('10문제 풀기'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // quizTile 클릭했을 때 해당 quizId를 알아야 해당 퀴즈목록 가져옴..
                          builder: (context) => PlayQuiz(widget.quizId, 10)));
                },
              ),
              RaisedButton(
                child: Text('20문제 풀기'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // quizTile 클릭했을 때 해당 quizId를 알아야 해당 퀴즈목록 가져옴..
                          builder: (context) => PlayQuiz(widget.quizId, 20)));
                },
              ),
              RaisedButton(
                child: Text('30문제 풀기'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // quizTile 클릭했을 때 해당 quizId를 알아야 해당 퀴즈목록 가져옴..
                          builder: (context) => PlayQuiz(widget.quizId, 30)));
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10)
      ]),
    );
  }
}

class AllRandomQuizTile extends StatefulWidget {
  @override
  _AllRandomQuizTileState createState() => _AllRandomQuizTileState();
}

class _AllRandomQuizTileState extends State<AllRandomQuizTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              // quizTile 클릭했을 때 해당 quizId를 알아야 해당 퀴즈목록 가져옴..
                builder: (context) => PlayRandomQuiz()));
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                // 이미지 테두리반경 등 설정시 필요
                borderRadius: BorderRadius.circular(10),
                child:
                CachedNetworkImage(
                    imageUrl:
                    "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80",
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    fit: BoxFit.fill),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Global.redSun.withOpacity(0.2), // 스택이기 때문에 이미지 위에 올 것임
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          '22회 ~ 30회 랜덤',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlaySection1RandomQuiz()));
                          },
                          child: titleCard('1차'),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlaySection2RandomQuiz()));
                          },
                          child: titleCard('2차'),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.white.withOpacity(0.8),
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaySectionPartRandomQuiz(partName:'부동산학개론')));
                              },
                              child: subjectCard('부동산학개론'),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaySectionPartRandomQuiz(partName:'민법')));
                              },
                              child: subjectCard('민법'),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaySectionPartRandomQuiz(partName:'중개실무')));
                              },
                              child: subjectCard('중개실무'),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaySectionPartRandomQuiz(partName:'공법')));
                              },
                              child: subjectCard('공법'),
                           ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaySectionPartRandomQuiz(partName:'공시법세법')));
                              },
                              child: subjectCard('공시법/세법'),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),

            ],
          )),
    );
  }

  Widget titleCard(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,10,10,0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Card(
          color: Colors.blueGrey.withOpacity(0.7),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.white
            ),
            ),
          ),
        ),
      ),
    );
  }

  Widget subjectCard(String subject) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,0,10,0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Card(
          color: Colors.white.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(subject,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }
}