import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/TextController/TextHandler/TextHandler.dart';
import 'package:hopeless_romantic/pages/HomeMain/TextPostContainer/TextHandlerTwo.dart';

class TextPostContainer extends StatefulWidget {
  const TextPostContainer(
      {super.key,
      required this.snap,
      required this.padding,
      required this.haveLike,
      required this.fontSize,
      required this.header,
      this.home,
      required this.topmar,
      required this.func,
      required this.height});

  final snap;
  final topmar;
  final func;
  final home;
  final bool header;
  final height;
  final fontSize;
  final padding;
  final haveLike;

  @override
  State<TextPostContainer> createState() => _TextPostContainerState();
}

class _TextPostContainerState extends State<TextPostContainer> {
  var data = {};
  bool imageOrNot = false;

  bool isImage = true;

  bool readtoRender = true;

  File FileHERE = File("");

  bool FoundOnCache = false;

  bool animate = false;

  // late File file;
  // bool isVid = false;

  @override
  void initState() {
    getData();
    getDATA();
    super.initState();
  }

  getDATA() async {
    var file = await DefaultCacheManager().getFileFromCache(data["profileSrc"]);

    print("SAME SMAE SMAENEA");
    print(file?.file);

    if (file?.file == null) {
      setState(() {
        FoundOnCache = false;
      });
    } else {
      var fileName = file?.file.toString();
      setState(() {
        FileHERE = File(fileName!.substring(12, fileName.length - 1));
      });
      setState(() {
        FoundOnCache = true;
      });
    }
  }

  void getData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.snap["uid"])
        .get();

    setState(() {
      data = snapshot.data()!;
    });

    setState(() {
      readtoRender = false;
    });
    // setState(() {
    //   FileHERE = File(file?.originalUrl);
    // });
  }

  void changeState() {
    setState(() {
      isImage = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String Description = widget.snap['description'];
    // var bb = widget.snap;

    return readtoRender
            ? Container()
            : Container(
                color: Color.fromARGB(255, 0, 0, 0),
                child: Column(
                  children: [
                    widget.header
                        ? Container(
                            child: InkWell(
                            onTap: () {
                              if (data["uid"] ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                widget.func();
                              } else {
                                Navigator.pushNamed(context, "/profile",
                                    arguments: {
                                      "name": data["username"],
                                      "uid": data["uid"],
                                      "nickName": data["nikeName"],
                                      "description": data["bio"],
                                      "profileSrc": data["profileSrc"],
                                    });
                              }
                            },
                            child: Row(
                              children: [
                                Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: FoundOnCache?ClipRRect(borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),child: Image.file(FileHERE, fit: BoxFit.cover,)): ClipRRect(borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)), child: CachedNetworkImage(errorWidget: (context, url, error) => 
                                        Container(
                                          width: 100,
                                          height: 100,  
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              // borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage("assets/images/avata.png")
                                              )),
                                        ), fit: BoxFit.cover, imageUrl: data["profileSrc"])),
                                ),
                                Padding(padding: EdgeInsets.symmetric(horizontal:6)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Description.isNotEmpty
                                        ? Container(
                                            // alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${widget.snap['description']}",
                                              style: GoogleFonts.itim(
                                                  textStyle: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            ),
                                          )
                                        : Padding(padding: EdgeInsets.zero),
                                    Container(
                                      child: Text(
                                        // "Hola there",
                                        data["username"],
                                        style: GoogleFonts.itim(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17)),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ))
                        : Container(),
                    Container(
                      // height: 600,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: widget.padding),
                      child: TextHandler(
                          home: widget.home,
                          haveLike: widget.haveLike,
                          topMar: widget.topmar,
                          fontSize: widget.fontSize,
                          linkID: widget.snap["postid"],
                          texthandling: widget.snap["textArray"],
                          height: widget.height),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: widget.padding))
                  ],
                ),
              );
  }
}
