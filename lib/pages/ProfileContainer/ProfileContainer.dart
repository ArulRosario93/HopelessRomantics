import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/Profile/ProfileTextContainer/ProfileTextContainer.dart';
import 'package:hopeless_romantic/pages/Profile/ProfilephotoContainer/ProfilephotoContainer.dart';
import 'package:lottie/lottie.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:hopeless_romantic/variables.dart' as variables;

class ProfileContainer extends StatefulWidget {
  const ProfileContainer({
    super.key,
    this.audioPlayer,
    this.pauseNow,
    this.playNow,
  });

  final audioPlayer;
  final pauseNow;
  final playNow;

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  bool FoundOnCache = false;
  late File FileHERE;
  String argH = "";
  String uid = "";
  String bio = "";
  num loves = 0;
  bool isTextPostSelected = false;
  bool isFilePostSelected = true;
  String imgSrc = "";

  bool topper = false;
  List leaderboard = [];

  String audioSrc = "";
  bool audioSrcNow = variables.profileContainerAudioPlaying;

  @override
  void initState() {
    getData();
    argH == null ? null : getDATA();
    Future.delayed(Duration(milliseconds: 50), (() => getLoves()));
    Future.delayed(Duration(milliseconds: 500), (() => validateTopper()));
    super.initState();
  }

  validateTopper() {
    print("validating");
    print(leaderboard);
    if (leaderboard.length > 1) {
      if (leaderboard[0]["uid"] == uid) {
        print("Found Em");
        setState(() {
          topper = true;
        });
      }
    }
  }

  getData() async {
    print("seeeee down");
    final gg = await FirebaseFirestore.instance
        .collection("users")
        .orderBy("loves", descending: true)
        .get();

    final hh = gg.docs;
    // print(hh);

    for (var i = 0; i < hh.length; i++) {
      final kk = {
        "loves": hh[i]["loves"],
        "uid": hh[i]["uid"],
      };

      setState(() {
        leaderboard.add(kk);
      });
    }

    print(leaderboard);
  }

