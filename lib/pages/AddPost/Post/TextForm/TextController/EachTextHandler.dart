import 'package:flutter/material.dart';

class EachTextHandler extends StatefulWidget {
  const EachTextHandler(
      {super.key,
      required this.addIT,
      required this.getIT,
      required this.removeSlide,
      required this.initialtextValue,
      required this.addPage,
      required this.currentField});

  final addIT;
  final addPage;
  final removeSlide;
  final initialtextValue;
  final getIT;
  final currentField;

  @override
  State<EachTextHandler> createState() => _EachTextHandlerState();
}

class _EachTextHandlerState extends State<EachTextHandler> {
  late int selectedFormat;

  TextEditingController editIt = TextEditingController();

  @override
  void initState() {
    // print(widget.initialtextValue["textField${widget.currentField}"]);
    String textHere =
        widget.initialtextValue["textField${widget.currentField}"][0];

    setState(() {
      selectedFormat =
          widget.initialtextValue["textField${widget.currentField}"][1];
      // editIt.text = ;
      // selectedFormat = alignWhere.isNaN ? 1: widget.initialtextValue["textField${widget.currentField}"][1];
      editIt.text = textHere.length > 0
          ? widget.initialtextValue["textField${widget.currentField}"][0]
          : "";
    });
    super.initState();
  }

  @override
  void dispose() {
    editIt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void changeFormat(int i) {
      setState(() {
        selectedFormat = i;
      });
      // print(widget.initialtextValue);
      // print(editIt.text);
      widget.getIT(editIt.text, widget.currentField, selectedFormat);
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Column(children: [
          TextField(
            onChanged: (value) {
              widget.getIT(editIt.text, widget.currentField, selectedFormat);
            },
            
            textAlignVertical: TextAlignVertical.center,
            smartQuotesType: SmartQuotesType.enabled,
            smartDashesType: SmartDashesType.enabled,
            textCapitalization: TextCapitalization.sentences,
            controller: editIt,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            minLines: 3,
            maxLength: 700,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            textAlign: selectedFormat == 1
                ? TextAlign.center
                : selectedFormat == 0
                    ? TextAlign.left
                    : TextAlign.right,
            decoration: InputDecoration(
              fillColor: Color.fromARGB(36, 158, 158, 158),
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(style: BorderStyle.none)),
              hintText: "Start Writing",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(style: BorderStyle.none)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      child: TextButton(
                        onPressed: () {
                          changeFormat(0);
                        },
                        child: Icon(
                          Icons.format_align_left,
                          size: 18,
                          color: selectedFormat == 0
                              ? Colors.black
                              : Color.fromARGB(255, 100, 100, 100),
                        ),
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.symmetric(horizontal: 4),
                      child: TextButton(
                        onPressed: () {
                          changeFormat(1);
                        },
                        child: Icon(
                          Icons.format_align_center,
                          size: 18,
                          color: selectedFormat == 1
                              ? Colors.black
                              : Color.fromARGB(255, 100, 100, 100),
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {
                          changeFormat(2);
                        },
                        child: Icon(Icons.format_align_right,
                            size: 18,
                            color: selectedFormat == 2
                                ? Colors.black
                                : Color.fromARGB(255, 100, 100, 100)),
                      ),
                    ),
                  ],
                ),
              ),
              widget.addPage == widget.currentField
                  ? editIt.text.length >= 5? Container(
                      child: TextButton(
                      onPressed: () {
                        // print(editIt.text);
                        widget.addIT(editIt.text, selectedFormat);
                        // print(widget.initialtextValue);
                        // print(editIt.text);
                      },
                      child: Icon(Icons.add),
                    )) : Container()
                  : Container(),
            ],
          ),
        ]));
  }
}
