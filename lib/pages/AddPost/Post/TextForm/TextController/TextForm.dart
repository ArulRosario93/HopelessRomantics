import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:uuid/uuid.dart';
import 'package:hopeless_romantic/Authentication/AuthMethods.dart';
import 'package:hopeless_romantic/Models/TextPost.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/TextController/TextContainer.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/TextController/TextHandler/TextHandler.dart';
import 'package:hopeless_romantic/variables.dart' as variables;

class TextForm extends StatefulWidget {
  const TextForm({super.key, required this.haveLike});

  final haveLike;
  // final geitDONE;

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  TextEditingController _TextWritin1 = TextEditingController();
  TextEditingController _TextWritin2 = TextEditingController();

  bool connectionStatus = false;
  bool valid = false;

  var mmm;

  List nn = [];

  @override
  void initState() {
    controlMusic();
    connectionCheck();
    super.initState();
  }

  void controlMusic() async {
    if (variables.playing) {
      Future.delayed(Duration(milliseconds: 100),
          () => {variables.audioPlayer.setVolume(0.9)});
      Future.delayed(Duration(milliseconds: 250),
          () => {variables.audioPlayer.setVolume(0.8)});
      Future.delayed(Duration(milliseconds: 350),
          () => {variables.audioPlayer.setVolume(0.7)});
      Future.delayed(Duration(milliseconds: 450),
          () => {variables.audioPlayer.setVolume(0.6)});
      Future.delayed(Duration(milliseconds: 550),
          () => {variables.audioPlayer.setVolume(0.5)});
      Future.delayed(Duration(milliseconds: 650),
          () => {variables.audioPlayer.setVolume(0.4)});
      Future.delayed(
          Duration(seconds: 1), () => {variables.audioPlayer.setVolume(0.3)});
      Future.delayed(
          Duration(milliseconds: 1500), () => {variables.audioPlayer.setVolume(0.2)});
      Future.delayed(
          Duration(milliseconds: 2100), () => {variables.audioPlayer.setVolume(0.1)});
      Future.delayed(Duration(milliseconds: 3500),
          () async => {await variables.audioPlayer.pause()});
    }
  }

