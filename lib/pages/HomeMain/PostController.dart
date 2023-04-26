import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/HomeMain/PostContainer.dart/PostContainer.dart';
import 'package:hopeless_romantic/pages/HomeMain/TextPostContainer/TextPostContainer.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostController extends StatefulWidget {
  const PostController({super.key, required this.snap, required this.func});

  final snap;
  final func;

  @override
  State<PostController> createState() => _PostControllerState();
}

class _PostControllerState extends State<PostController> {
  bool postTypeFile = false;
  @override
  Widget build(BuildContext context) {
    void onhandleChange() async {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(widget.snap["postid"])
          .update({
        "viewed": true,
      });
    }

    if (widget.snap["type"] == "post") {
      setState(() {
        postTypeFile = true;
      });
    }

    return VisibilityDetector(
      key: Key(widget.snap["postid"]),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction >= 0.9) {
          onhandleChange();
        }
      },
      child: ShowUpAnimation(
              delayStart: Duration(seconds: 0),
              animationDuration: Duration(milliseconds: 0),
              curve: Curves.ease,
              direction: Direction.horizontal,
              offset: 0.5,
              child: Column(
                children: [
                  postTypeFile
                ? PostContainer(snap: widget.snap, func: widget.func)
                : Container(
                    child: TextPostContainer(
                      snap: widget.snap,
                      header: true,
                      haveLike: true,
                      home: true,
                      topmar: 10.0,
                      fontSize: 15.0,
                      padding: 10.0,
                      height: 490.0,
                      func: widget.func,
                    )
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10))
                ],
              ),
            ),
    );
  }
}