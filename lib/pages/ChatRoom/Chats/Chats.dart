import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:hopeless_romantic/pages/ChatRoom/Chats/ChatController.dart';

class Chats extends StatefulWidget {
  const Chats(
      {super.key,
      required this.Name,
      required this.uid,
      required this.theme,
      required this.pic});

  final Name;
  final pic;
  final theme;
  final uid;

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  ScrollController _scrollController = ScrollController();

  bool Loading = true;
  var data;
  var len;

  // @override
  // void initState() {
  //   // _scrollController.addListener(_scrollListener);
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //       _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 1),
  //       curve: Curves.fastOutSlowIn);
  //   });
  //   super.initState();
  // }

  @override
  void initState() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('chatRoom');
    reference.snapshots().listen((querySnapshot) {
      var dataFrom = querySnapshot.docChanges;
      getDATA();
      setState(() {
        len = len + 1;
      });
    });
    super.initState();
  }

  void getDATA() async {
    int documents =
        await FirebaseFirestore.instance.collection('chatRoom').get().then(
              (value) => value.size,
            ); // setState(() async {
    // });

    var Ddata = await FirebaseFirestore.instance
        .collection("chatRoom")
        .orderBy("datePublished", descending: false)
        .get();

    print("hello");
    print(documents);
    print("FORDataaaa");
    setState(() {
      data = Ddata.docs;
    });

    setState(() {
      len = documents;
    });

    setState(() {
      Loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Timer(
    //     Duration(milliseconds: 10),
    //     () => {
    //           _scrollController.animateTo(
    //               _scrollController.position.maxScrollExtent,
    //               duration: const Duration(milliseconds: 10),
    //               curve: Curves.easeOut)
    //         });

    // _scrollController.hasClients;
    // _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent + 1000,
    //     duration: const Duration(milliseconds: 1),
    //     curve: Curves.easeOut);

    // String Namee = FirebaseFirestore.instance.collection("users").doc(uid).

    // Timer(
    //     Duration(milliseconds: 0),
    //     () => _scrollController.animateTo(
    //         _scrollController.position.maxScrollExtent + 1000,
    //         duration: const Duration(milliseconds: 1),
    //         curve: Curves.ease));

    return Loading
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatRoom")
                .orderBy("datePublished", descending: false)
                // .limit(70)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              //   if (oldSnap == newSnap) {
              //     same = true;
              //   } else {
              //     same = false;
              //     oldSnap = data[i]["uid"];
              //   }
              int totalLEn = snapshot.data!.docs.length;

              // final setMessgaes = snapshot.data!.docs.reversed;

              // final gg = setMessgaes.reversed;

              return Container(
                  child: ChatController(
                      snap: snapshot.data!.docs,
                      theme: widget.theme,
                      totalLEn: totalLEn,
                      uid: widget.uid));
              //     }
              // )
              // Container(
              // color: Colors.pink,
              // height: 250,
              // child:
              // ListView.builder(
              //   itemCount: len,
              //   // controller: _scrollController,
              //   scrollDirection: Axis.vertical,
              //   physics: NeverScrollableScrollPhysics(),
              //   // shrinkWrap: true,
              //   // controller: _scrollController,
              //   itemBuilder: (context, i) {
              //     newSnap = data[i]["uid"];

              //     if (oldSnap == newSnap) {
              //       same = true;
              //     } else {
              //       same = false;
              //       oldSnap = data[i]["uid"];
              //     }

              //     return Container(
              //       child: Column(
              //         crossAxisAlignment: data[i]["uid"] != widget.uid
              //             ? CrossAxisAlignment.start
              //             : CrossAxisAlignment.end,
              //         children: [
              //           // for (var i = 0; i <= 5; i++)
              //           ChatContainer(
              //               snap: data[i],
              //               sayIt: same,
              //               uid: widget.uid,
              //               pic: widget.pic,
              //               Name: widget.Name)
              //         ],
              //       ),
              //     );

              //     // Container(
              //     //   child: Column(
              //     //     crossAxisAlignment: data[i]["uid"] != widget.uid
              //     //         ? CrossAxisAlignment.start
              //     //         : CrossAxisAlignment.end,
              //     //     children: [
              //     //       for (var i = 0; i <= 5; i++)
              //     //         ChatContainer(
              //     //             snap: data[i],
              //     //             sayIt: same,
              //     //             uid: widget.uid,
              //     //             pic: widget.pic,
              //     //             Name: widget.Name)
              //     //     ],
              //     //   ),
              //     // );
            })
        : Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
    // Container(
    //     child: Column(
    //       // crossAxisAlignment:
    //       //     snapshot.data!.docs[index]["uid"] != widget.uid
    //       //         ? CrossAxisAlignment.start
    //       //         : CrossAxisAlignment.end,
    //       children: [
    //         for (var i = 0; i <= len;i++)
    //           ChatContainer(
    //               snap: data[i],
    //               sayIt: same,
    //               uid: widget.uid,
    //               pic: widget.pic,
    //               Name: widget.Name)
    //       ],
    //     ),
    //   )
  }
}
