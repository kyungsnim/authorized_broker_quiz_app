import 'package:authorized_broker_quiz_app/shared/globals.dart';
import 'package:flutter/material.dart';

// 자주 사용하는 위젯들 따로 빼놓자
Widget appBar(BuildContext context) {
  return RichText(
      text: TextSpan(style: TextStyle(fontSize: 20), children: <TextSpan>[
        TextSpan(
          text: '쉽',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Global.redSun,
            shadows: [
              Shadow(
                  offset: Offset(0.5, 0.5),
                  color: Colors.black54,
                  blurRadius: 3
              ),
            ],
          ),
        ),
        TextSpan(
            text: '게',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey,
            shadows: [
              Shadow(
                offset: Offset(0.5, 0.5),
                color: Colors.black54,
                blurRadius: 3
              ),
            ],
          ),
        ),
        TextSpan(
          text: ' 따',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Global.redSun,
            shadows: [
              Shadow(
                  offset: Offset(0.5, 0.5),
                  color: Colors.black54,
                  blurRadius: 3
              ),
            ],
          ),
        ),
        TextSpan(
          text: '는',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey,
            shadows: [
              Shadow(
                  offset: Offset(0.5, 0.5),
                  color: Colors.black54,
                  blurRadius: 3
              ),
            ],
          ),
        ),
        TextSpan(
          text: ' 공',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Global.redSun,
            shadows: [
              Shadow(
                  offset: Offset(0.5, 0.5),
                  color: Colors.black54,
                  blurRadius: 3
              ),
            ],
          ),
        ),
        TextSpan(
          text: '인중개사',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey,
            shadows: [
              Shadow(
                  offset: Offset(0.5, 0.5),
                  color: Colors.black54,
                  blurRadius: 3
              ),
            ],
          ),
        ),
      ]
    )
  );
}

Widget blueButton({BuildContext context, String text, buttonWidth}) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Global.redSun,
      borderRadius: BorderRadius.circular(20),
    ),
    height: 50,
    width: buttonWidth != null // width가 파라미터로 넘어오면
        ? buttonWidth // 넘어온 길이로 하고
        : MediaQuery.of(context).size.width * 0.88, // 파라미터값 없으면 이걸로
    child: Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
