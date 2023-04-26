import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:hopeless_romantic/pages/Profile/Proflie.dart';

class ControlProfile extends StatelessWidget {
  ControlProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final res = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      
      body:  FutureBuilder(
          future: FirebaseFirestore.instance.collection("users").doc(res).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: 1,
              itemBuilder: ((context, index) => Profile(snap: snapshot.data)),
            );
          }),
    );
  }
}
