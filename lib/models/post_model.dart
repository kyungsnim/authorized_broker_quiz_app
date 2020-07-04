import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String postId;
  String postTitle;
  String content;
  String writer;
  Timestamp createDt;
  Timestamp updateDt;
  int read;
  int like;
}