import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/HomeMain/TextPostContainer/TextHandlerTwo.dart';
import 'package:hopeless_romantic/pages/HomeMain/TextPostContainer/TextPostContainer.dart';
import 'package:hopeless_romantic/pages/PostPage/TextPage.dart';
import 'package:show_up_animation/show_up_animation.dart';

class ProfileTextContainer extends StatefulWidget {
  const ProfileTextContainer(
      {super.key,
      required this.snap,
      required this.height,});

  final snap;
  final height;

  @override
  State<ProfileTextContainer> createState() => _ProfileTextContainerState();
}

class _ProfileTextContainerState extends State<ProfileTextContainer> {
  bool pressing = false;
  String Name = "";

  bool connectionStatus = false;

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
  void initState() {
    handleChange();
    connectionCheck();
    super.initState();
  }

  void handleChange() async {
    var name = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap["uid"])
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data()?["username"] ?? 0);

    setState(() {
      Name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    void onHandleChange() {
      setState(() {
        pressing = true;
      });
    }

    String desc = widget.snap["description"];

    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    return GestureDetector(
      onLongPressEnd: (details) {
        // overlayEntry.remove();
      },
      onLongPress: () {
        // print("pressed");
        // overlayEntry = OverlayEntry(builder: (context) {
        //   return ShowUpAnimation(
        //       delayStart: Duration(seconds: 0),
        //       animationDuration: Duration(milliseconds: 500),
        //       curve: Curves.bounceIn,
        //       direction: Direction.vertical,
        //       offset: 0.5,
        //       child: Positioned(
        //           child: Material(
        //               color: Color.fromARGB(255, 255, 255, 255),
        //               child: Column(
        //                 children: [
        //                   Container(
        //                       alignment: Alignment.center,
        //                       child: TextPostContainer(
        //                         header: false,
        //                         haveLike: false,
        //                         fontSize: 16.0,
        //                         func: null,
        //                         topmar: 35.0,
        //                         height: widget.height - 69.0,
        //                         snap: widget.snap,
        //                         padding: 0.0,
        //                       )),
        //                   desc.length > 1
        //                       ? Container(
        //                           constraints: BoxConstraints(
        //                             maxWidth: 250,
        //                           ),
        //                           padding: EdgeInsets.symmetric(
        //                               vertical: 6, horizontal: 13),
        //                           decoration: BoxDecoration(
        //                               color: Colors.white,
        //                               border: Border.all(color: Colors.black),
        //                               borderRadius: BorderRadius.circular(20)),
        //                           child: Text(
        //                             widget.snap['description'],
        //                             style: GoogleFonts.itim(
        //                                 textStyle: TextStyle(
        //                                     color:
        //                                         Color.fromARGB(255, 0, 0, 0))),
        //                           ),
        //                         )
        //                       : Container()
        //                 ],
        //               ))));
        // }
        // );
        // overlayState.insert(overlayEntry);
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => TextPage(
                      snap: widget.snap,
                      name: Name,
                    ))));
      },
      child: Container(
        child: TextHandlerTwo(
          fontSize: 10.0,
          texthandling: widget.snap["textArray"],
          topMar: 0.0,
        ),
      ),
    );
  }
}