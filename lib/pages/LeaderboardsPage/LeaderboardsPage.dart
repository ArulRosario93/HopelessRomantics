import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import './LeaderBoardItem.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key, this.audioPlayer});

  final audioPlayer;

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List leaderboard = [];

  @override
  void initState() {
    getData();
    super.initState();
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
      final kk = {"uid": hh[i]["uid"], "loves": hh[i]["loves"]};

      setState(() {
        leaderboard.add(kk);
      });
    }

    print("seeeee down");
    print("seeeee down");
    print(leaderboard);
  }

  @override
  Widget build(BuildContext context) {
    print("came down hre");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
                        color: Colors.white),
                  )),
            )
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                width: 230,
                alignment: Alignment.centerLeft,
                // color: Colors.green,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 57,
                                // color: Colors.amber,
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "L",
                                  style: GoogleFonts.itim(
                                    textStyle: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                  height: 50,
                                  // color: Colors.red,
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    "eaderboards",
                                    style: GoogleFonts.itim(
                                      textStyle: TextStyle(
                                          letterSpacing: 2,
                                          fontSize: 21,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  )),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Container(
                              height: 49,
                              // color: Colors.blue,
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "Of",
                                style: GoogleFonts.itim(
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Hopeless Romantics",
                          style: GoogleFonts.itim(
                            textStyle: TextStyle(
                                letterSpacing: 1,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        )),
                  ],
                ),
              )),
          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            child: Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: leaderboard.length > 1
                    ? Column(children: <Widget>[
                        for (var i = 500; i <= 504; i++)
                          LeaderboardItem(
                              uid: leaderboard[i - 500]["uid"],
                              int: "${i - 499}",
                              delay: i,
                              loves: leaderboard[i - 500]["loves"])
                      ])
                    : Container(),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "View All Users",
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                Icon(
                  CupertinoIcons.info_circle,
                  color: Color.fromARGB(255, 0, 255, 255),
                  size: 12,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
