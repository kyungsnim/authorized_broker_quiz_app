import 'package:authorized_broker_quiz_app/models/post_model.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

PostModel postModel = new PostModel();

class DetailEditPage extends StatefulWidget {
  final String editId;

  DetailEditPage({@required this.editId});

  @override
  _DetailEditPageState createState() => _DetailEditPageState();
}

class _DetailEditPageState extends State<DetailEditPage> {

  @override
  void initState() {
    super.initState();
  }

  void updateViewCnt() async {
    // 조회수 ++1
  }

  @override
  Widget build(BuildContext context) {
    updateViewCnt();

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
            stream: Firestore.instance.collection('Edit').document(widget.editId.trim()).snapshots(),
            builder: (_, snapshot) {
              if(snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                postModel.postTitle = snapshot.data["editTitle"];
                postModel.writer = snapshot.data["writer"];
                postModel.content = snapshot.data["content"];
                postModel.createDt = snapshot.data["createDt"];
                postModel.updateDt = snapshot.data["updateDt"];
                postModel.read = snapshot.data["read"];
                postModel.like = snapshot.data["like"];

                return detailPage();
              }
            },
          )
      ),
    );
  }

  Widget detailPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children : <Widget>[
            Text(postModel.postTitle,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 30,),
            Flexible(flex: 1, child: Text("작성자 : ${postModel.writer}")),
            SizedBox(height: 10,),
            Flexible(flex: 1, child: Text("작성일 : ${postModel.updateDt.toDate().toString().substring(0, 10)}",)),
            SizedBox(height: 10,),
            Flexible(flex: 1, child: Text("조회수 : ${postModel.read.toString()}")),
            SizedBox(height: 10,),
            Flexible(flex: 1, child: Text("좋아요 : ${postModel.like.toString()}")),
            SizedBox(height: 30,),
            Text(postModel.content,
                style: TextStyle(
                  fontSize: 25,
                )
            ),
          ]
      ),
    );
  }
}
