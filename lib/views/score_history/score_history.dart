import 'package:authorized_broker_quiz_app/shared/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ScoreHistoryState pageState;

class ScoreHistory extends StatefulWidget {
  @override
  ScoreHistoryState createState() {
    pageState = ScoreHistoryState();
    return pageState;
  }
}

class ScoreHistoryState extends State<ScoreHistory> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: rankingList(),
    );
  }

  Widget rankingList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: ListView(
        children: <Widget>[
          summaryCard(),
          SizedBox(height: 10),
          historyCard(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget historyCard() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Global.blueGrey.withOpacity(0.2), // 스택이기 때문에 이미지 위에 올 것임
          ),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    '최근 제출',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Global.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0.4, 0.4),
                            blurRadius: 2,
                          )
                        ]
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,10,20,0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          '과목',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Global.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          '점수',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Global.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          '제출일자',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Global.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white.withOpacity(0.8),
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  children: [
                    historyScore('부동산학개론', 91, '2020-06-01'),
                    historyScore('부동산학개론', 91, '2020-06-01'),
                    historyScore('민법', 80, '2020-06-01'),
                    historyScore('부동산학개론', 91, '2020-06-01'),
                    historyScore('중개실무', 70, '2020-06-01'),
                    historyScore('부동산학개론', 91, '2020-06-01'),
                    historyScore('공법', 40, '2020-06-01'),
                    historyScore('부동산학개론', 91, '2020-06-01'),
                    historyScore('공시법/세법', 50, '2020-06-01'),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget summaryCard() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Global.blueGrey.withOpacity(0.2), // 스택이기 때문에 이미지 위에 올 것임
          ),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    '과목별 평균점수',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                        color: Global.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0.4, 0.4),
                            blurRadius: 2,
                          )
                        ]
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,10,20,0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          '과목',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Global.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          '제출횟수',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Global.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          '평균점수',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Global.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white.withOpacity(0.8),
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  children: [
                    summaryScore('부동산학개론', 5, 76),
                    paddingDivider(),
                    summaryScore('민법', 5, 74),
                    paddingDivider(),
                    summaryScore('중개실무', 3, 91),
                    paddingDivider(),
                    summaryScore('공법', 9, 65),
                    paddingDivider(),
                    summaryScore('공시법/세법', 11, 76),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget paddingDivider() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,0,10,0),
      child: Divider(
        color: Colors.white.withOpacity(0.5),
        thickness: 1,
      ),
    );
  }

  Widget summaryScore(String subject, int cnt, int score) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(subject,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Global.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0.4, 0.4),
                        blurRadius: 2,
                      )
                    ]
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(cnt.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Global.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0.4, 0.4),
                      blurRadius: 2,
                    )
                  ]
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(score.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Global.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0.4, 0.4),
                      blurRadius: 2,
                    )
                  ]
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget historyScore(String subject, int score, String submitDate) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(subject,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Global.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0.4, 0.4),
                        blurRadius: 2,
                      )
                    ]
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(score.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Global.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0.4, 0.4),
                        blurRadius: 2,
                      )
                    ]
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(submitDate.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Global.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0.4, 0.4),
                        blurRadius: 2,
                      )
                    ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRankList() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("QuizResult")
            .document('00vITuTIW2ZBC1KUAZkV')
            .collection('모의고사1회')
            .orderBy("score", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : Scrollbar(
                child: ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index) {
                return RankTile(
                  userId: snapshot.data.documents[index].data["userId"],
                  score: snapshot.data.documents[index].data["score"],
                  createDt: snapshot.data.documents[index].data["createDt"],
                );
            },
          ),
              );
        }
    );
  }
}

class RankTile extends StatefulWidget {
  final String userId;
  final int score;
  final Timestamp createDt;

  RankTile(
      {@required this.userId,
        @required this.score,
        @required this.createDt
      });

  @override
  _RankTileState createState() => _RankTileState();
}

class _RankTileState extends State<RankTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      height: 20,
      child: Container(
        padding: EdgeInsets.fromLTRB(10,0,0,0),
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 3.0,
              offset: Offset(1.0, 1.0),
            )
          ],
          borderRadius: BorderRadius.circular(5),
          color: Colors.white, // 스택이기 때문에 이미지 위에 올 것임
        ),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // ListTile 내부는 스크롤 불가
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.userId,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.score.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.createDt.toDate().toIso8601String().substring(0, 10),
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}