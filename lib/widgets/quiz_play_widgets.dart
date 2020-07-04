import 'package:flutter/material.dart';

// 문제 푸는 사람이 어떤 보기 체크하는지 파악이 필요하므로 stful widget으로 생성
class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  final bool isViewAnswer;

  OptionTile({@required this.option,
    @required this.optionSelected,
    @required this.correctAnswer,
    @required this.description,
    @required this.isViewAnswer});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white10)), // 보기박스 테두리
      child: Row(
        // 일반적으로 나타나는 보기의 색상, 사용자가 선택한 보기와 일치하면 초록색
        // 일치하지 않으면 빨간색으로 나타나도록 로직을 표현해야 함
          children: <Widget>[
      widget.isViewAnswer ? (widget.description == widget.optionSelected &&
      widget.optionSelected == widget.correctAnswer) ||
          (widget.description == widget.correctAnswer)
          ? Text("정답", style: TextStyle(color: Colors.red.withOpacity(0.6)),)
          : widget.optionSelected != widget.correctAnswer &&
          widget.description == widget.optionSelected
          ? Text("선택", style: TextStyle(color: Colors.blue.withOpacity(0.6)),)
          : Text("메롱", style: TextStyle(color: Colors.grey.withOpacity(0.0))) : Container(),
      Container(
        // A,B,C,D 보기 동그라미
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              // 정답보기모드일때 : 내가고른게 정답이거나, 내가 오답골랐을때 실제 정답은 초록색
                color: widget.isViewAnswer
                    ? ((widget.description == widget.optionSelected &&
                    widget.optionSelected ==
                        widget.correctAnswer) ||
                    (widget.description == widget.correctAnswer)
                    ? Colors.red.withOpacity(0.6)
                    : widget.optionSelected != widget.correctAnswer &&
                    widget.description ==
                        widget.optionSelected
                    ? Colors.blue.withOpacity(0.6)
                    : Colors.black87)
                    : (widget.description == widget.optionSelected
                    ? Colors.blue.withOpacity(0.6)
                    : Colors.black87),
                width: widget.isViewAnswer
                    ? (widget.description == widget.optionSelected &&
                    widget.optionSelected ==
                        widget.correctAnswer) ||
                    (widget.description == widget.correctAnswer)
                // 정답&풀이 보기일 때만 굵기 적용, 나머지는 모두 굵기 동일
                    ? 2
                    : 1
                    : 1)),
        child: Text("${widget.option}",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: widget.isViewAnswer
                  ? ((widget.description == widget.optionSelected &&
                  widget.optionSelected ==
                      widget.correctAnswer) ||
                  (widget.description == widget.correctAnswer)
                  ? Colors.red.withOpacity(0.6)
                  : widget.optionSelected != widget.correctAnswer &&
                  widget.description == widget.optionSelected
                  ? Colors.blue.withOpacity(0.6)
                  : Colors.black87)
                  : (widget.description == widget.optionSelected
                  ? Colors.blue.withOpacity(0.6)
                  : Colors.black87),
            )),
      ),
      SizedBox(width: 10),
      Flexible(
        child: Card(
          color: Colors.white.withOpacity(0.0), // 보기 배경 투명하게
          elevation: 0.0, // 보기 박스 그림자 없게
          child: Container(
            width: size.width,
            color: Colors.white.withOpacity(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.isViewAnswer
                        ? ((widget.description == widget.optionSelected &&
                        widget.optionSelected ==
                            widget.correctAnswer) ||
                        (widget.description == widget.correctAnswer)
                        ? Colors.red.withOpacity(0.6)
                        : widget.optionSelected !=
                        widget.correctAnswer &&
                        widget.description ==
                            widget.optionSelected
                        ? Colors.blue.withOpacity(0.6)
                        : Colors.black87)
                        : (widget.description == widget.optionSelected
                        ? Colors.blue.withOpacity(0.6)
                        : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ],
    ));
  }
}

class InfoQuestion extends StatefulWidget {
  final String text;
  final int number;

  InfoQuestion({this.text, this.number});

  @override
  _InfoQuestionState createState() => _InfoQuestionState();
}

class _InfoQuestionState extends State<InfoQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: Colors.indigo),
            child: Text(
              "${widget.number}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.lightGreen),
            child: Text(
              "${widget.text}",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
