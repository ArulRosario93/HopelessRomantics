import 'dart:async';

import "package:flutter/material.dart";
import 'package:hopeless_romantic/pages/ChatRoom/ChatContainer/ChatContainer.dart';
import 'package:hopeless_romantic/pages/ChatRoom/Chats/HeaderText.dart';
import 'package:show_up_animation/show_up_animation.dart';

class ChatController extends StatefulWidget {
  const ChatController({
    super.key,
    required this.totalLEn,
    required this.snap,
    required this.uid,
    required this.theme,
  });

  final snap;
  final theme;
  final totalLEn;
  final uid;

  @override
  State<ChatController> createState() => _ChatControllerState();
}

class _ChatControllerState extends State<ChatController> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Timer(
      Duration(milliseconds: 0),
      () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          )
        );

    return ListView.builder(
        controller: _scrollController,
        itemCount: widget.totalLEn,
        itemBuilder: ((context, index) {
          String oldSnap = "";
          String newSnap = "";
          String nextSnap = "";
          String preSnap = "";

          bool same;
          bool nexChaned;
          bool prevChanged;
          bool lastone;

          int getINT = index;

          // if (widget.totalLEn - 1 == getINT) {
          //   nextSnap = "";
          // } else {
          //   nextSnap = widget.snap[index + 1]["uid"];
          // }
          newSnap = widget.snap[index]["header"]? "itshead": widget.snap[index]["uid"];
          oldSnap = index - 1 < 0 ? "" : widget.snap[index - 1]["header"]? "head": widget.snap[index - 1]["uid"];

          // if (widget.snap[index]["header"]) {
            if (oldSnap == newSnap) {
              same = false;
              prevChanged = false;
            } else {
              prevChanged = true;
              same = true;
            }

            if (widget.totalLEn == getINT + 1) {
              nextSnap = "";
              lastone = true;
            } else {
              nextSnap = widget.snap[index + 1]["header"]? "": widget.snap[index + 1]["uid"];
              lastone = false;
            }

            if (newSnap == nextSnap) {
              nexChaned = false;
            } else {
              nexChaned = true;
            }

          return widget.snap[index]["header"]
              ? HeaderText(
                  linkId: widget.snap[index]["linkID"],
                  msg: widget.snap[index]["message"],
                  uid: widget.snap[index]["uid"],
                  filePost: widget.snap[index]["filePost"],
                  testPost: widget.snap[index]["textPost"],
                  newUser: widget.snap[index]["newUser"],
                )
              : Column(
                  crossAxisAlignment: widget.snap[index]["uid"] == widget.uid
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                        ShowUpAnimation( 
                        delayStart: Duration(seconds: 0),
                        animationDuration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                        direction: Direction.horizontal,
                        offset: widget.snap[index]["uid"] == widget.uid? 0.5: -0.5,
                        child:  ChatContainer(
                          snap: widget.snap[index],
                          sayIt: same,
                          nexChaned: nexChaned,
                          lastone: lastone,
                          prevChanged: prevChanged,
                          theme: widget.theme,
                          uid: widget.uid),)
                      
                    ]);
        }));
  }
}
