import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/ChatRoom/ChatRoom.dart';
import 'package:hopeless_romantic/pages/Home.dart';
import 'package:hopeless_romantic/pages/LeaderboardsPage/LeaderboardsPage.dart';
import 'package:hopeless_romantic/pages/PostPage/PostPage.dart';
import 'package:hopeless_romantic/pages/ProfileContainer/ProfileContainer.dart';
import 'package:hopeless_romantic/variables.dart' as variables;

class MainPageController extends StatefulWidget {
  MainPageController({super.key});

  @override
  State<MainPageController> createState() => _MainPageControllerState();
}

class _MainPageControllerState extends State<MainPageController> {
  bool playing = false;

  getDataa() async {
    var ff = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var gg = ff.data()!;

    if (gg["audiofile"] != "") {
      variables.audioPlayer.setSourceUrl(gg["audiofile"]);
      // setState(() {
      //   audioPlayer.setSourceUrl(gg["audiofile"]);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(data);

    // void handlePlay() {
    //   if (playing) {
    //     audioPlayer.pause();
    //     setState(() {
    //       playing = !playing;
    //     });
    //   } else {
    //     audioPlayer.resume();
    //     setState(() {
    //       playing = !playing;
    //     });
    //   }
    // }


    void pauseNow() {
      // variables
    }

    void playNow() {
      // audioPlayer.resume();
      // setState(() {
      //   playing = true;
      // });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hopeless Romantic",
      // color: Colors.black,
      initialRoute: '/',
      //Routes
      routes: {
        '/': (context) => HomePage(audioPlayer: "audioPlayer"),
        '/chatRoom': (context) => ChatRoom(pauseNow: pauseNow),
        "/leaderboard": (context) =>
            LeaderboardPage(audioPlayer: "audioPlayer"),
        "/profile": (context) => ProfileContainer(
            audioPlayer: "audioPlayer", playNow: playNow, pauseNow: pauseNow),
        "/postPage": (context) =>
            PostPage(audioPlayer: "audioPlayer", pauseNow: pauseNow),
      },
    );
  }
}
