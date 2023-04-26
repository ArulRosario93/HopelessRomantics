import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/Files/PostController.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:show_up_animation/show_up_animation.dart';

class PostContainer extends StatefulWidget {
  PostContainer({
    super.key,
    required this.snap,
    required this.func,
  });

  final snap;
  final func;

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  var data = {};
  bool imageOrNot = false;

  bool isImage = true;

  bool load = false;

  File FileHERE = File("");

  bool FoundOnCache = false;

  bool animate = false;

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
    double height = MediaQuery.of(context).size.height;

    String Description = widget.snap['description'];

    return data.isNotEmpty
        ? ShowUpAnimation(
              delayStart: Duration(seconds: 0),
              animationDuration: Duration(seconds: 0),
              curve: Curves.bounceIn,
              direction: Direction.horizontal,
              offset: 0.5,
              child: Container(
            // constraints: BoxConstraints(maxHeight: 690),
            color: Color.fromARGB(255, 0, 0, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: InkWell(
                      onTap: () {
                        print(data["uid"]);
                        print(FirebaseAuth.instance.currentUser!.uid);
                        print("THIS IS PASSED");
                        if (data["uid"] ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          widget.func();
                        } else {
                          Navigator.pushNamed(context, "/profile", arguments: {
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
                          Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Description.isNotEmpty
                                  ? Container(
                                      child: Text(
                                        "${widget.snap['description']}",
                                        style: GoogleFonts.itim(
                                            textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
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
                    )),
                    // Container(
                    //   margin: EdgeInsets.only(right: 15),
                    //   child: Icon(
                    //     Icons.more_vert,
                    //     color: Color.fromARGB(255, 211, 211, 211),
                    //   ),
                    // ),
                  ],
                )),
                SizedBox(
                  height: 10,
                ),

                GestureDetector(
                  child: Container(
                      constraints: BoxConstraints(maxHeight: height - 225),
                      child: Stack(children: [
                        PostController(file: widget.snap["postURL"], linkID: widget.snap["postid"]),
                      ])),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 6))
              ],
            ),
          ),)
        : Container();
  }
}