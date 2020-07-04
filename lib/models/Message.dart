import 'package:authorized_broker_quiz_app/models/user.dart';

class Message {
  final User sender;
  final String title;
  final String content;
  final int likedCnt;

  Message({
    this.sender,
    this.title,
    this.content,
    this.likedCnt
  });
}

