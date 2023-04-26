import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/TextController/TextHandler/TextEachRight.dart';
import 'package:lottie/lottie.dart';

class TextHandlerTwo extends StatefulWidget {
  const TextHandlerTwo({
    super.key,
    required this.texthandling,
    required this.topMar,
    required this.fontSize,
  });

  final texthandling;
  final fontSize;
  final topMar;

  @override
  State<TextHandlerTwo> createState() => _TextHandlerTwoState();
}

class _TextHandlerTwoState extends State<TextHandlerTwo> {
  int currentField = 0;
  bool load = false;

  void changeField(int k) {
    setState(() {
      currentField = k;
    });
    print("Calling IT");
    print(currentField);
  }

  @override
  Widget build(BuildContext context) {
    List bb = widget.texthandling;

    int len = bb.length;

    void LikeIt() {
      //LIKING
      setState(() {
        load = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          load = false;
        });
      });
    }

    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: () {
            LikeIt();
          },
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 520,
              minHeight: 400,
            ),
            child: PageView(
              onPageChanged: (value) {
                changeField(value);
              },
              children: <Widget>[
                for (var i = 0; i < len; i++)
                  TextEachRight(
                    curenntField: i,
                    texthandling: widget.texthandling,
                    fontSize: widget.fontSize,
                  )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: widget.topMar),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < len; i++)
                i == currentField
                    ? Container(
                        child: Text(
                          ".",
                          style: TextStyle(fontSize: 30, color: Colors.red),
                        ),
                      )
                    : Container(
                        child: Text(
                          ".",
                          style: TextStyle(fontSize: 30, color: Colors.blue),
                        ),
                      )
            ],
          ),
        ),
      ],
    );
  }
}
