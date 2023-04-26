import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/StarterPages/LoginPage.dart';
import 'package:hopeless_romantic/variables.dart';
import 'package:hopeless_romantic/Authentication/AuthMethods.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:hopeless_romantic/variables.dart' as variable;

class EndDrawer extends StatefulWidget {
  EndDrawer({super.key});

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  TextEditingController _name = TextEditingController();

  TextEditingController _nickName = TextEditingController();

  TextEditingController _bio = TextEditingController();

  late bool changed;

  bool loading = false;

  bool playing = variable.playing;

  bool audioAvailable = false;

  var data = {};

  @override
  void initState() {
    super.initState();
    changed = false;
    getDataa();
  }

  getDataa() async {
    // final re = await FirebaseAuth.instance.currentUser!.uid;
    var res = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      data = res.data()!;
    });

    if (data["cachefile"] != "") {
      try {
        await variable.audioPlayer.setSourceUrl(data["cachefile"]);
      } catch (e) {
        await variable.audioPlayer.setSourceUrl(data["audiofile"]);
      }
    }
    variable.audioPlayer.onPlayerComplete.listen((event) async {
      variable.playing = false;
      await variable.audioPlayer.stop();
      setState(() {
        playing = false;
      });
    });
  }

  // @override
  @override
  Widget build(BuildContext context) {
    void getoutName() async {
      setState(() {
        ChangehasBeenDone = true;
        changed = true;
        whatChangedName = _name.text;
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"username": _name.text});
      Navigator.of(context, rootNavigator: true).pop('dialog');
      setState(() {
        ChangehasBeenDone = true;
      });
    }

    void getoutNickName() async {
      setState(() {
        ChangehasBeenDone = true;
        changed = true;
        whatChangedNickname = _nickName.text;
      });

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"nikeName": _nickName.text});
      Navigator.of(context, rootNavigator: true).pop('send');
      // Navigator.of(context, rootNavigator: true).pop('dialog');
      // setState(() {
      // });
    }

    void getoutBio() async {
      setState(() {
        ChangehasBeenDone = true;
        changed = true;
        whatChangedBio = _bio.text;
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"bio": _bio.text});
      Navigator.of(context, rootNavigator: true).pop('dialog');
      // setState(() {});
    }

    Future openDialogforName() => showDialog(
        context: context,
        builder: (context) => ShowUpAnimation(
            delayStart: Duration(seconds: 0),
            animationDuration: Duration(milliseconds: 500),
            curve: Curves.bounceIn,
            direction: Direction.vertical,
            offset: 0.5,
            child: AlertDialog(
              title: Text(
                "User Name?",
                style: TextStyle(fontSize: 15),
              ),
              content: TextField(
                autofocus: true,
                controller: _name,
                decoration: InputDecoration(hintText: "eg: proLicker"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      getoutName();
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.istokWeb(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ))
              ],
            )));

    Future openDialogforbio() => showDialog(
        context: context,
        builder: (context) => ShowUpAnimation(
            delayStart: Duration(seconds: 0),
            animationDuration: Duration(milliseconds: 500),
            curve: Curves.bounceIn,
            direction: Direction.vertical,
            offset: 0.5,
            child: AlertDialog(
              title: Text(
                "Bio",
                style: TextStyle(fontSize: 15),
              ),
              content: TextField(
                maxLength: 150,
                autofocus: true,
                controller: _bio,
                decoration: InputDecoration(hintText: "eg: Looking for chicks"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      getoutBio();
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.istokWeb(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ))
              ],
            )));

    Future openDialogforNickName() => showDialog(
        context: context,
        builder: (context) => ShowUpAnimation(
            delayStart: Duration(seconds: 0),
            animationDuration: Duration(milliseconds: 500),
            curve: Curves.bounceIn,
            direction: Direction.vertical,
            offset: 0.5,
            child: AlertDialog(
              title: Text(
                "Nick Name?",
                style: TextStyle(fontSize: 15),
              ),
              content: TextField(
                autofocus: true,
                controller: _nickName,
                decoration: InputDecoration(hintText: "eg: youCantHandleMe"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      getoutNickName();
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.istokWeb(
                          textStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ))
              ],
            )));

    if (changed) {
      setState(() {});
    }

    void pauseIt() async {
      await variable.audioPlayer.pause();
      variable.playing = false;
      setState(() {
        playing = false;
      });
    }

    void playIt() async {
      await variable.audioPlayer.setVolume(1);
      await variable.audioPlayer.resume();
      variable.playing = true;
      setState(() {
        playing = true;
      });
    }

    void loaderStart() {
      setState(() {
        loading = true;
      });
    }

    void loaderEnd() {
      setState(() {
        loading = false;
      });
    }

    return Drawer(
        backgroundColor: Color.fromARGB(255, 10, 10, 10),
        child: data.isNotEmpty
            ? Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    child: Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            child: Text(
                              "Settings",
                              style: GoogleFonts.alegreyaSansSc(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _name.text.isNotEmpty
                                        ? _name.text
                                        : data["username"],
                                    style: GoogleFonts.itim(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        openDialogforName();
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      )),
                                ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    _nickName.text.isNotEmpty
                                        ? _nickName.text
                                        : data["nikeName"],
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.itim(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    openDialogforNickName();
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 169,
                                  // color: Colors.pink,
                                  child: Text(
                                    _bio.text.isNotEmpty
                                        ? _bio.text
                                        : data["bio"],
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.itim(
                                        textStyle: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      openDialogforbio();
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),

                          //Leaderboards and storage indication should be Done!.
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/leaderboard");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Leaderboads",
                                style: GoogleFonts.itim(
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 15,
                          ),

                          // Container(
                          //   alignment: Alignment.center,
                          //   child: TextButton(
                          //       onPressed: () async {
                          //         final results =
                          //             await FilePicker.platform.pickFiles(
                          //           type: FileType.audio,
                          //         );

                          //         loaderStart();

                          //         if (results != null) {
                          //           final filePathNOW =
                          //               File(results.files.single.path!);

                          //           final res = await AuthMethods().uploadAudio(filePathNOW);


                          //           if(res == "SUCCESS"){
                          //           await variable.audioPlayer
                          //               .setSourceUrl(filePathNOW.path);
                          //               loaderEnd();
                          //           }
                          //           else if(res == "err"){
                          //           await variable.audioPlayer
                          //               .setSourceUrl(filePathNOW.path);
                          //             loaderEnd();
                          //           }
                          //         }
                          //       },
                                
                          //       child: Container(
                          //           padding: EdgeInsets.symmetric(
                          //               vertical: 8, horizontal: 25),
                          //           child: Text(
                          //             "Select Audio",
                          //             style: TextStyle(),
                          //           ))),
                          // ),

                          SizedBox(
                            height: 50,
                          ),

                          // loading? Center(child: CircularProgressIndicator(color: Colors.white,),) : playing
                          //     ? TextButton(
                          //         onPressed: () => pauseIt(),
                          //         child: Text("Pause"))
                          //     : TextButton(
                          //         onPressed: () => playIt(),
                          //         child: Text("Play")),
                            

                          SizedBox(
                            height: 50,
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(horizontal: 30),
                          //   // decoration: BoxDecoration(color: Colors.black),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         child: LinearProgressIndicator(
                          //           value: 0.8,
                          //           backgroundColor:
                          //               Color.fromARGB(255, 22, 22, 22),
                          //           color: Color.fromARGB(255, 255, 255, 255),
                          //           semanticsLabel: "Liner storage space",
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //       Container(
                          //         child: Text(
                          //           "You still got time",
                          //           style: TextStyle(
                          //               color:
                          //                   Color.fromARGB(255, 255, 255, 255)),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 150,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                print("LogOut");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage(
                                              changeIt: "",
                                            )));
                              },
                              child: Text(
                                "LogOut",
                                style: GoogleFonts.itim(
                                    textStyle: TextStyle(
                                  fontSize: 14,
                                )),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  )
                ],
              )
            : Column(
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        print("LogOut");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      changeIt: "",
                                    )));
                      },
                      child: Text(
                        "LogOut",
                        style: GoogleFonts.itim(
                            textStyle: TextStyle(
                          fontSize: 14,
                        )),
                      ),
                    ),
                  )
                ],
              ));
  }
}
