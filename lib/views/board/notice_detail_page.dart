import 'package:authorized_broker_quiz_app/models/post_model.dart';
import 'package:authorized_broker_quiz_app/services/database.dart';
import 'package:authorized_broker_quiz_app/services/firebase_provider.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'add_notice.dart';

PostModel postModel = new PostModel();

class DetailNoticePage extends StatefulWidget {
  final String postId;

  DetailNoticePage({
    @required this.postId,
  });

  @override
  _DetailNoticePageState createState() => _DetailNoticePageState();
}

class _DetailNoticePageState extends State<DetailNoticePage> {
  FirebaseProvider fp;
  DatabaseService databaseService = new DatabaseService();

  @override
  void dispose() {
    super.dispose();
    Map<String, int> readMap = {"read" : postModel.read + 1};
    databaseService.addReadPostData(readMap, widget.postId);
  }
  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData.fallback(), // 뒤로가기
      ),
      body: Container(
          child: StreamBuilder(
        stream: Firestore.instance
            .collection('Post')
            .document(widget.postId.trim())
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            postModel.postTitle = snapshot.data["postTitle"];
            postModel.writer = snapshot.data["writer"];
            postModel.content = snapshot.data["content"];
            postModel.createDt = snapshot.data["createDt"];
            postModel.updateDt = snapshot.data["updateDt"];
            postModel.read = snapshot.data["read"];
            postModel.like = snapshot.data["like"];



            return detailPage();
          }
        },
      )),
    );
  }

  Widget detailPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Text(
          postModel.postTitle,
          style: TextStyle(
              color: Colors.black87, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                alignment: Alignment.centerRight,
                child: fp.getUser().email == 'kyungsoo.hwang@miracom.co.kr' ? RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddNotice(content: postModel.content)));
                    },
                    color: Colors.indigo,
                    child: Text(
                      '수정',
                      style: TextStyle(color: Colors.white),
                    )) :
                Container()),
            SizedBox(
              width: 10,
            ),
            Container(
                alignment: Alignment.centerRight,
                child: fp.getUser().email == 'kyungsoo.hwang@miracom.co.kr' ? RaisedButton(
                    onPressed: () {

                    },
                    color: Colors.indigo,
                    child: Text('삭제', style: TextStyle(color: Colors.white))) : Container()),
          ],
        ),
        Flexible(flex: 1, child: Text("작성자 : ${postModel.writer}")),
        SizedBox(
          height: 10,
        ),
        Flexible(
            flex: 1,
            child: Text(
              "작성일 : ${postModel.updateDt.toDate().toString().substring(0, 10)}",
            )),
        SizedBox(
          height: 10,
        ),
        Flexible(flex: 1, child: Text("조회수 : ${(postModel.read+1).toString()}")),
//          SizedBox(height: 10,),
//          Flexible(flex: 1, child: Text("좋아요 : ${postModel.like.toString()}")),
        SizedBox(
          height: 30,
        ),
        Text(postModel.content,
            style: TextStyle(
              fontSize: 25,
            )),
      ]),
    );
  }
}
