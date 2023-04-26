import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/HomeMain/PostController.dart';
import 'package:hopeless_romantic/pages/HomeMain/PostHandler.dart';

class HomeMain extends StatelessWidget {
  HomeMain({super.key, required this.func});

  final func;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Posts")
              .orderBy('datePublished', descending: true)
              .snapshots(),
          // stream: FirebaseFirestore.instance.collection("textPost").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            int totalLEn = snapshot.data!.docs.length;

            //For texts Render This...\

            // if (snapshot.hasData) {
            //   return Container(
            //     // height: 500,
            //     child: totalLEn >= 1
            //         ? Center(
            //             child: SingleChildScrollView(
            //                 child: Column(children: <Widget>[
            //             for (var i = 0; i < totalLEn; i++)

            //               Container(
            //                   height: 520,
            //                   child: TextPostContainer(
            //                     snap: snapshot.data!.docs[i],
            //                     header: true,
            //                     topmar: 10.0,
            //                     fontSize: 15.0,
            //                     padding: 10.0,
            //                     height: 450.0,
            //                   )
            //                   // child: Text("${snapshot.data!.docs[i]["profileSrc"]}", style: TextStyle(color: Colors.white),),
            //               ),
            //             Padding(padding: EdgeInsets.symmetric(vertical: 10))
            //           ])))
            //         : Container(

            //         ));
            // }

            //Till This
            // return Center(
            //   child: CircularProgressIndicator(color: Colors.black),
            // );

            return PostHandler(snap: snapshot.data!.docs, length: totalLEn, func: func,);

            // return Container(
            //     child: totalLEn >= 1
            //         ? Center(
            //             child: SingleChildScrollView(
            //                 child: Column(children: <Widget>[
            //             for (var i = 0; i <= totalLEn - 1; i++)
            //               PostController(snap: snapshot.data!.docs[i], func: func)
            //             // PostContainer(snap: snapshot.data!.docs[index])
            //           ])))
            //         : Container(
            //             child: Text(
            //               "Nothing yet",
            //               style: TextStyle(color: Colors.amberAccent),
            //             ),
            //           ));

            // for(var = i; i<= snapshot.data!.docs.length - 1; i++){
            //   return
            // }

            // return ListView.builder(
            //   itemCount: snapshot.data!.docs.length,
            //   itemBuilder: ((context, index) => PostContainer(snap: snapshot.data!.docs[index])),
            // );
          }),
    );
  }
}
