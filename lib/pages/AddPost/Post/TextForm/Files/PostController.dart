import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/Files/PageView/PostPageView.dart';
import 'package:lottie/lottie.dart';

class PostController extends StatefulWidget {
  const PostController({super.key, required this.file, required this.linkID});

  final List file;
  final linkID;

  @override
  State<PostController> createState() => _PostControllerState();
}

class _PostControllerState extends State<PostController> {
  bool load = false;
  bool connectionStatus = false;

  int currentPage = 0;

  var data;

  @override
  void initState() {
    getData();
    connectionCheck();
    super.initState();
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

  getData() async {
    getData() async {
      final dd = await FirebaseFirestore.instance
          .collection("Posts")
          .doc(widget.linkID)
          .get();

      final bb = dd.data()!;
      setState(() {
        data = bb["uid"];
      });
    }
  }

  void changePage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    void LikeIt() async {
      setState(() {
        load = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          load = false;
        });
      });

      await FirebaseFirestore.instance.collection("users").doc(data).update({
        "loves": FieldValue.increment(1),
      });
    }

    return GestureDetector(
      onDoubleTap: () {
        print("like it");
        LikeIt();
      },
      child: Stack(children: [
        PageView(
          onPageChanged: (value) {
            changePage(Page);
          },
          children: <Widget>[
            for (var i = 0; i <= widget.file.length - 1; i++)
              PostPageView(file: widget.file[i])
          ],
        ),

        Container(
          alignment: Alignment.topCenter,
          height: 575,
          // color: Colors.red,
          child: Container(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(var i=0; i<widget.file.length;i++ )
                  i == currentPage? Container(child:  Text(".", style: TextStyle(fontSize: 30,color: Colors.red),),): Container(child:  Text(".", style: TextStyle(fontSize: 30,color: Colors.blue),),)
              ],
            ),
          ),
        ),

        load
            ? Container(
                height: height,
                alignment: Alignment.center,
                child: Lottie.asset('assets/images/liking.json',
                    frameRate: FrameRate(300.0),
                    repeat: load,
                    width: 310,
                    fit: BoxFit.fitWidth),
              )
            : Container()
      ]),
    );
  }
}
