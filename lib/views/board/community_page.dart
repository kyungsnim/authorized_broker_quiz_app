import 'package:authorized_broker_quiz_app/services/database.dart';
import 'package:authorized_broker_quiz_app/services/firebase_provider.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';
import 'package:provider/provider.dart';

import 'add_notice.dart';
import 'notice_detail_page.dart';

CommunityPageState pageState;

class CommunityPage extends StatefulWidget {
  @override
  CommunityPageState createState() {
    pageState = CommunityPageState();
    return pageState;
  }
}

class CommunityPageState extends State<CommunityPage> {
  // 사용자 인증정보 가져오기 위한
  FirebaseProvider fp;
  // 실시간 post 반영
  Stream postStream;
  DatabaseService databaseService = new DatabaseService();

  Widget _getNoticeList() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Post").orderBy("createDt", descending: true).snapshots(),
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return NoticeTile(
                title: snapshot.data.documents[index].data["postTitle"],
                postId: snapshot.data.documents[index].data["postId"],
                content: snapshot.data.documents[index].data["content"],
                createDt: snapshot.data.documents[index].data["createDt"],
              );
            },
          );
        }
    );
  }

  Widget postList() {
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
                      child: Text('공지사항',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  fp.getUser().email == 'kyungsoo.hwang@miracom.co.kr' ?
                  Flexible(
                    flex: 1,
                    child: RaisedButton(
                      color: Colors.indigo,
                      child: Text('글쓰기',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNotice()));
                      },
                    ),
                  ) : Container(),
                  Flexible(
                    flex: 1,
                    child: RaisedButton(
                      color: Colors.indigo,
                      child: Text('시험일정',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                      onPressed: () {
                        _showDialog();
                      },
                    ),
                  ),
                ]
            ),
          ),
          SizedBox(height: 10),
          Flexible(
            flex: 8,
            child: _getNoticeList(),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // 시험 일정
  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(1),
          actionsPadding: EdgeInsets.only(right: 10),
          backgroundColor: Colors.white,
          elevation: 0.0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Stack(alignment: Alignment.center, children: <Widget>[
            ClipRRect(
              // 이미지 테두리반경 등 설정시 필요
                child: CachedNetworkImage(
                    imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/adsp-quiz-app-67312.appspot.com/o/ADsP%20Quiz%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202020-06-14%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%201.45.59.png?alt=media&token=9fc2d6cd-c63c-45dc-a3a5-df88123097ed",
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.fitWidth),
//              child: PinchZoomImage(
//                image: CachedNetworkImage(
//                    imageUrl:
//                    "https://firebasestorage.googleapis.com/v0/b/adsp-quiz-app-67312.appspot.com/o/ADsP%20Quiz%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202020-06-14%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%201.45.59.png?alt=media&token=9fc2d6cd-c63c-45dc-a3a5-df88123097ed",
//                    width: MediaQuery.of(context).size.width * 1.0,
//                    height: MediaQuery.of(context).size.height * 0.3,
//                    fit: BoxFit.fitWidth),
//                zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
//                hideStatusBarWhileZooming: true,
//              ),
            ),
          ]),
          actions: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: blueButton(
                        context: context,
                        text: "확인",
                        buttonWidth: MediaQuery.of(context).size.width * 0.5),
                  ),
                ]),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return Scaffold(
//      appBar: AppBar(
//      title: appBar(context),
//      centerTitle: false,
//      backgroundColor: Colors.white,
//      elevation: 0.0,
//      iconTheme: IconThemeData.fallback(), // 뒤로가기
//      ),
      body: postList(),
    );
  }
}

class NoticeTile extends StatefulWidget {
  final String title;
  final String postId;
  final String content;
  final Timestamp createDt;

  NoticeTile(
      {@required this.title,
        @required this.postId,
        @required this.content,
        @required this.createDt
      });

  @override
  _NoticeTileState createState() => _NoticeTileState();
}

class _NoticeTileState extends State<NoticeTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              // quizTile 클릭했을 때 해당 quizId를 알아야 해당 퀴즈목록 가져옴..
                builder: (context) => DetailNoticePage(postId: widget.postId)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        height: 60,
        child: Container(
          padding: EdgeInsets.only(left: 10),
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
            physics: ScrollPhysics(),
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.createDt.toDate().toIso8601String().substring(0, 10),
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}