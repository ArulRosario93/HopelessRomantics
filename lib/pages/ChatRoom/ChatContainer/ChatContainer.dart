import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class ChatContainer extends StatefulWidget {
  const ChatContainer(
      {super.key,
      required this.snap,
      required this.sayIt,
      required this.nexChaned,
      required this.lastone,
      required this.prevChanged,
      required this.theme,
      required this.uid});

  final snap;
  final theme;
  final lastone;
  final nexChaned;
  final prevChanged;
  final sayIt;
  final uid;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  String Name = "";
  String ImgSrc = "";
  String decrip = "";
  String nickName = "";

  bool theme = false;

  @override
  void initState() {
    getDATA();
    super.initState();
  }

  getDATA() async {
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

    var NAMEE = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap["uid"])
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data()!["username"] ?? 0);

    var ImgaeSrc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap["uid"])
        .get()
        .then(
            (DocumentSnapshot) => DocumentSnapshot.data()?["profileSrc"] ?? 0);

    var desc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap["uid"])
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data()?["bio"] ?? 0);

    var neickName = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap["uid"])
        .get()
        .then((DocumentSnapshot) => DocumentSnapshot.data()?["nikeName"] ?? 0);

    setState(() {
      Name = NAMEE;
    });

    setState(() {
      decrip = desc;
    });

    setState(() {
      ImgSrc = ImgaeSrc;
    });

    setState(() {
      nickName = neickName;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String data = widget.snap["datePublished"];

    String time = data.substring(10, 16);

    void changeNav() {
      Navigator.pushNamed(context, "/profile", arguments: {
        "name": Name,
        "uid": widget.snap["uid"],
        "nickName": nickName,
        "description": decrip,
        "profileSrc": ImgSrc,
      });
    }

    openDialogforName() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "$Name",
                    style: GoogleFonts.alegreyaSansSc(
                        textStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                  )),
              content: Container(
                constraints: BoxConstraints(maxHeight: 100),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    changeNav();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                          Container(
                                      width: 69,
                                      height: 69,
                                      // padding: EdgeInsets.symmetric(vertical: 3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(40)),
                                        child: CachedNetworkImage(errorWidget: (context, url, error) => Container(
                                          width: 69,
                                          height: 69,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image:  AssetImage("assets/images/avata.png"),
                                              )),
                                      ), imageUrl: ImgSrc, fit: BoxFit.cover,),
                                      ) 
                                    ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                      Container(
                        alignment: Alignment.center,
                        // color: Colors.amberAccent,
                        constraints: BoxConstraints(maxWidth: 140),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 120),
                              child: Text(nickName,
                              maxLines: 2,
                                  style: GoogleFonts.itim(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.teal),
                                  )),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                            Container(
                              constraints: BoxConstraints(maxWidth: 120),
                              child: Text(decrip,
                              maxLines: 2,
                                  style: GoogleFonts.itim(
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));

    return Column(
      crossAxisAlignment: widget.snap["uid"] != widget.uid
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onDoubleTap: () {
            print("Liked");
            print(widget.snap["message"]);
          },
          child: Column(
            crossAxisAlignment: widget.snap["uid"] != widget.uid
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Container(
                // padding: EdgeInsets.symmetric(vertical: 3),
                margin: EdgeInsets.only(
                    left: 2,
                    top: widget.snap["uid"] != widget.uid
                        ? widget.sayIt
                            ? 12
                            : 0
                        : 0),
                child: widget.snap["uid"] != widget.uid
                    ? widget.sayIt
                        ? GestureDetector(
                            onTap: () {
                              openDialogforName();
                            },

                            child: Row(
                              children: [
                                    
                                    Container(
                                      width: 25,
                                      height: 25,
                                      // padding: EdgeInsets.symmetric(vertical: 3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        child: CachedNetworkImage(errorWidget: (context, url, error) => Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image:  AssetImage("assets/images/avata.png"),
                                              )),
                                      ), imageUrl: ImgSrc, fit: BoxFit.cover,),
                                      ) 
                                    ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3)),
                                Text(Name,
                                    style: GoogleFonts.itim(
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: widget.theme
                                              ? Colors.white
                                              : Colors.black),
                                    ))
                              ],
                            ),
                          )
                        : Text(
                            "",
                            style: TextStyle(fontSize: 0),
                          )
                    : Text(
                        "",
                        style: TextStyle(fontSize: 0),
                      ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: widget.snap["uid"] != widget.uid
                          ? widget.sayIt
                              ? 2
                              : 0
                          : 0)),
              Container(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 270),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: widget.snap["uid"] != widget.uid
                            ? widget.theme
                                ? Colors.white
                                : Colors.transparent
                            : widget.theme
                                ? Color.fromARGB(255, 0, 195, 255)
                                : Colors.transparent),
                    color: widget.snap["uid"] != widget.uid
                        ? widget.theme
                            ? Colors.transparent
                            : Color.fromARGB(255, 207, 207, 207)
                        : widget.theme
                            ? Colors.transparent
                            : Color.fromARGB(255, 0, 132, 255),
                    borderRadius: BorderRadius.only(
                        bottomLeft: widget.snap["uid"] != widget.uid
                            ? widget.sayIt
                                ? !widget.nexChaned
                                    ? Radius.circular(5)
                                    : Radius.circular(20)
                                : widget.nexChaned
                                    ? Radius.circular(20)
                                    : Radius.circular(5)
                            : Radius.circular(20),

                        // widget.sayIt ?
                        // widget.nexChaned ? widget.sayIt ?
                        // Radius.circular(2) : Radius.circular(20) : widget.nexChaned ? Radius.circular(2) : Radius.circular(20),
                        //  Radius.circular(20) : Radius.circular(20),

                        bottomRight: Radius.circular(20),
                        topLeft: widget.snap["uid"] != widget.uid
                            ? !widget.sayIt
                                ? widget.nexChaned
                                    ? Radius.circular(5)
                                    : Radius.circular(5)
                                : Radius.circular(20)
                            : Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Container(
                    // alignment: Alignment.center,
                    // constraints: BoxConstraints(minWidth: 0, maxWidth: 250),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 19),
                    child: Text(
                      widget.snap["message"],
                      style: GoogleFonts.hubballi(
                        textStyle: TextStyle(
                          fontSize: widget.snap["uid"] != widget.uid ? 17 : 16,
                          color: widget.snap["uid"] != widget.uid
                              ? widget.theme
                                  ? Colors.white
                                  : Color.fromARGB(255, 0, 0, 0)
                              : Colors.white,
                        ),
                      ),
                      textAlign: widget.snap["uid"] == widget.uid
                          ? TextAlign.right
                          : TextAlign.left,
                    )),
              ),
              // Container(
              //   // alignment: Alignment.centerRight,
              //   padding: EdgeInsets.symmetric(horizontal: 2),
              //   child: Text(
              //     time,
              //     style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
              //   ),
              // ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: widget.lastone ? 6 : 2))
            ],
          ),
        ),
      ],
    );
  }
}
