import 'package:authorized_broker_quiz_app/services/auth_page.dart';
import 'package:authorized_broker_quiz_app/services/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseProvider>(
            create: (_) => FirebaseProvider()),
      ],
      child: MaterialApp(
        title: "ADsP Quiz App",
        debugShowCheckedModeBanner: false,
        home: AuthPage(),
      ),
    );
  }
}