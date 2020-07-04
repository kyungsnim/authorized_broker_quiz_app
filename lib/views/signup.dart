import 'package:authorized_broker_quiz_app/services/firebase_provider.dart';
import 'package:authorized_broker_quiz_app/shared/globals.dart';
import 'package:authorized_broker_quiz_app/widgets/wave_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

SignUpState pageState;

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() {
    pageState = SignUpState();
    return pageState;
  }
}

class SignUpState extends State<SignUp> {
  TextEditingController _emailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();

  String email, password;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  void dispose() {
    _emailCon.dispose();
    _pwCon.dispose();
    super.dispose();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: Duration(seconds: 10),
          backgroundColor: Global.blueSky.withOpacity(0.9),
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
              Text("   Sign up...",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ));
      bool result = await fp.signUpWithEmail(_emailCon.text, _pwCon.text);
      await _scaffoldKey.currentState.hideCurrentSnackBar();
      if (result) {
        Navigator.pop(context);
      } else {
        showLastFBMessage();
      }
    }
  }

  showLastFBMessage() {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 10),
        content: Text(fp.getLastFBMessage()),
        action: SnackBarAction(
          label: "확인",
          textColor: Colors.white,
          onPressed: () {},
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (fp == null) {
      fp = Provider.of<FirebaseProvider>(context);
    }

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
//        appBar: AppBar(
//          title: appBar(context),
//          backgroundColor: Colors.transparent,
//          elevation: 0.0,
//          brightness: Brightness.light,
//          leading: Container(),
//        ),
        body: Stack(children: <Widget>[
          Container(
            height: size.height - 400,
            color: Global.blueSky,
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
                  'Sign up',
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
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: TextFormField(
                      controller: _emailCon,
                      cursorColor: Global.blueSky,
                      validator: (val) {
                        if(val.isEmpty) {
                          return '이메일주소를 입력하세요';
                        }
                        else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              // underline 색상 변경
                              borderSide:
                                  BorderSide(color: Global.blueSky)),
                          icon: Icon(Icons.email, color: Global.blueSky),
                          hintText: '이메일'),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 25),
                    child: TextFormField(
                      controller: _pwCon,
                      obscureText: true, // 비밀번호 가리기
                      cursorColor: Global.strongAmber,
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
                              borderSide:
                                  BorderSide(color: Global.blueSky)),
                          focusColor: Global.blueSky,
                          icon: Icon(
                            Icons.vpn_key,
                            color: Global.blueSky,
                          ),
                          hintText: '비밀번호'),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                  ),
                  Center(
                    child: InkWell(
                        onTap: () {
                          FocusScope.of(context)
                              .requestFocus(new FocusNode()); // 키보드 감추기
                          signUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Global.blueSky,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 50,
                          width: MediaQuery.of(context).size.width *
                              0.88, // 파라미터값 없으면 이걸로
                          child: Text(
                            '회원 가입',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '계정이 있으신가요? ',
                        style: TextStyle(fontSize: 15),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          '로그인',
                          style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
          )
        ]));
  }

  // 부품/제조/서비스팀원 체크
  bool emailCheck(val) {
    bool flag = false;
    var emailDummy = 'km.seok@miracom.co.kr	sysworld@miracom.co.kr	bojeong.ma@miracom.co.kr	juri7.kim@miracom.co.kr	eg0423@miracom.co.kr	nohkk@miracom.co.kr	jk0407.jung@miracom.co.kr	jkl3688.kim@miracom.co.kr	nysong@miracom.co.kr	cs73.yoon@miracom.co.kr	byonggoo.lee@miracom.co.kr	kk5.oh@miracom.co.kr	ck78.kim@miracom.co.kr	minsik.jang@miracom.co.kr	kh1.hwang@miracom.co.kr	yw0622.kang@miracom.co.kr	nanyun.kim@miracom.co.kr	uc82.jung@miracom.co.kr	ju0823.shin@miracom.co.kr	sj1102.kwon@miracom.co.kr	bora1115.kim@miracom.co.kr	seunghoi.heo@miracom.co.kr	smworld.park@miracom.co.kr	ih2.lee@miracom.co.kr	kwangch.lee@miracom.co.kr	yk725.ko@miracom.co.kr	retry78.kim@miracom.co.kr	ah.son@miracom.co.kr	ty74.kim@miracom.co.kr	th0521.kim@miracom.co.kr	kh081.kim@miracom.co.kr	heechul81.kim@miracom.co.kr	hyungjin.cho@miracom.co.kr	eunjin.mun@miracom.co.kr	daehwi.kim@miracom.co.kr	jh6.ma@miracom.co.kr	sh.bak@miracom.co.kr	jy0217.park@miracom.co.kr	hyeonju.park@miracom.co.kr	mj.bang@miracom.co.kr	mw.shin@miracom.co.kr	sb1225.lee@miracom.co.kr	geonmo.kang@miracom.co.kr	younggi.seoul@miracom.co.kr	kj1549.cho@miracom.co.kr	jy7417.kim@miracom.co.kr	bogun78.kim@miracom.co.kr	sujin83.ahn@miracom.co.kr	jt99.jang@miracom.co.kr	ks1208.min@miracom.co.kr	hj0107.bae@miracom.co.kr	sm96.park@miracom.co.kr	moya.yang@miracom.co.kr	ji1208.lee@miracom.co.kr	hj0724.kim@miracom.co.kr	jm1001.park@miracom.co.kr	jongo.lim@miracom.co.kr	hwoo.ahn@miracom.co.kr	jin.bae@miracom.co.kr	taehwa73.lee@miracom.co.kr	iluveyou.yoo@miracom.co.kr	km99.lee@miracom.co.kr	jys.oh@miracom.co.kr	jo81.kim@miracom.co.kr	sungyune.yoo@miracom.co.kr	hb.yim@miracom.co.kr	dalyong.hong@miracom.co.kr	jp0317.shin@miracom.co.kr	sy157.jeong@miracom.co.kr	unauna.kim@miracom.co.kr	eunseon.seo@miracom.co.kr	hyunchul.kwon@miracom.co.kr	kn1126.kim@miracom.co.kr	ilgu.seo@miracom.co.kr	jayoung7.lee@miracom.co.kr	naeuk.kim@miracom.co.kr	jh206.lee@miracom.co.kr	minwoo.park@miracom.co.kr	sokwon.son@miracom.co.kr	sanghwi0104.kim@miracom.co.kr	inbae.mun@miracom.co.kr	ymzzang.choi@miracom.co.kr	jongseong.park@miracom.co.kr	jsik.cho@miracom.co.kr	fyah.cho@miracom.co.kr	dong86.kim@miracom.co.kr	yshin.joo@miracom.co.kr	yuri328.choi@miracom.co.kr	hun1013.kim@miracom.co.kr	eg.jun@miracom.co.kr	hougun.yoon@miracom.co.kr	hs9.yoon@miracom.co.kr	dongjo.shin@miracom.co.kr	mhmh.lee@miracom.co.kr	heesoo12.moon@miracom.co.kr	yp1029.hong@miracom.co.kr	my0735.jung@miracom.co.kr	bj0206.park@miracom.co.kr	jaehun88.kim@miracom.co.kr	mk80.sung@miracom.co.kr	coverme.kim@miracom.co.kr	shju.moon@miracom.co.kr	seyun82.park@miracom.co.kr	minchul.bae@miracom.co.kr	hyochang.an@miracom.co.kr	yt83.han@miracom.co.kr	sola88.lee@miracom.co.kr	wg5339.kim@miracom.co.kr	tw.kim@miracom.co.kr	yoonji06.lee@miracom.co.kr	sy44.baek@miracom.co.kr	par.yang@miracom.co.kr	jh.no1.park@miracom.co.kr	jihun.lim@miracom.co.kr	gunwoo24.lee@miracom.co.kr	cocopam.lim@miracom.co.kr	ys1894.park@miracom.co.kr	yj23.kang@miracom.co.kr	jaedong209.kim@miracom.co.kr	hm7747.shin@miracom.co.kr	ks0220.seo@miracom.co.kr	cheol.jung@miracom.co.kr	sokna.kang@miracom.co.kr	wr.moon@miracom.co.kr	youngshik.you@miracom.co.kr	ks9419.seo@miracom.co.kr	sc5218.yang@miracom.co.kr	bg.yu@miracom.co.kr	daehyun3274.cho@miracom.co.kr	inhwa.heo@miracom.co.kr	kim83sk.kim@miracom.co.kr	nice235.lee@miracom.co.kr	ms0903.seo@miracom.co.kr	hhhjin.lim@miracom.co.kr	je1984.choi@miracom.co.kr	junekyu.sim@miracom.co.kr	jy_0716.kim@miracom.co.kr	jieun48.kim@miracom.co.kr	kyeongse.son@miracom.co.kr	sj616.lee@miracom.co.kr	d0214.jeong@miracom.co.kr	hg.kwak@miracom.co.kr	sangmini.choi@miracom.co.kr	go4342.ko@miracom.co.kr	changhwa.seo@miracom.co.kr	eunbyul.lee@miracom.co.kr	manwoo75.lee@miracom.co.kr	ggamzice.kim@miracom.co.kr	ty80.yeom@miracom.co.kr	eunhye.lim@miracom.co.kr	jongkun.man@miracom.co.kr	taewoo.kang@miracom.co.kr	suhee24.kim@miracom.co.kr	sw1016.baek@miracom.co.kr	hw84.jeong@miracom.co.kr	yh84.jang@miracom.co.kr	ys235.lee@miracom.co.kr	sm84.hwang@miracom.co.kr	mw327.lee@miracom.co.kr	hayeon.so@miracom.co.kr	minyong.jeon@miracom.co.kr	ms077.kim@miracom.co.kr	jongmi3.kim@miracom.co.kr	sehuan.park@miracom.co.kr	jinmi21.lee@miracom.co.kr	eunsoo.yeo@miracom.co.kr	ssum.choi@miracom.co.kr	dk03.jang@miracom.co.kr	sj128.han@miracom.co.kr	kyunggon.lee@miracom.co.kr	jum73.lee@miracom.co.kr	younsu1.kim@miracom.co.kr	mico.seo@miracom.co.kr	jc1111.hwang@miracom.co.kr	sy0721.lee@miracom.co.kr	ganada00.chio@miracom.co.kr	kb0628.song@miracom.co.kr	pippen.kim@miracom.co.kr	th6482.kim@miracom.co.kr	hk830728.kim@miracom.co.kr	mingi.min@miracom.co.kr	jy1006.lee@miracom.co.kr	hh.jeon84@miracom.co.kr	sp11.hong@miracom.co.kr	sj9966.yang@miracom.co.kr	woos.jung@miracom.co.kr	jeho.lee@miracom.co.kr	ama.kim@miracom.co.kr	inhyeon.b@miracom.co.kr	jg.back@miracom.co.kr	s20w.lee@miracom.co.kr	sooonjae.lee@miracom.co.kr	sw77.park@miracom.co.kr	haeyong.joo@miracom.co.kr	dongwon.cha@miracom.co.kr	wh.choiv6@miracom.co.kr	lakhyun.kim@miracom.co.kr	core.kim@miracom.co.kr	oleg.choi@miracom.co.kr	minjin21.jang@miracom.co.kr	ht777.jung@miracom.co.kr	gt.yim@miracom.co.kr	byungsu29.kim@miracom.co.kr	sami3232.son@miracom.co.kr	juee2.lim@miracom.co.kr	jihoon85.kim@miracom.co.kr	kang80.lee@miracom.co.kr	sukmin7.kang@miracom.co.kr	minseok.song@miracom.co.kr	jh0819.yoon@miracom.co.kr	sc.jin@miracom.co.kr	yun.kyoung@miracom.co.kr	nyoung.yoo@miracom.co.kr	ys106.yoo@miracom.co.kr	jc2.lee@miracom.co.kr	jungwan.woo@miracom.co.kr	changho.myung@miracom.co.kr	sg.bang@miracom.co.kr	sh7979.kim@miracom.co.kr	sh798.kim@miracom.co.kr	mhcho.cho@miracom.co.kr	yeonjeong.yu@miracom.co.kr	hseok.kang@miracom.co.kr	sungwon.oh@miracom.co.kr	dm.kwak@miracom.co.kr	jinjoo.park@miracom.co.kr	jy1111.seong@miracom.co.kr	duckhyun.yu@miracom.co.kr	yongho.ma@miracom.co.kr	daekyung.lee@miracom.co.kr	seonki01.lee@miracom.co.kr	sh1985.hwang@miracom.co.kr	daebok00.lee@miracom.co.kr	jh.gan@miracom.co.kr	yeriy.kim@miracom.co.kr	junyong.han@miracom.co.kr	msap.yu@miracom.co.kr	jh109.lee@miracom.co.kr	sd23.lim@miracom.co.kr	red.cho@miracom.co.kr	sjap.park@miracom.co.kr	sy.k.choi@miracom.co.kr	namsoo.baik@miracom.co.kr	myojung.suh@miracom.co.kr	hyuntae.oh@miracom.co.kr	mh85.yoon@miracom.co.kr	hh11.nam@miracom.co.kr	eunkyu.kang@miracom.co.kr	dongjin81.shin@miracom.co.kr	ch0509.park@miracom.co.kr	sj1004.choi@miracom.co.kr	jy0622.shim@miracom.co.kr	klaus.kim@miracom.co.kr	yena.woo@miracom.co.kr	hyunbo.shim@miracom.co.kr	bg1249.choi@miracom.co.kr	yoma.kim@miracom.co.kr	autocrat.kim@miracom.co.kr	sh1224.park@miracom.co.kr	yj1204.jang@miracom.co.kr	yunseo.lee@miracom.co.kr	js1230.lee@miracom.co.kr	bora611.kim@miracom.co.kr	jayhee.lee@miracom.co.kr	heeeun86.lee@miracom.co.kr	kyungsoo.hwang@miracom.co.kr	hanwoonghanwoong.lee@miracom.co.kr	jhpark.park@miracom.co.kr	hayoung1.kim@miracom.co.kr	hm1257.son@miracom.co.kr	js0920.choi@miracom.co.kr	dw0426.kang@miracom.co.kr	soomin2.ahn@miracom.co.kr	ena.chun@miracom.co.kr	js0302.shin@miracom.co.kr	sm0904.jang@miracom.co.kr	dy1019.kim@miracom.co.kr	dahjoung.kim@miracom.co.kr	jh53.lee@miracom.co.kr	ys0201.han@miracom.co.kr	minho89.kim@miracom.co.kr	nari.shon@miracom.co.kr	dlrudtn.lee@miracom.co.kr	kw1030.kim@miracom.co.kr	sh0205.lee@miracom.co.kr	yangwon.lee@miracom.co.kr	yunseon.lee@miracom.co.kr	sj83.jung@miracom.co.kr	mj.nam@miracom.co.kr	minae.kang@miracom.co.kr	yoosup.song@miracom.co.kr	choongki.kim@miracom.co.kr	yeonjin.yoon@miracom.co.kr	haemin00.lee@miracom.co.kr	myunghwan725.lee@miracom.co.kr	namki81.yoo@miracom.co.kr	sang80.jun@miracom.co.kr	js0000.kim@miracom.co.kr	my.bae@miracom.co.kr	wani.lee@miracom.co.kr	kkh84.kim@miracom.co.kr	dw05.choi@miracom.co.kr	minji89.son@miracom.co.kr	sh8823.lee@miracom.co.kr	seongsu2.kim@miracom.co.kr	sk7020.kwon@miracom.co.kr	giseon77.kim@miracom.co.kr	ay0115.kim@miracom.co.kr	yjinb.bae@miracom.co.kr	gyeongm.jang@miracom.co.kr	pby.0716@miracom.co.kr	byeonghun.jo@miracom.co.kr	syyeom.yeom@miracom.co.kr	yejjin.song@miracom.co.kr	jihoon5.song@miracom.co.kr	hr6.hwang@miracom.co.kr	kh414.kim@miracom.co.kr	youshin.kim@miracom.co.kr	kr1004.kim@miracom.co.kr	heunwoo.han@miracom.co.kr	mjay7.kim@miracom.co.kr	hyunjung0.jo@miracom.co.kr	sangwoox.lee@miracom.co.kr	noel.jc.lee@miracom.co.kr	pg1213.kwon@miracom.co.kr	kj0802.park@miracom.co.kr	kyujin17.lim@miracom.co.kr	ks999.choi@miracom.co.kr	eunhee7.choi@miracom.co.kr	soyoung0.kim@miracom.co.kr	sunglyong.lim@miracom.co.kr	bj55.park@miracom.co.kr	suhyung.lee@miracom.co.kr	jw0405.kim@miracom.co.kr	jongsu0316.kim@miracom.co.kr	kh0403.yoo@miracom.co.kr	yw0512.jung@miracom.co.kr	hyi0721.yoon@miracom.co.kr	cheol.choi@miracom.co.kr	jin-won.lee@miracom.co.kr	junhyuk.seo@miracom.co.kr	youngjae.hwang@miracom.co.kr	dh0429.jung@miracom.co.kr	jaewoo97.kim@miracom.co.kr	juhyun12.kim@miracom.co.kr	gyuil.choi@miracom.co.kr	bora110.kim@miracom.co.kr	jh881121.kim@miracom.co.kr	jy234.lee@miracom.co.kr';
    List<String> email = emailDummy.split('\t');

    for(int i = 0; i < email.length; i++){
      print(val + ' ' + email[i]);
      if(val == email[i]) {
        print('ddddd');
        flag = true;
        return flag;
      }
    }
    return flag;
  }
}