  void connectionCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connectionStatus = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connectionStatus = true;
      });
    } else {
      setState(() {
        connectionStatus = false;
      });
    }
  }

  @override
  void dispose() {
    _TextWritin1.dispose();
    _TextWritin2.dispose();

    FirebaseFirestore.instance
        .collection("textPost")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void setData(textArray) {
      setState(() {
        mmm = textArray;
        nn = textArray;
      });
    }

    void storeData() async {
      await FirebaseFirestore.instance
          .collection("textPost")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"text": mmm});
    }

    // int ll = mmm[0]["textField${0}"][0].length < 1? 0: mmm[0]["textField${0}"][0].length;
    int ll = nn.length;
    print("Printing length");
    print(mmm);
    if (mmm == null) {
      setState(() {
        valid = false;
      });
    } else if (mmm[0]["textField0"][0].length > 2) {
      setState(() {
        valid = true;
      });
    } else {
      setState(() {
        valid = false;
      });
    }

    return WillPopScope(
        onWillPop: () async {
          if (variables.playing) {
            await variables.audioPlayer.setVolume(1);
            await variables.audioPlayer.resume();
          }

          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.8,
              centerTitle: true,
              leading: InkWell(
                onTap: () async {
                  if (variables.playing) {
                    await variables.audioPlayer.setVolume(1);
                    await variables.audioPlayer.resume();
                  }
                  Navigator.pop(context);
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  CupertinoIcons.back,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              title: Text(
                "POST",
                style: GoogleFonts.alegreyaSansSc(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black)),
              ),
            ),
            body: Container(
                child: Column(
              children: [
                Container(
                  child: Expanded(
                    child: SingleChildScrollView(
                      // scrollDirection: Axis.vertical,
                      child: Column(children: [
                        ShowUpAnimation(
                          delayStart: Duration(microseconds: 50),
                          animationDuration: Duration(seconds: 1),
                          curve: Curves.bounceIn,
                          direction: Direction.vertical,
                          offset: 0.5,
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Text form",
                                        style: GoogleFonts.alegreyaSansSc(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                fontSize: 18)),
                                      ),
                                      Text(
                                        "*",
                                        style: GoogleFonts.istokWeb(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 255, 0, 0),
                                                fontSize: 20)),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3)),
                                      ll > 1
                                          ? Container()
                                          : Text(
                                              "(Minimum 3 characters is required)",
                                              style: TextStyle(fontSize: 14),
                                            )
                                    ],
                                  ),
                                ),
                                Container(
                                  // color: Colors.red,
                                  constraints: BoxConstraints(
                                      maxHeight: 230, minHeight: 100),
                                  child: TextContainerhandle(setData: setData),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                        !valid
                            ? Container()
                            : ShowUpAnimation(
                                delayStart: Duration(seconds: 1),
                                animationDuration: Duration(seconds: 1),
                                curve: Curves.bounceIn,
                                direction: Direction.vertical,
                                offset: 0.5,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 28),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "What you wanna call this?",
                                          style: GoogleFonts.alegreyaSansSc(
                                              textStyle: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black)),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 35),
                                        child: TextField(
                                          controller: _TextWritin2,
                                          maxLength: 30,
                                          decoration: InputDecoration(
                                            fillColor: Color.fromARGB(
                                                36, 158, 158, 158),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    style: BorderStyle.none)),
                                            hintText:
                                                "Say what is this to others..",
                                            contentPadding:
                                                EdgeInsets.only(left: 25),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    style: BorderStyle.none)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                        !valid
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "preview",
                                        style: GoogleFonts.itim(
                                            textStyle: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ),
                                    ),
                                    TextHandler(
                                      texthandling: mmm,
                                      haveLike: widget.haveLike,
                                      height: 450.0,
                                      linkID: "gg",
                                      fontSize: 15.0,
                                      topMar: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                      ]),
                    ),
                  ),
                ),
                !valid
                    ? Container()
                    : InkWell(
                        splashColor: null,
                        overlayColor: null,
                        onHighlightChanged: null,
                        onFocusChange: null,
                        onTap: () async {
                          if (connectionStatus) {
                            if (valid) {
                              DateTime now = DateTime.now();

                              String postId = const Uuid().v1();

                              TextPost postIT = TextPost(
                                  datePublished: now,
                                  loves: 0,
                                  postid: postId,
                                  type: "textpost",
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  textArray: mmm,
                                  description: _TextWritin2.text);

                              if (!connectionStatus) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  elevation: 1.0,
                                  // shape: ,
                                  backgroundColor: Colors.transparent,
                                  content: Text(
                                      "This Posted Only When The App is Opened Again With Network Connection."),
                                ));
                                Navigator.pop(context);
                              }

                              await FirebaseFirestore.instance
                                  .collection("Posts")
                                  .doc(postId)
                                  .set(postIT.toJson());

                              await AuthMethods().SendMessge(
                                  "has posted. Check Out",
                                  FirebaseAuth.instance.currentUser!.uid,
                                  now.toString(),
                                  true,
                                  postId,
                                  "",
                                  true,
                                  false,
                                  false);

                              if (variables.playing) {
                                await variables.audioPlayer.setVolume(1);
                                await variables.audioPlayer.resume();
                              }
                              Navigator.pop(context);
                            }
                          } else {}
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          padding: EdgeInsets.symmetric(vertical: 25),
                          decoration: BoxDecoration(
                              color: Colors.black87,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade600,
                                    spreadRadius: 1,
                                    blurRadius: 15),
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "post",
                            style: GoogleFonts.itim(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 255, 255, 255))),
                          ),
                        ),
                      ),
              ],
            ))));
  }
}