  getDATA() async {
    var file = await DefaultCacheManager().getFileFromCache(argH);

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

  getLoves() async {
    var jj =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    print("SEE DOWN DOWN");
    print("SEE DOWN DOWN");
    final bb = jj.data()!;
    // for (var i = 0; i < bb.length; i++) {
    final love = bb["loves"];
    // love = love + loves;
    // }

    setState(() {
      bio = bb["bio"];
      audioSrc = bb["audiofile"];
      loves = love;
    });

    print("Calllllllllllllled");
    print("Calllllllllllllled");
    print("Calllllllllllllled");
    print("Calllllllllllllled");
    print(bio);

    print("Checking for pic");
    var ImgaeSrc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then(
            (DocumentSnapshot) => DocumentSnapshot.data()?["profileSrc"] ?? 0);
    print("What is it?");
    print(ImgaeSrc);

    var audioFIle = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data()?["audiofile"] ?? 0);
    print("What is it?");

    // if (audioSrc.length > 1) {
    //   variables.profileContainerAudioPlaying = true;
    //   await variables.profileContainerAudio.setSourceUrl(audioSrc);
    //   // await variables.profileContainerAudio.v
    //   await variables.profileContainerAudio.resume();
    //   setState(() {
    //     audioSrcNow = true;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    // if (arg["profileSrc"] != null) {
    setState(() {
      argH = arg["profileSrc"];
      uid = arg["uid"];
    });
    // }

    double height = MediaQuery.of(context).size.height;

    // void filePostSelected() {
    //   setState(() {
    //     isTextPostSelected = false;
    //     isFilePostSelected = true;
    //   });
    // }

    // void textPostSelected() {
    //   setState(() {
    //     isTextPostSelected = true;
    //     isFilePostSelected = false;
    //   });
    // }

    void handleChange() async {
      if (audioSrcNow) {
        await variables.profileContainerAudio.pause();
        variables.profileContainerAudioPlaying = false;
      } else {
        await variables.profileContainerAudio.resume();
        variables.profileContainerAudioPlaying = true;
      }
      setState(() {
        audioSrcNow = !audioSrcNow;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        variables.profileContainerAudioPlaying = false;
        await variables.profileContainerAudio.resume();
        await variables.profileContainerAudio.pause();

        print("called");

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
          // leading: Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       child: TextButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           child: Text(
          //             "<",
          //             style: GoogleFonts.itim(
          //                 textStyle: TextStyle(
          //                     fontSize: 16, fontWeight: FontWeight.w400),
          //                 color: Colors.white),
          //           )),
          //     )
          //   ],
          // ),
          title: Text(
            "${arg["name"]}",
            style: GoogleFonts.alegreyaSansSc(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 45),
            color: Colors.black,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Container(
                    // constraints: BoxConstraints(maxHeight: 250),
                    child: Stack(
                      // fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(75)),
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        // borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/images/avata.png"))),
                                  ),
                                  fit: BoxFit.cover,
                                  imageUrl: arg["profileSrc"],
                                ),
                              ),
                            ),
                            Container(
                              // constraints: BoxConstraints(minWidth: 50, maxWidth: 250),
                              width: 165,
                              // color: Colors.amberAccent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    child: Text(
                                      "${arg["nickName"]}",
                                      style: GoogleFonts.itim(
                                          textStyle: TextStyle(
                                              // color: Color.fromARGB(255, 255, 252, 58),
                                              color: Color.fromARGB(
                                                  255, 0, 255, 255),
                                              fontSize: 25)),
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5)),
                                  Container(
                                    child: Text(
                                      "${bio}",
                                      style: GoogleFonts.itim(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 14)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        topper
                            ? Container(
                                constraints: BoxConstraints(
                                    maxWidth: 390, maxHeight: 180),
                                alignment: Alignment.topCenter,
                                child: LottieBuilder.asset(
                                  "assets/images/confetti2.json",
                                  fit: BoxFit.fitWidth,
                                  repeat: false,
                                  alignment: AlignmentGeometry.lerp(
                                      Alignment.topCenter,
                                      Alignment.topCenter,
                                      0.0),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),

                  ShowUpAnimation(
                      delayStart: Duration(seconds: 1),
                      animationDuration: Duration(seconds: 1),
                      curve: Curves.bounceIn,
                      direction: Direction.vertical,
                      offset: 0.5,
                      child: Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        child: Stack(
                          // alignment: AlignmentGeometry.lerp(a, b, t),
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        "$loves",
                                        style: GoogleFonts.itim(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Loves",
                                        style: GoogleFonts.itim(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: LottieBuilder.asset(
                                  "assets/images/shiningstars.json"),
                            ),
                          ],
                        ),
                      )),

                  SizedBox(
                    height: 30,
                  ),

                  // TextButton(
                  //     onPressed: () {
                  //       handleChange();
                  //     },
                  //     child: Text("Play")),

                  SizedBox(
                    height: 30,
                  ),

                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("Posts")
                        .where("uid", isEqualTo: arg["uid"])
                        // .orderBy("datePublished", descending: false)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      return snapshot.data!.docs.length > 0
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 2,
                                      childAspectRatio: 0.6),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];
                                if (snap["type"] == "post") {
                                  return ShowUpAnimation(
                                      delayStart: Duration(seconds: 1),
                                      animationDuration: Duration(seconds: 1),
                                      curve: Curves.bounceIn,
                                      direction: Direction.vertical,
                                      offset: 0.5,
                                      child: ProfilePhotoContainer(
                                        file: snap["postURL"],
                                        height: height,
                                        desc: snap["description"],
                                        nameHere: arg["name"],
                                        linkID: snap["postid"],
                                      ));
                                } else {
                                  return ShowUpAnimation(
                                      delayStart: Duration(seconds: 1),
                                      animationDuration: Duration(seconds: 1),
                                      curve: Curves.bounceIn,
                                      direction: Direction.vertical,
                                      offset: 0.5,
                                      child: ProfileTextContainer(
                                          snap: snap, height: height));
                                }
                              },
                            )
                          : Container(
                              child: Text("Not posted Yet"),
                            );
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
