import 'dart:io';
import 'package:hopeless_romantic/variables.dart' as variables;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/AddPost/AddPost.dart';
import 'package:hopeless_romantic/pages/EndDrawer/EndDrawer.dart';
import 'package:hopeless_romantic/pages/HomeMain/HomeMain.dart';
import 'package:hopeless_romantic/pages/Profile/Proflie.dart';
import 'package:lottie/lottie.dart';
import 'package:neon/neon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.audioPlayer});

  final audioPlayer;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedInt = 0;
  String uid = "";
  var data;
  int Count = 0;
  bool FoundOnCache = false;
  File FileHERE = File("");
  late String Name;
  bool playing = false;

  bool foundAudioFile = false;

  //To be Done!
  // late String Name;

  String url = "";

  @override
  void initState() {
    getDataa();
    getName();
    getOnlineCount();
    fetchProfilePic();
    super.initState();
    FirebaseFirestore.instance.collection('genral').snapshots().listen(
      (event) {
        setState(() {
          Count = event.size;
        });
      },
    );

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    Future DOIT =
        FirebaseFirestore.instance.collection("genral").doc(uid).delete();
  }

  String? changes;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      //SET SOME DATA TO COMPLETE
      await FirebaseFirestore.instance
          .collection("genral")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"status": "Online", "party": "Hard"});
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      await FirebaseFirestore.instance
          .collection("genral")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
    }
  }

  void fetchProfilePic() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (value) {
        var fields = value.data()!;

        setState(() {
          url = fields["profileSrc"];
        });
      },
    );

    var file = await DefaultCacheManager().getFileFromCache(url);

    print("SAME SMAE SMAENEA");
    print(file?.file);

    if (file?.file == null) {
      setState(() {
        FoundOnCache = false;
      });
    } else {
      var fileName = file?.file.toString();
      setState(() {
        FileHERE = File(fileName!.substring(12, fileName.length - 1));
      });
      setState(() {
        FoundOnCache = true;
      });
    }
  }

  getDataa() async {
    try {
      var ff = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var gg = ff.data()!;

      print("CAME CMAE");
      print("CAME CMAE");
      print(gg);
      print("CAME CMAE");

      // if (gg["audiofile"] != "") {
      //   setState(() {
      //     foundAudioFile = true;
      //     audioPlayer.setSourceUrl(gg["audiofile"]);
      //   });
      // }

      setState(() async {
        data = gg;
        await FirebaseFirestore.instance
            .collection("genral")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({"status": "Online", "party": "Hard"});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void getOnlineCount() async {
    int documents =
        await FirebaseFirestore.instance.collection('genral').get().then(
              (value) => value.size,
            );
    setState(() {
      Count = documents;
    });

    print("GET IT GET IT");
    print("GET IT GET IT");
    print("GET IT GET IT");
  }

  void getName() async {
    var data =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    var snap = data.data()?["username"] ?? 0;
    setState(() {
      Name = snap["username"];
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController conIt = TextEditingController();

    void openEndDrawerr() async {
      _scaffoldKey.currentState!.openEndDrawer();
    }

    void _onItemTapped(int index) async {
      setState(() {
        _selectedInt = index;
      });

      setState(() async {
        uid = FirebaseAuth.instance.currentUser!.uid;
      });
    }

    void changeSelected() {
      setState(() {
        _selectedInt = 2;
      });

      setState(() async {
        uid = FirebaseAuth.instance.currentUser!.uid;
      });
    }

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

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        backgroundColor: Color.fromARGB(255, 2, 2, 2),
        // backgroundColor: Color.fromARGB(239, 233, 30, 98),
        actions: [
          _selectedInt == 0
              ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/chatRoom", arguments: {
                      'Count': Count,
                      "Name": data["username"],
                      "pic": data["profileSrc"]
                    });
                  },
                  icon: Icon(CupertinoIcons.heart),
                )
              : _selectedInt == 2
                  ? IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        openEndDrawerr();
                      },
                    )
                  : Text(""),
          Padding(padding: EdgeInsets.only(right: 13))
        ],
        title: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                width: 250,
                child:
                    LottieBuilder.asset("assets/images/sansshootingstar.json")),
            Container(
                // color: Colors.amber,
                width: 250,
                padding: EdgeInsets.symmetric(vertical: 19),
                alignment: Alignment.center,
                child: Column(
                    children: [
                      // Neon(
                      //   text: 'Hopeless Romantics',
                      //   color: Colors.red,
                      //   fontSize: 20,
                      //   font: NeonFont.,
                      //   textStyle: GoogleFonts.alegreyaSansSc(),
                      // ),
                      Text(
                        "Hopeless Romantics",
                        style: GoogleFonts.alegreyaSansSc(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  ),
          ],
        ),
        centerTitle: true,
        // elevation: 1.0,
      ),
      endDrawer: EndDrawer(),
      body: _selectedInt == 1
          ? AddPost(data: data)
          : _selectedInt == 0
              ? HomeMain(func: changeSelected)
              : Profile(
                  snap: uid,
                ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 14, 14, 14),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 25,
              height: 25,
              child: FoundOnCache
                  ? Image.file(
                      FileHERE,
                      fit: BoxFit.cover,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: CachedNetworkImage(
                          errorWidget: (context, url, error) => Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image:
                                          AssetImage("assets/images/avata.png"),
                                    )),
                              ),
                          fit: BoxFit.cover,
                          imageUrl: url),
                    ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedInt,
        unselectedItemColor: Color.fromARGB(207, 184, 184, 184),
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        onTap: _onItemTapped,
      ),
    );
  }
}
