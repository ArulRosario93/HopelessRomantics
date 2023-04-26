import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hopeless_romantic/Authentication/MainPageController.dart';
import 'package:hopeless_romantic/pages/StarterPages/LoginPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      //     apiKey: "AIzaSyCqZKFRY3cG9ElNNyyOjBCzXM2lmjj0k1k",
      //     appId: "1:953574642243:web:f4c36c79de6abcfc47baf6",
      //     messagingSenderId: "953574642243",
      //     projectId: "hopeless-romantics",
      //     storageBucket: "hopeless-romantics.appspot.com")
    );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool registerDone = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    void changeIt() {
      setState(() {
        registerDone = true;
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hopeless Romantics',  
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return MainPageController();
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 17, 17, 17),
              ),
            );
          }
          // return LoginPage();
          return LoginPage(changeIt: changeIt);
        },
      ),
    );
  }
}