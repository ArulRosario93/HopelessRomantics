import 'package:flutter/material.dart';

class TextEachRight extends StatefulWidget {
  const TextEachRight({
    super.key,
    required this.curenntField,
    required this.texthandling,
    required this.fontSize,
  });

  final curenntField;
  final texthandling;
  final fontSize;

  @override
  State<TextEachRight> createState() => _TextEachRightState();
}

class _TextEachRightState extends State<TextEachRight> {
  @override
  void initState() {
    // widget.changeField(widget.curenntField);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: EdgeInsets.only(top: 25),
      alignment: widget.texthandling[widget.curenntField]
                  ["textField${widget.curenntField}"][1] ==
              1
          ? Alignment.center
          : widget.texthandling[widget.curenntField]
                      ["textField${widget.curenntField}"][1] ==
                  0
              ? Alignment.centerLeft
              : Alignment.centerRight,
      // width: 50,
      // height: 200,
      child: Text(
        "${widget.texthandling[widget.curenntField]["textField${widget.curenntField}"][0]}",
        textAlign: widget.texthandling[widget.curenntField]
                    ["textField${widget.curenntField}"][1] ==
                1
            ? TextAlign.center
            : widget.texthandling[widget.curenntField]
                        ["textField${widget.curenntField}"][1] ==
                    0
                ? TextAlign.left
                : TextAlign.right,
        style: TextStyle(fontSize: widget.fontSize, color: Colors.white ), 
      ),
    );
  }
}
