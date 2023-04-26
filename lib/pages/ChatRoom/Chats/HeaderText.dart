import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/PostPage/TextPage.dart';

class HeaderText extends StatefulWidget {
  const HeaderText(
      {super.key,
      required this.linkId,
      required this.msg,
      required this.uid,
      required this.filePost,
      required this.newUser,
      required this.testPost});

  final uid;
  final msg;
  final linkId;
  final newUser;
  final testPost;
  final filePost;

  @override
  State<HeaderText> createState() => _HeaderTextState();
}

class _HeaderTextState extends State<HeaderText> {
  String imgSrc = "";
  String link = "";
  var datatrans = {};
  String Name = "";
  String textPostName = "";
  var textPostsrc;
  String textPostdes = "";
  String nickName = "";
  String desc = "";
  String loves = "";
  bool theme = false;

  @override
  void initState() {
    getData();

    setLink();
    super.initState();
  }

  void getData() async {
    var hh = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var fields = value.data()!;

      setState(() {
        theme = fields["darkTheme"];
      });
    });

    var ImgaeSrc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then(
            (DocumentSnapshot) => DocumentSnapshot.data()?["profileSrc"] ?? 0);

    var name = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data()?["username"] ?? 0);

    var nameNick = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data()?["nikeName"] ?? 0);

    setState(() {
      Name = name;
      imgSrc = ImgaeSrc;
      nickName = nameNick;
    });
  }

  void setLink() async {
    if (widget.testPost) {
      var filePost = await FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.linkId)
          .get();

      setState(() {
        datatrans = filePost.data()!;
      });

      var getITALL = filePost.data()!;

      var getuserName = await FirebaseFirestore.instance
          .collection('users')
          .doc(getITALL["uid"])
          .get();

      var getITT = getuserName.data()!;

      setState(() {
        textPostName = getITT['username'];
        textPostdes = getITALL["description"];
        textPostsrc = getITALL["textArray"];
      });
    }

    if (widget.filePost) {
      var filePost = await FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.linkId)
          .get();

      var getITALL = filePost.data()!;

      var getuserName = await FirebaseFirestore.instance
          .collection('users')
          .doc(getITALL["uid"])
          .get();

      var getITT = getuserName.data()!;

      setState(() {
        textPostName = getITT['username'];
        textPostdes = getITALL["description"];
        textPostsrc = getITALL["postURL"];
      });
    }

    if (widget.newUser) {
      var filePost = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.linkId)
          .get();

      var getITALL = filePost.data()!;

      var getuserName = await FirebaseFirestore.instance
          .collection('users')
          .doc(getITALL["uid"])
          .get();

      var getITT = getuserName.data()!;

      setState(() {
        textPostName = getITT['username'];
        textPostdes = getITALL["description"];
        textPostsrc = getITT["profileSrc"];
        nickName = getITT["nikeName"];
        desc = getITT["bio"];
        loves = getITT["loves"];
      });
    }
  }

  void onHandleChange() {
    if (widget.testPost) {
      print("hererere0");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => TextPage(snap: datatrans, name: Name))));
    }
    if (widget.newUser) {
      print("hererere1");

      if (nickName.length < 1) {
        setState(() {
          nickName = " ";
        });
      }

      if (desc.length < 1) {
        setState(() {
          desc = " ";
        });
      }

      print(imgSrc);
      // print(object)

      Navigator.pushNamed(context, "/profile", arguments: {
        "name": textPostName,
        "uid": widget.linkId,
        "nickName": nickName,
        "description": desc,
        "profileSrc": imgSrc,
      });
    }

    if (widget.filePost) {
      print("hererere2");
      Navigator.pushNamed(context, "/postPage", arguments: {
        "type": "photo",
        "src": textPostsrc,
        "name": textPostName,
        "desc": textPostdes,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // alignment: Alignment.center,
        // color: Colors.white,
        
        constraints: BoxConstraints(maxWidth: 300),
        child: Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 4)),
        GestureDetector(
          onTap: () {
            onHandleChange();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Text(
                "$nickName",
                style: GoogleFonts.itim(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: theme
                          ? Color.fromARGB(221, 255, 255, 255)
                          : Colors.black),
                ),
              )),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3.5),
                child: Text(
                  widget.msg,
                  style: GoogleFonts.hubballi(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: nickName.length > 1? Colors.white: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 4))
      ],
    ));
  }
}
