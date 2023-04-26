import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/HomeMain/PostController.dart';

class PostHandler extends StatefulWidget {
  const PostHandler({
    super.key,
    required this.snap,
    required this.length,
    required this.func,
  });

  final snap;
  final length;
  final func;

  @override
  State<PostHandler> createState() => _PostHandlerState();
}

class _PostHandlerState extends State<PostHandler> {
  List snaps = [];
  List finalizingDocumentedSnaps = [];
  bool isImage = false;
  String format = "";

  ScrollController _scrollController = new ScrollController();

  int endPoint = 10;

  int boundary = 10;

  @override
  void initState() {
    addSnaps();
    validateData();
    super.initState();
  }

  void addSnaps() {
    for (var i = 0; i < widget.length; i++) {
      // List findFormat = widget.snap[i]["postURL"];

      if (widget.snap[i]["type"] == "post") {
        String pathHere = widget.snap[i]["postURL"][0];
        Uri uri = Uri.parse(pathHere);
        String exIt = uri.path;
        String getExten = exIt.substring(exIt.length - 3).toLowerCase();
        if (getExten == "mp4") {
          setState(() {
            format = "Video";
          });
        } else if (getExten == "jpg") {
          setState(() {
            format = "Photo";
          });
        } else if (getExten == "peg") {
          setState(() {
            format = "Photo";
          });
        } else if (getExten == "png") {
          setState(() {
            format = "Photo";
          });
        }
      } else {
        setState(() {
          format = "Text";
        });
      }

      final listItem = {
        "snap": widget.snap[i],
        "type": widget.snap[i]["type"],
        "format": format,
      };
      snaps.add(listItem);
    }

    print("Validation Completed");
    print(snaps);
  }

  validateData() {
    final items = [];
    final secondItems = [];
    for (var i = 0; i < boundary; i++) {
      if (i < 2) {
        items.add({"snap": snaps[i]["snap"], "format": snaps[i]["format"]});
      }

      if (i > 1) {
        int count = 0;
        if (snaps[i]["format"] == "Video") {
          print("Video Found $i");

          for (var j = 0; j < items.length; j++) {
            if (items[j]["format"] == "Video") {
              count = count + 1;
            }
          }
          print("Video in itemsAlready $count");

          if (count == 2) {
            print("Avoided Video ${snaps[i]}");
            setState(() {
              boundary = boundary + 1;
            });
          } else {
            print("AddingVideo");
            items.add({"snap": snaps[i]["snap"], "format": snaps[i]["format"]});
          }
        } else {
          print("Video Not Found $i");
          items.add({"snap": snaps[i]["snap"], "format": snaps[i]["format"]});
        }
      }
    }

    setState(() {
      finalizingDocumentedSnaps = items;
    });

    print("Validation Partially Completed!");
    print(finalizingDocumentedSnaps.length);
    print(finalizingDocumentedSnaps);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget.length >= 1
            ? Center(
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                for (var i = 0; i < finalizingDocumentedSnaps.length - 1; i++)
                  PostController(
                      snap: finalizingDocumentedSnaps[i]["snap"],
                      func: widget.func)
              ])))
            : Container(
                child: Text(
                  "Nothing yet",
                  style: TextStyle(color: Colors.amberAccent),
                ),
              ));
  }
}
