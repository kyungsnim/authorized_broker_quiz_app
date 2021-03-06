import 'package:authorized_broker_quiz_app/views/home.dart';
import 'package:authorized_broker_quiz_app/views/signin.dart';
import 'package:flutter/material.dart';
import 'firebase_provider.dart';
import 'package:provider/provider.dart';

AuthPageState pageState;

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  FirebaseProvider fp;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    logger.d("user: ${fp.getUser()}");
    // 사용자정보가 있으면서 이메일인증 완료했다면 홈화면으로 이동
    if (fp.getUser() != null && fp.getUser().isEmailVerified == true) {
      return Home();
    } else {
      return SignIn();
    }
  }
}
