import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/Authentication/AuthMethods.dart';
import 'package:hopeless_romantic/pages/ChatRoom/Chats/Chats.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:hopeless_romantic/variables.dart' as variables;

class ChatRoom extends StatefulWidget {
  ChatRoom({
    super.key,
    required this.pauseNow,
  });

  final pauseNow;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _message = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool autoFocus = false;
  bool spaceStar = false;
  bool loading = true;

  bool connectionStatus = false;

  bool theme = false;
  bool _visible = false;

  int Count = 0;

  //Get this right

  getThatDamnData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (value) {
        var fields = value.data()!;

        setState(() {
          theme = fields["darkTheme"];
        });
      },
    );
  }

  //For Connectivity Status
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

  setloader() {
    Future.delayed(Duration(seconds: 0), (() {
      setState(() {
        loading = false;
      });
      setState(() {
        _visible = true;
      });
    }));
  }

  @override
  void initState() {
    super.initState();
    getThatDamnData();
    connectionCheck();
    Future.delayed(Duration(seconds: 3), (() {
      setState(() {
        spaceStar = true;
      });
    }));
    setloader();
  }

  Widget build(BuildContext context) {
    void changeTheme() async {
      setState(() {
        theme = !theme;
      });

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"darkTheme": theme});
    }

    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    double height = MediaQuery.of(context).size.height;

    return loading
        ? Lottie.asset(
            'assets/images/chattinWhiteMode.json',
          )
        : AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Scaffold(
              backgroundColor: theme ? Colors.black : Colors.white,
              appBar: AppBar(
                elevation: 0.5,
                // actions: [
                //   Column(
                //     // crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //           margin: EdgeInsets.only(right: 18),
                //           child: Container(),
                //             // child: Container(
                //             //   width: 25,
                //             //   height: 25,
                //             //   decoration: BoxDecoration(
                //             //       color: theme ? Colors.white : Colors.black,
                //             //       borderRadius:
                //             //           BorderRadius.all(Radius.circular(20))),
                //             // ),
                //           )
                //     ],
                //   )
                // ],
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "<",
                            style: GoogleFonts.itim(
                                textStyle: TextStyle(fontSize: 16),
                                color: theme
                                    ? Color.fromARGB(255, 228, 228, 228)
                                    : Colors.black),
                          )),
                    )
                  ],
                ),
                title: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      theme
                          ? Container(
                              width: 280,
                              child: LottieBuilder.asset(
                                  "assets/images/sansshootingstar.json"))
                          : Container(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 19),
                        alignment: Alignment.center,
                        width: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                  "Hopeless Romantics",
                                  style: GoogleFonts.itim(
                                      textStyle: TextStyle(
                                          color: theme
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16)),
                                ),
                            ),
                            Container(
                              child: connectionStatus
                                  ? Text(
                                      "${arg['Count']} Online",
                                      style: GoogleFonts.itim(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              color: theme
                                                  ? Colors.white
                                                  : Colors.black)),
                                    )
                                  : Text(
                                      "No Connection",
                                      style: GoogleFonts.itim(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              color: theme
                                                  ? Colors.white
                                                  : Colors.black)),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                centerTitle: true,
                backgroundColor:
                    theme ? Colors.black : Color.fromARGB(255, 255, 255, 255),
              ),
              body: Stack(
                children: [
                  theme
                      ? AnimatedOpacity(
                          opacity: spaceStar ? 1.0 : 0.0,
                          curve: Curves.easeInToLinear,
                          duration: const Duration(seconds: 60),
                          child: LottieBuilder.asset(
                            "assets/images/sansshootingstar.json",
                            height: height,
                            fit: BoxFit.fitHeight,
                          ))
                      : Container(),
                  Container(
                      child: Column(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(right: 15, left: 15),
                        color: Colors.transparent,
                        padding: EdgeInsets.only(bottom: 0),
                        child: Chats(
                            Name: arg["Name"],
                            uid: uid,
                            pic: arg["pic"],
                            theme: theme),
                      )),

                      //textField
                      Container(
                        // width: 289,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: theme
                                        ? Color.fromARGB(255, 241, 241, 241)
                                        : Colors.black,
                                    width: 0.5))),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          style: GoogleFonts.hubballi(
                              textStyle: TextStyle(
                            color: theme
                                ? Color.fromARGB(255, 241, 241, 241)
                                : Colors.transparent,
                          )),
                          maxLines: null,

                          // autofocus: autoFocus,

                          // onFieldSubmitted: (v) async {
                          //   DateTime now = DateTime.now();
                          //   if (_message.text.isEmpty) {
                          //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //       elevation: 1.0,
                          //       // shape: ,
                          //       backgroundColor: Colors.black,
                          //       content:
                          //           Text("Text Field is Blank like your Life"),
                          //     ));
                          //   } else {
                          //     await AuthMethods().SendMessge(_message.text, uid,
                          //         now.toString(), arg["Name"]);
                          //   }
                          //   setState(() {
                          //     _message.text = "";
                          //   });
                          //   setState(() {
                          //     autoFocus = true;
                          //   });
                          // },
                          controller: _message,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow
                          // ],
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            filled: true,
                            // border: ,

                            suffixIcon: TextButton(
                                onPressed: () async {
                                  DateTime now = DateTime.now();
                                  String text = _message.text;
                                  String ttt = text.trim();
                                  // print(object);
                                  if (ttt.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      elevation: 1.0,
                                      // shape: ,
                                      backgroundColor: Colors.transparent,
                                      content: Text(
                                          "Text Field is Blank like your Life"),
                                    ));
                                  } else {
                                    await AuthMethods().SendMessge(
                                        ttt,
                                        uid,
                                        now.toString(),
                                        false,
                                        "",
                                        arg["Name"],
                                        false,
                                        false,
                                        false);
                                  }
                                  setState(() {
                                    _message.text = "";
                                  });
                                  setState(() {
                                    autoFocus = true;
                                  });
                                },
                                child: new RotationTransition(
                                  turns: new AlwaysStoppedAnimation(-50 / 360),
                                  child: Icon(
                                    const IconData(0xe571,
                                        fontFamily: 'MaterialIcons',
                                        matchTextDirection: true),
                                    color: Colors.white,
                                    size: 17.0,
                                  ),
                                )),
                            floatingLabelBehavior: FloatingLabelBehavior.always,

                            fillColor:
                                theme ? Colors.transparent : Colors.white,
                            // hoverColor: Colors.transparent,
                            hintStyle: GoogleFonts.hubballi(
                                textStyle: TextStyle(
                                    color: theme ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 15)),
                            border: InputBorder.none,
                            hintText: "Message Hopelessly..",

                            contentPadding:
                                EdgeInsets.only(left: 25, top: 20, bottom: 20),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ));
  }
}
