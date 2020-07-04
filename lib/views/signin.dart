import 'package:authorized_broker_quiz_app/services/firebase_provider.dart';
import 'package:authorized_broker_quiz_app/shared/globals.dart';
import 'package:authorized_broker_quiz_app/views/signup.dart';
import 'package:authorized_broker_quiz_app/widgets/wave_widget.dart';
import 'package:authorized_broker_quiz_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SignInState pageState;

class SignIn extends StatefulWidget {
  @override
  SignInState createState() {
    pageState = SignInState();
    return pageState;
  }
}

class SignInState extends State<SignIn> {
  TextEditingController _emailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();
  TextEditingController _resetPwEmailCon = TextEditingController();
  String email, password, resetPwEmail;
  bool doRemember = false;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  void initState() {
    super.initState();
    getRememberInfo();
  }

  @override
  void dispose() {
    setRememberInfo();
    _emailCon.dispose();
    _pwCon.dispose();
    _resetPwEmailCon.dispose();
    super.dispose();
  }

  void signIn() async {
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            backgroundColor: Global.redSun.withOpacity(0.9),
            duration: Duration(seconds: 10),
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                Text(
                  '   Login...',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
              ],
            )));
      bool result = await fp.signInWithEmail(_emailCon.text, _pwCon.text);
      _scaffoldKey.currentState.hideCurrentSnackBar();
      if (result == false) showLastFBMessage();
    }
  }

  getRememberInfo() async {
    logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool('doRemember') ?? false);
    });
    if (doRemember) {
      setState(() {
        _emailCon.text = (prefs.getString('userEmail') ?? "");
        _pwCon.text = (prefs.getString('userPassword') ?? "");
      });
    }
  }

  setRememberInfo() async {
    logger.d(doRemember);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('doRemember', doRemember);
    if (doRemember) {
      prefs.setString('userEmail', _emailCon.text);
      prefs.setString('userPassword', _pwCon.text);
    }
  }

  showLastFBMessage() {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: Global.redSun,
        duration: Duration(seconds: 10),
        content: Text(fp.getLastFBMessage()),
        action: SnackBarAction(
            label: '확인', textColor: Colors.white, onPressed: () {}),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    fp = Provider.of<FirebaseProvider>(context);

//    logger.d(fp.getUser());
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Global.white,
//      appBar: AppBar(
//        title: appBar(context),
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,
//        brightness: Brightness.light,
//        leading: Container(),
//      ),
      body: Stack(children: <Widget>[
        Container(
          height: size.height - 400,
          color: Global.redSun,
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuad,
          top: 0.0,
          child: WaveWidget(
            size: size,
            yOffset: size.height / 4.0,
            color: Global.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Login',
                style: TextStyle(
                  color: Global.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black54,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Form(
          key: _formKey,
          child: Container(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 5),
                  child: TextFormField(
                    controller: _emailCon,
                    cursorColor: Global.redSun,
                    validator: (val) {
                      if (val.isEmpty) {
                        return '이메일주소를 입력하세요';
                      }
                      else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            // underline 색상 변경
                            borderSide: BorderSide(color: Global.redSun)),
                        icon: Icon(Icons.email, color: Global.redSun),
                        hintText: '이메일'),
                    onChanged: (val) {
                      email = val;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: TextFormField(
                    controller: _pwCon,
                    obscureText: true,
                    // 비밀번호 가리기
                    cursorColor: Global.redSun,
                    validator: (val) {
                      if (val.length < 6) {
                        return '6자 이상의 비밀번호를 사용하세요.';
                      } else {
                        return val.isEmpty ? '비밀번호를 입력하세요' : null;
                      }
                    },
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            // underline 색상 변경
                            borderSide: BorderSide(color: Global.redSun)),
                        focusColor: Global.redSun,
                        icon: Icon(
                          Icons.vpn_key,
                          color: Global.redSun,
                        ),
                        hintText: '비밀번호'),
                    onChanged: (val) {
                      password = val;
                    },
                  ),
                ),
                // Remember me
                Container(
                    margin: const EdgeInsets.fromLTRB(25, 5, 25, 25),
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: Global.redSun,
                          value: doRemember,
                          onChanged: (newValue) {
                            setState(() {
                              doRemember = newValue;
                            });
                          },
                        ),
                        Text('이메일 기억하기')
                      ],
                    )),
                // Alert Box
                (fp.getUser() != null && fp.getUser().isEmailVerified == false)
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '이메일 인증이 되지 않았습니다.\n인증을 완료해주세요.',
                                style: TextStyle(color: Global.redSun),
                              ),
                            ),
                            RaisedButton(
                              color: Global.redSun,
                              textColor: Colors.white,
                              child: Text('인증메일 다시 보내기'),
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode()); // 키보드 감추기
                                fp.getUser().sendEmailVerification();
                              },
                            )
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context)
                          .requestFocus(new FocusNode()); // 키보드 감추기
                      signIn();
                    },
                    child: blueButton(context: context, text: '로그인'),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '아이디가 없으세요? ',
                      style: TextStyle(fontSize: 15),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                            fontSize: 15, decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '비밀번호 기억이 안나세요? ',
                      style: TextStyle(fontSize: 15),
                    ),
                    InkWell(
                      onTap: () {
                        _onResetPasswordPressed();
                      },
                      child: Text(
                        '비밀번호 재설정',
                        style: TextStyle(
                            fontSize: 15, decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
        ),
      ]),
    );
  }

  // resetPassword 이메일 입력
  Future<bool> _onResetPasswordPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("${_emailCon.text}로\n비밀번호 재설정 메일을 발송하시겠습니까?",
                style: TextStyle(fontSize: 15)),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "발송",
                  style: TextStyle(fontSize: 18, color: Global.redSun),
                ),
                onPressed: () async {
                  await fp.fAuth.sendPasswordResetEmail(email: _emailCon.text);
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text(
                  "취소",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ) ??
        false;
  }
}
