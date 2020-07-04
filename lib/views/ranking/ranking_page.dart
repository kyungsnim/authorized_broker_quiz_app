import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

RankingState pageState;

class Ranking extends StatefulWidget {
  @override
  RankingState createState() {
    pageState = RankingState();
    return pageState;
  }
}

class RankingState extends State<Ranking> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: rankingList(),
    );
  }

  Widget rankingList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('랭킹보기',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  'USER',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'SCORE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'SUBMIT DATE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Flexible(
            flex: 8,
            child: _getRankList(),
          ),
          SizedBox(height: 10),
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