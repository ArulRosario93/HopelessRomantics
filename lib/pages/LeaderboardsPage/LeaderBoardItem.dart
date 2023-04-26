import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:show_up_animation/show_up_animation.dart';

class LeaderboardItem extends StatefulWidget {
  const LeaderboardItem({super.key, required this.delay, required this.loves, required this.uid, required this.int});

  final uid;
  final loves;
  final String int;
  final delay;

  @override
  State<LeaderboardItem> createState() => _LeaderboardItemState();
}

class _LeaderboardItemState extends State<LeaderboardItem> {
  String imageSrc = "";
  String nickName = "";
  String name = "";
  String description = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var jj = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();

    final bb = jj.data()!;
    setState(() {
      nickName = bb["nikeName"];
      name = bb["username"];
      imageSrc = bb["profileSrc"];
      description = bb["bio"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowUpAnimation(
                  delayStart: Duration(milliseconds: widget.delay),
                    animationDuration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    direction: Direction.horizontal,
                    offset: -0.5,
                    child: InkWell(
      onTap: () {
        print("Camr hererere");
        print(imageSrc);
        Navigator.pushNamed(context, "/profile", arguments: {
          "name": name,
          "uid": widget.uid,
          "nickName": nickName,
          "description": description,
          "profileSrc": imageSrc,
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    child: Text(
                  widget.int,
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                )),
                Container(
                  width: 150,
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(
                        nickName,
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(
                              color:Color.fromARGB(255, 0, 255, 255),
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400),
                        ),
                      )),
                      Container(
                          child: Text(
                        name,
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                    ],
                  ),
                )
              ],
            ),

            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  child: Text("${widget.loves}", style: GoogleFonts.itim(
                    textStyle: TextStyle(color: Colors.white),),
                  ),
                ),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: LottieBuilder.asset(
                      "assets/images/shiningstars.json"),
                ),
              ],
            ),

            // Padding(padding: EdgeInsets.symmetric(horizontal: 10)),

                Container(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(75)),
                        child: CachedNetworkImage(
                          errorWidget: (context, url, error) => Container(
                            width:  50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                // borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage("assets/images/avata.png"))),
                          ),
                          fit: BoxFit.cover,
                          imageUrl: imageSrc,
                        ),
                      ),
                    ),
          ],
        ),
      ),
    ),);
  }
}
