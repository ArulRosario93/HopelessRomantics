import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/Authentication/AuthMethods.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/Files/PageView/pageView.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hopeless_romantic/variables.dart' as variables;

class Files extends StatefulWidget {
  final fileName;
  final filePath;
  final data;

  Files({
    super.key,
    required this.fileName,
    required this.filePath,
    required this.data,
  });

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  TextEditingController sayItWhat = TextEditingController();

  bool isImage = false;
  bool disposeIt = false;
  String status = "";
  bool loading = true;
  int _selectedItem = 0;
  bool connectionStatus = true;
  late File file;

  double NUMHERE = 1;

  @override
  void initState() {
    //Check This
    controlMusic();
    setState(() {
      file = File(widget.filePath[_selectedItem]!);
    });
    connectionCheck();
    setData();
    super.initState();
  }

  void controlMusic() async {
    if (variables.playing) {
      variables.playing = false;

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
      Future.delayed(Duration(milliseconds: 1600),
          () => {variables.audioPlayer.setVolume(0.2)});
      Future.delayed(Duration(milliseconds: 2500),
          () => {variables.audioPlayer.setVolume(0.1)});
      Future.delayed(
          Duration(milliseconds: 3100), () => {variables.audioPlayer.pause()});
    }
  }

  void connectionCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connectionStatus = false;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connectionStatus = false;
      });
    } else {
      setState(() {
        connectionStatus = true;
      });
    }
  }

  void setData() {
    setState(() {
      file = File(widget.filePath[_selectedItem]!);
    });
  }

  @override
  void dispose() async {
    sayItWhat.dispose();
    List li = widget.filePath;
    for (var i = 0; i < li.length; i++) {
      final kk = await File(widget.filePath[i]).delete();
      print(kk);
      print("Now removed ${widget.filePath[i]}");
    }
    super.dispose();
  }

  @override
  void deactivate() async {
    List li = widget.filePath;
    for (var i = 0; i < li.length; i++) {
      await DefaultCacheManager().removeFile(widget.filePath[i]);
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    void changeLoader() {
      setState(() {
        loading = true;
      });
      Navigator.pop(context, "/");
    }

    void handleStatus() {
      setState(() {
        status = "Checking data";
      });
    }

    void handleStatusFinal() {
      setState(() {
        status = "Uploading Instance";
      });
    }

    void onHandleChange() async {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      setState(() {
        disposeIt = true;
      });

      if (widget.filePath.isNotEmpty) {
        setState(() {
          loading = false;
        });
        DateTime now = DateTime.now();
        String postId = const Uuid().v1();

        try {
          final res = await AuthMethods().uploadPost(sayItWhat.text,
            widget.fileName, uid, "Rosarioooo", postId, widget.filePath);

        print(res);

        print("above is the response from AuthPost");

        if (res == "[firebase_storage/unknown] An unknown error occurred") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Under maintenance. Try uploading After Some Time"),
          ));
        }

        if (res == "SUCCESS") {
          await AuthMethods().SendMessge("has posted. Check Out", uid,
                now.toString(), true, postId, "", false, true, false);
            
            setState(() {
              loading = true;
            });

            print("Now Starting removing Files");
            List li = widget.filePath;
            for (var i = 0; i < li.length; i++) {
              await File(widget.filePath[i]).delete();
              // await DefaultCacheManager().removeFile(widget.filePath[i]);
            }

            Navigator.pop(context, "/");

            if (!loading) {
              Future.delayed(Duration(seconds: 5), () => {handleStatus()});
              Future.delayed(Duration(seconds: 9), () => {handleStatusFinal()});
              Future.delayed(Duration(seconds: 15), () => {changeLoader()});
            }
          } else {
            setState(() {
              loading = true;
            });

            List li = widget.filePath;
            for (var i = 0; i < li.length; i++) {
              final kk = await File(widget.filePath[i]).delete();
              print(kk);
              print("Now removed ${widget.filePath[i]}");
            }
            print(res);
            Navigator.pop(context, "/");
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Under maintenance. Try uploading After Some Time"),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Fill the nessesary details"),
          ));
      }
    }

    return WillPopScope(
      onWillPop: () async {
        List li = widget.filePath;
        if (variables.playing) {
          variables.playing = true;
          variables.audioPlayer.setVolume(1);
          variables.audioPlayer.resume();
        }
        for (var i = 0; i < li.length; i++) {
          final kk = await File(widget.filePath[i]).delete();
          print(kk);
          print("Now removed ${widget.filePath[i]}");
        }

        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.7,
            leading: InkWell(
              onTap: () async {
                if (variables.playing) {
                  variables.playing = true;
                  await variables.audioPlayer.setVolume(1);
                  await variables.audioPlayer.resume();
                }

                List li = widget.filePath;
                for (var i = 0; i < li.length; i++) {
                  final kk = await File(widget.filePath[i]).delete();
                  print(kk);
                  print("Now removed ${widget.filePath[i]}");
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
            centerTitle: true,
          ),
          body: loading
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 28),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "What you wanna call this?",
                                style: GoogleFonts.alegreyaSansSc(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: TextField(
                                controller: sayItWhat,
                                maxLength: 40,
                                decoration: InputDecoration(
                                  fillColor: Color.fromARGB(36, 158, 158, 158),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none)),
                                  hintText: "Say what is this to others..",
                                  contentPadding: EdgeInsets.only(left: 25),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none)),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 665,
                              child: pageView(
                                  data: widget.data,
                                  file: widget.filePath,
                                  description: sayItWhat.text),
                            )
                          ]),
                        ),
                      ),
                      !connectionStatus
                          ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade600,
                                        spreadRadius: 1,
                                        blurRadius: 15),
                                  ],
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () {
                                  onHandleChange();
                                },
                                child: Text(
                                  "post",
                                  style: GoogleFonts.itim(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                ),
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              padding: EdgeInsets.symmetric(vertical: 15),
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
                                "No Network Connection",
                                style: GoogleFonts.itim(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(
                                            255, 255, 255, 255))),
                              ),
                            ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset("assets/images/loads1.json"),
                    Text(
                      "$status",
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    )
                  ],
                )),
    );
  }
}
