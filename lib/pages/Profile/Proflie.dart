import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/Authentication/AuthMethods.dart';
import 'package:hopeless_romantic/pages/Profile/ProfileTextContainer/ProfileTextContainer.dart';
import 'package:hopeless_romantic/pages/Profile/ProfilephotoContainer/ProfilephotoContainer.dart';
import 'package:hopeless_romantic/variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:show_up_animation/show_up_animation.dart';

class Profile extends StatefulWidget {
  Profile({super.key, required this.snap});

  final snap;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var data = {};
  late List file;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uID = FirebaseAuth.instance.currentUser!.uid;
  bool picChanged = false;
  String picPath = "";
  String fileName = "";
  bool isImage = false;
  bool isTextPostSelected = false;
  bool isFilePostSelected = true;
  bool clickRemoved = false;
  num loves = 0;
  File audiofile = File("");
  bool topper = false;

  bool playing = false;

  bool playIt = false;

  bool foundAudioFile = false;

  // late final AudioPlayer _player;
  // PlayerState? _state;

  List leaderboard = [];

  final nn = FirebaseFirestore.instance
      .collection("Posts")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy("datePublished", descending: false)
      .get();

  @override
  void initState() {
    // _player = AudioPlayer();
    // //_player.dynamicSet(url: url);
    // // _player.dynamicSetAll(sources);
    // _player.playerStateStream.listen((state) {
    //   setState(() {
    //     _state = state;
    //   });
    //   print(state);
    // });
    super.initState();
    getDataa();
    file = [];
    whatChangedName = "";
    whatChangedBio = "";
    picPath = "";
    getData();
    getLoves();

    startPlay();

    Future.delayed(Duration(milliseconds: 500), () => validateTopper());
  }

  startPlay() async {
    setState(
      () {
        playIt = true;
      },
    );

    await Future.delayed(
        Duration(seconds: 6),
        () => {
              setState(() {
                playIt = false;
              })
            });
  }

  validateTopper() {
    print("validating");
    print(leaderboard);
    if (leaderboard.length > 1) {
      if (leaderboard[0]["uid"] == FirebaseAuth.instance.currentUser!.uid) {
        print("Found Em");
        setState(() {
          topper = true;
        });
      }
    }
  }

  getDataa() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap)
          .get();

      setState(() {
        data = res.data()!;
      });
    } catch (e) {
      print(e.toString());
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

    print("seeeee down");
    print("seeeee down");
    print(leaderboard);
  }

  getLoves() async {
    var jj = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final bb = jj.data()!;
    // num love = 0;
    // for (var i = 0; i < bb.length; i++) {
    final love = bb["loves"];
    // love = love + loves;
    // }

    // await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .update({
    //   "loves": love,
    // });

    setState(() {
      loves = love;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height.toDouble();
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    if (whatChangedBio.isNotEmpty) {
      print("came Here");
      print(whatChangedBio);
    }

    void filePostSelected() {
      setState(() {
        isTextPostSelected = false;
        isFilePostSelected = true;
      });
    }

    void textPostSelected() {
      setState(() {
        isTextPostSelected = true;
        isFilePostSelected = false;
      });
    }

    void getCacheMem(String filePath) async {
      setState(() {
        audiofile = File(filePath);
        fileName = filePath;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Reading Cache IN"),
      ));
      final hh = await DefaultCacheManager().getFileFromCache(filePath);

      print("Coming Coimgin");
      print("Coming Coimgin");
      print("Coming Coimgin");
      print(hh);
    }

    return data.isNotEmpty
        ? Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: 40,
                ),

                // SizedBox(
                //   height: 50,
                // ),
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            fit: StackFit.loose,
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
                                    imageUrl: picChanged
                                        ? picPath
                                        : data["profileSrc"],
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 150),
                                  child: TextButton(
                                    onPressed: () async {
                                      final results =
                                          await FilePicker.platform.pickFiles(
                                        allowMultiple: false,
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          "png",
                                          "jpg",
                                        ],
                                      );

                                      if (results == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text("No file Selected")));

                                        return null;
                                      }

                                      if (results != null) {
                                        if (results.files.first.path!
                                                .contains("jpg") ||
                                            results.files.first.path!
                                                .contains("jpeg") ||
                                            results.files.first.path!
                                                .contains("png")) {
                                          List link = [];
                                          String filePath =
                                              results.files.first.path!;

                                          setState(() {
                                            file.clear();
                                            file.add(filePath);
                                          });
                                          try {
                                            final resultsHere =
                                                await AuthMethods().uploadFile(
                                                    "ProfilePic",
                                                    file,
                                                    "profilePics",
                                                    false,
                                                    false,
                                                    false);

                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(uID)
                                                .update({
                                              "profileSrc": resultsHere[0],
                                            });

                                            print("came Result");
                                            print("came Result");
                                            print("came Result");
                                            print(resultsHere);

                                            await File(filePath).delete();

                                            setState(() {
                                              picPath = resultsHere.last;
                                              file.clear();
                                              picChanged = true;
                                            });
                                            setState(() {});
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Under Maintenance. Try after Some Time"),
                                            ));
                                          }
                                        } else {
                                          print(results.files.first.path!);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Select an Image BOMMER"),
                                          ));
                                        }
                                      }
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Container(
                            child: Text(
                              whatChangedName.isNotEmpty
                                  ? whatChangedName
                                  : data["username"],
                              style: GoogleFonts.itim(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19,
                                      color: Colors.white)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 270,
                            child: Text(
                              whatChangedBio.isNotEmpty
                                  ? whatChangedBio
                                  : data["bio"],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.itim(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      topper
                          ? playIt
                              ? Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 390, maxHeight: 200),
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
                          : Container()
                    ],
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                ShowUpAnimation(
                  delayStart: Duration(seconds: 1),
                  animationDuration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  direction: Direction.vertical,
                  offset: 0.5,
                  child: Container(
                    width: 100,
                    height: 60,
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
                                      textStyle: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "Loves",
                                    style: GoogleFonts.itim(
                                      textStyle: TextStyle(color: Colors.white),
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
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                //GET THIS CODE FROM HERE :>
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("Posts")
                      .where("uid",
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        // String url =
                        //     "https://imageio.forbes.com/specials-images/imageserve/5ed564163dbc9800060b2829/0x0.jpg?format=jpg&crop=1080,1080,x0,y0,safe&height=416&width=416&fit=bounds";

                        // return Container(
                        //     child: Text("FAFA",
                        //         style: TextStyle(color: Colors.white)));

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
                                linkID: snap["postid"],
                                desc: snap["description"],
                                nameHere: data["username"],
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
                    );
                  },
                ),

                //END UP HERE
              ]),
            ),
          )
        : Center(
            child: CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 255, 255)),
          );
  }
}
