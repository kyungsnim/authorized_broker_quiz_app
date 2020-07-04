import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class HelperFunctions {
  static String UserLoggedInKey = "USERLOGGEDINKEY";
  // 로그인 사용자 정보 저장
  // MyApp에서 호출해서 쓸 수 있도록 static 메소드로 설정
  static saveUserLoggedInDetails({@required bool isLoggedIn}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(UserLoggedInKey, isLoggedIn); // 유저의 로그인키를 set
  }

  // MyApp에서 호출해서 쓸 수 있도록 static 메소드로 설정
  static Future<bool> getUserLoggedInDetails({bool isLoggedIn}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UserLoggedInKey); // 유저의 로그인키를 set
  }
}
