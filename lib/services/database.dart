import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // db 구조 : Quiz > Quiz범주(title) > 각QuizData
  Future<void> addQuizData(Map quizMap, String quizId) async {
    // random id 부여,
    await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .setData(quizMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addAuthorizedQuizData(Map quizMap, String quizId) async {
    // random id 부여,
    await Firestore.instance
        .collection("Authorized")
        .document(quizId)
        .setData(quizMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  // 게시글 조회시 +1 db에 반영
  Future<void> addReadPostData(
      Map resultMap, String postId) async {
    // random id 부여,
    await Firestore.instance
        .collection("Post")
        .document(postId)
        .updateData(resultMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  // 제출결과 정답여부 db에 반영
  Future<void> addResultData(
      Map resultMap, String quizId, String questionId) async {
    // random id 부여,
    await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .collection("QnA")
        .document(questionId)
        .setData(resultMap)
        .catchError((e) {
      print(e.toString());
    });
  }
  
  // 점수 History에서 제출횟수 가져오기
  getSubmitCnt(String userId) async {
    int cnt;
    await Firestore.instance
        .collection("ScoreHistory")
        .document(userId)
        .get().then((value) {
          cnt = value.data["submitCnt"];
        });
    print('cnt : $cnt');
    return cnt;
  }
  // 과목 점수 db에 반영
  Future<void> addSubjectResultData(
      Map resultMap, String userId) async {
    // random id 부여,
    await Firestore.instance
        .collection("ScoreHistory")
        .document(userId)
        .setData(resultMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  // 제출결과 랭킹 db에 반영
  Future<void> addMockExamResultData(
      Map resultMap, String quizId) async {
    // random id 부여,
    await Firestore.instance
        .collection("QuizResult")
        .document(quizId)
        .collection("모의고사1회")
        .add(resultMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  // 공지사항 글쓰기
  Future<void> addNoticeData(Map noticeMap, String postId) async {
    await Firestore.instance
        .collection("Post")
        .document(postId)
        .setData(noticeMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addMockExamQuestionData(Map questionMap, String quizId) async {
    await Firestore.instance
        .collection("MockExamQuiz")
        .document(quizId)
        .collection("QnA")
        .add(questionMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addAuthorizedQuestionData(Map questionMap, String quizId) async {
    await Firestore.instance
        .collection("Authorized")
        .document(quizId)
        .collection("QnA")
        .add(questionMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addQuestionData(Map questionMap, String quizId) async {
    await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .collection("QnA")
        .add(questionMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getQuizListData() async {
    // 쿼리스냅샷 스트림 형태로 리턴
    return await Firestore.instance.collection("Quiz").snapshots();
  }

  getPostListData() async {
    // 쿼리스냅샷 스트림 형태로 리턴
    return await Firestore.instance.collection("Post").orderBy("createDt", descending: true).snapshots();
  }

  getPostData(postId) async {
    return await Firestore.instance
        .collection("Post")
        .document(postId);
  }
  getQuizData(String quizId) async {
    return await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .collection("QnA")
        .getDocuments();
  }
  getMockExamQuizData(String quizId) async {
    return await Firestore.instance
        .collection("MockExamQuiz")
        .document(quizId)
        .collection("QnA")
        .getDocuments();
  }

  getRandomQuizData(String quizId) async {
    print('quizId: $quizId');
    return await Firestore.instance
        .collection("Authorized")
        .document(quizId)
        .collection("QnA")
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }
}
