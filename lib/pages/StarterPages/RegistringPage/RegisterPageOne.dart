import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/Authentication/AuthMethods.dart';
import 'package:hopeless_romantic/Authentication/MainPageController.dart';
import 'package:hopeless_romantic/pages/StarterPages/RegistringPage/Containerhub/PhotoContainer.dart';
import 'package:hopeless_romantic/pages/StarterPages/RegistringPage/Containerhub/TextContainer.dart';
import 'package:show_up_animation/show_up_animation.dart';

class RegisterPageOne extends StatefulWidget {
  const RegisterPageOne({super.key, required this.changeIt});

  final changeIt;

  @override
  State<RegisterPageOne> createState() => _RegisterPageOneState();
}

class _RegisterPageOneState extends State<RegisterPageOne> {
  int currentPage = 0;
  late double height;
  late double progress;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _data = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uID = FirebaseAuth.instance.currentUser!.uid;

  bool picClicked = false;
  List filePath = [];
  bool showtrans = false;

  @override
  void initState() {
    height = 30;
    progress = 0;
    super.initState();
  }

  String title = "";
  String hintText = "";
  String btnText = "";
  @override
  Widget build(BuildContext context) {
    if (currentPage == 0) {
      setState(() {
        title = "Have a Cool UserName";
        hintText = "@Romanticguy";
        btnText = "Next";
        showtrans = true;
      });
    } else if (currentPage == 1) {
      _firestore
          .collection("users")
          .doc("$uID")
          .update({"username": _data.text});

      setState(() {
        title = "Have a Bio";
        hintText = "Looking for Chicks";
        _data.text = "";
        height = 250;
        progress = 0.3;
        showtrans = true;
      });
    } else if (currentPage == 2) {
      height = 90;
      progress = 0.6;

      _firestore.collection("users").doc("$uID").update({"bio": _data.text});
      // setState(() {
      //   currentPage = currentPage + 1;
      // });
    } else if (currentPage == 3) {
      setState(() {
        title = "Have a Smart NickName";
        hintText = "@proLicker";
        btnText = "Finish";
        _data.text = "";
        height = 190;
        progress = 0.8;
        showtrans = true;
      });
    }

    void onHandleChange() async {
      if (_data.text.length < 5) {
        print("ERRORRORORORO");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User Logged In'),
        ));
      }

      // if (picClicked == false) {}

      if (currentPage == 2) {
        
        try {
          print("Starting the try method");
          if (picClicked) {
            print("chaning Files $filePath");
            try {
              print("gogog");
              final results = await AuthMethods().uploadFile(
                  "ProfilePic", filePath, "profilePics", false, false, false);

              print("lets seee $results");

              _firestore
                  .collection("users")
                  .doc("$uID")
                  .update({"profileSrc": results[0]});
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Under Maintenance. Try after Some Time"),
              ));
            }
          } else {
            filePath.add("hhahadh");

            final results = await AuthMethods().uploadFile(
                "ProfilePic", filePath, "profilePics", false, false, true);

            print("Finished Uploading in Else $results");

            _firestore
                .collection("users")
                .doc("$uID")
                .update({"profileSrc": results[0]});
          }
        } catch (e) {
          print("Caught error in Try MEthod");

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Under maintenance. Try uploading After Some Time"),
          ));

          print(currentPage);
        }
      }

      if (currentPage == 3) {
        _firestore
            .collection("users")
            .doc("$uID")
            .update({"nikeName": _data.text});

        widget.changeIt();

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => MainPageController())));

        DateTime now = DateTime.now();
        await AuthMethods().SendMessge("has Poped Up. Say Hi", uID,
            now.toString(), true, uID, "", false, false, true);
      }

      if (currentPage == 1) {
        setState(() {
        currentPage = currentPage + 2;
      });
      }else{
        setState(() {
          currentPage = currentPage + 1;
        });
      }
    }

    changeIt(changeCanBeGood) {
      setState(() {
        picClicked = true;
        filePath.setAll(0, changeCanBeGood);
      });
      print("came here State Changed from Child Element");
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Hopeless Romantics",
            style: GoogleFonts.alegreyaSansSc(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ),
        ),
        body: Column(
          children: [
            // Center(
            // child:
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Container(
                        color: Colors.blue,
                        margin: const EdgeInsets.symmetric(horizontal: 100),
                        height: 2,
                        child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.pink)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      currentPage == 2
                          ? PhotoContainer(
                              picClicked: changeIt,
                            )
                          // check this out
                          : ShowUpAnimation(
                              delayStart: Duration(seconds: 1),
                              animationDuration: Duration(seconds: 1),
                              curve: Curves.bounceIn,
                              direction: Direction.vertical,
                              offset: 0.5,
                              child: TextContainer(
                                  title: title,
                                  hintText: hintText,
                                  data: _data),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            // ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 35),
              // color: Colors.white,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: TextButton(
                onPressed: () {
                  onHandleChange();
                },
                child: Text(
                  btnText,
                  style: GoogleFonts.itim(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
