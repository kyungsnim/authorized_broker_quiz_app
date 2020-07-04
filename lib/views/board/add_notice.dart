import 'package:authorized_broker_quiz_app/services/database.dart';
import 'package:authorized_broker_quiz_app/services/firebase_provider.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class AddNotice extends StatefulWidget {
  var content;

  AddNotice({content}) {
    this.content = content;
  }

  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  FirebaseProvider fp;

  final _formKey = GlobalKey<FormState>();
  String postId,
      postTitle,
      content,
      writer;
  int read,
      like;
  Timestamp createDt,
      updateDt;
  bool _isLoading = false;
  DatabaseService databaseService = new DatabaseService();
  TextEditingController postTitleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();

  uploadNoticeData() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        postId = randomAlphaNumeric(16); // 랜덤알파벳상수 16자 생성
        writer = fp.getUser().email.split('@')[0]; // 이메일 앞부분만 가져다 저장
        read = 0;
        like = 0;
        createDt = Timestamp.now();
        updateDt = Timestamp.now();

        Map<String, Object> postMap = {
          "postId": postId,
          "postTitle": postTitle,
          "content": content,
          "writer": writer,
          "read": read,
          "like": like,
          "createDt": createDt,
          "updateDt": updateDt,
        };

        // postId 같이 넘겨줘서 해당 documentId로 추가되게끔 하기
        await databaseService
            .addNoticeData(postMap, postId)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    postTitleController.dispose();
    contentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return Scaffold(
        // 키보드 올라가서 겹치는 오류 잡기
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: appBar(context),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Container(),
        ),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.indigo,
          ),
        )
            : Form(
          key: _formKey,
          child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 5),
                    child: TextFormField(
                      controller: postTitleController,
                      cursorColor: Colors.indigo,
                      validator: (val) {
                        return val.isEmpty ? 'Enter post title' : null;
                      },
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            // underline 색상 변경
                              borderSide: BorderSide(color: Colors.indigo)),
                          icon: Icon(Icons.mode_edit, color: Colors.indigo),
                          hintText: 'Notice Title'),
                      onChanged: (val) {
                        postTitle = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: SafeArea(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: contentController,
                        cursorColor: Colors.indigo,
                        validator: (val) {
                          return val.isEmpty ? 'Enter content' : null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            // underline 색상 변경
                              borderSide: BorderSide(color: Colors.indigo)),
                          icon: Icon(Icons.arrow_right, color: Colors.indigo),
                          hintText: 'Content'),
                        onChanged: (val) {
                          content = val;
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: blueButton(
                          context: context,
                          text: 'Back',
                          buttonWidth:
                          MediaQuery.of(context).size.width * 0.44,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          uploadNoticeData();
                        },
                        child: blueButton(
                          context: context,
                          text: 'Add Notice',
                          buttonWidth:
                          MediaQuery.of(context).size.width * 0.44,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
