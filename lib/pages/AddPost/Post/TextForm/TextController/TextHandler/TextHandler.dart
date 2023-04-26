import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/TextController/TextHandler/TextEachRight.dart';
import 'package:lottie/lottie.dart';

class TextHandler extends StatefulWidget {
  const TextHandler(
      {super.key,
      required this.texthandling,
      required this.topMar,
      required this.fontSize,
      required this.linkID,
      required this.haveLike,
      this.home,
      required this.height});

  final texthandling;
  final height;
  final linkID;
  final fontSize;
  final topMar;
  final haveLike;
  final home;

  @override
  State<TextHandler> createState() => _TextHandlerState();
}

class _TextHandlerState extends State<TextHandler> {
  int currentField = 0;
  bool load = false;

  var data;

  void changeField(int k) {
    setState(() {
      currentField = k;
    });
    print("Calling IT");
    print(currentField);
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  getData() async {
    final dd = await FirebaseFirestore.instance
        .collection("Posts")
        .doc(widget.linkID)
        .get();

    final bb = dd.data()!;
    setState(() {
      data = bb["uid"];
    });
  }

  @override
  Widget build(BuildContext context) {
    List bb = widget.texthandling;
    double height = MediaQuery.of(context).size.height;
    int len = bb.length;

    void LikeIt() async {
      //LIKING
      setState(() {
        load = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          load = false;
        });
      });
      
      await FirebaseFirestore.instance
          .collection("users")
          .doc(data)
          .update({
        "loves": FieldValue.increment(1),
      });
    }

    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: () {
            LikeIt();
          },
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 15),
            constraints: BoxConstraints(maxHeight: widget.height),
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
        widget.haveLike
            ? load
                ? Container(
                    height: widget.home == true ? 420 : height / 1.3,
                    alignment: Alignment.center,
                    child: Lottie.asset('assets/images/liking.json',
                        frameRate: FrameRate(300.0),
                        repeat: load,
                        width: 310,
                        fit: BoxFit.fitWidth),
                  )
                : Container()
            : Container()
      ],
    );
  }
}