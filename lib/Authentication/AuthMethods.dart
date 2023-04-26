import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter_imagekit/flutter_imagekit.dart';
import 'package:hopeless_romantic/Models/Message.dart';
import 'package:hopeless_romantic/Models/Post.dart';
import 'package:hopeless_romantic/Models/User.dart' as Model;
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage Storage = FirebaseStorage.instance;

  //Sign Up User
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String nickName,
    required String bio,
    required String profileSrc,
    required String loves,
    required bool darkTheme,
  }) async {
    String res = "Error bhai";
    try {
      //Creating User with Email and Password
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential ucred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        Model.User user = Model.User(
            Email: email,
            name: "name",
            nickName: 'nickName',
            uid: ucred.user!.uid,
            bio: "bio",
            profileSrc: "profileSrc",
            darkTheme: true,
            loves: 0);

        await _firestore.collection("users").doc(ucred.user!.uid).set(
              user.toJson(),
            );
      }

      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    print(res);

    return res;
  }

  //SignIn User
  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = "what happening";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "success In Logging In";
    } catch (e) {
      print(e.toString());
      res = e.toString();
    }

    return res;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/private.png');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<List> uploadFile(fileName, filePath, source, bool isPost, bool files,
      bool profileDefault) async {
    List LINK = [];
    int fileLen = filePath.length;
    print('$fileLen len of the files');
    print("$filePath file path");
    if (fileLen == 1) {
      print("Single Upload");
      String pathHere = filePath[0];

      String exten = pathHere.substring(pathHere.length - 3).toLowerCase();

      late UploadTask uploadTask;

      File file = File("");
      Reference ref = FirebaseStorage.instance
          .ref()
          .child(source)
          .child(_auth.currentUser!.uid);

      String id = Uuid().v1();
      String finalPath = "$id.$exten";

      if (source == "profilePics") {

        print("Uploaddinngg herhehrehrere");
        print("Uploaddinngg herhehrehrere");
        print("Uploaddinngg herhehrehrere");
        print("Uploaddinngg herhehrehrere");
        print("Uploaddinngg herhehrehrere");

        file = File(pathHere);
        uploadTask = ref.putFile(file);
      }

      if (isPost) {
        ref = ref.child(finalPath);
      }

      try {
        if (profileDefault) {
          // final response = await http.get(Uri.parse('https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png'));

          // final filetemp = await FlutterAbsolutePath.getAbsolutePath();

          // File file;

          File f = await getImageFileFromAssets('images/private.png');

          uploadTask = ref.putFile(f);
          print("ABOVE");
        } else {
          file = File(filePath[0]);
          uploadTask = ref.putFile(file);
        }
        TaskSnapshot snapshot = await uploadTask;
        String downloadURL = await snapshot.ref.getDownloadURL();

        LINK.add(downloadURL);
      } catch (e) {
        print("hmmmm its A Error");
      }
    } else {
      int lenIt = filePath.length;
      print("before loop");
      String id = Uuid().v1();
      for (var i = 0; i <= fileLen - 1; i++) {
        String pathHere = filePath[i];

        String isPath = pathHere.substring(pathHere.length - 3).toLowerCase();

        String id = Uuid().v1();
        String finalPath = "$id.$isPath";

        final path = "Posts/${_auth.currentUser!.uid}/$id/$finalPath";
        File file = File(filePath[i]);
        print("$file $i");
        Reference ref = FirebaseStorage.instance.ref().child(path);
        print("Came here $i");

        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadURL = await snapshot.ref.getDownloadURL();
        LINK.add(downloadURL);
      }
      print("Done!");
    }
    print("$LINK for upload file");
    return LINK;
  }

  Future<String> uploadAudio(
    final cacheLink,
  ) async {
    String res = "err";

    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("Audio")
          .child(FirebaseAuth.instance.currentUser!.uid);

      late UploadTask uploadTask;

      uploadTask = ref.putFile(cacheLink);

      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"audiofile": downloadURL, "cachefile": cacheLink.path});

      res = "SUCCESS";
    } catch (e) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"cachefile": cacheLink.path});
      res = "SUCCESS";
    }

    return res;
  }

  Future<List> uploadPOST(
    List filePath,
  ) async {
    List LINK = [];

    int LEN = filePath.length;

    for (var i = 0; i <= LEN - 1; i++) {
      File file = File(filePath[i]);
      String URL = await ImageKit.io(
        file,
        privateKey:
            "private_YTJ7ScvB+onCKALWTW8qo8nKXvI=", // (Keep Confidential)
        onUploadProgress: (progressValue) {
          // if (kDebugMode) {
          //   print(progressValue);
          // }
          // setState(() {
          //   linearProgress = progressValue;
          // });
          print(progressValue);
        },
      );
      print("Finished $i");
      LINK.add(URL);
    }

    return LINK;
  }

  Future<String> SendMessge(
    String message,
    String uid,
    datePublished,
    bool header,
    String linkID,
    String sentby,
    bool textPost,
    bool filePost,
    bool newUser,
  ) async {
    String res = "some err ah";
    try {
      Message messageSend = Message(
        message: message,
        uid: uid,
        header: header,
        linkID: linkID,
        datePublished: datePublished,
        sentby: sentby,
        textPost: textPost,
        filePost: filePost,
        newUSer: newUser,
      );

      _firestore.collection("chatRoom").doc().set(
            messageSend.toJson(),
          );

      res = "SUCCESS";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> uploadPost(
    String description,
    String file,
    String uid,
    String username,
    String postId,
    List filePath,
  ) async {
    String res = "Some Error";
    try {
      List photoURl = [];
      print("CAME TILL HERE1");
      for (var i = 0; i <= filePath.length - 1; i++) {
        String file = filePath[i];
        List fileINList = [filePath[i]];

        String exten = file.substring(file.length - 3).toLowerCase();

        print(fileINList);
        print("CAME TILL HERE");
        if (exten == 'mp4') {
          List getIT = await AuthMethods()
              .uploadFile("fileName", fileINList, "Posts", true, false, false);
          print(getIT);
          photoURl.addAll(getIT);
          print("UPLOADED IN uploadFile");
        } else {
          print("ENTERED HERE");
          List getIT = await AuthMethods()
              .uploadFile("fileName", fileINList, "Posts", true, false, false);
          // List getIT = await AuthMethods().uploadPOST(fileINList);
          print(getIT);
          photoURl.addAll(getIT);
          print("UPLOADED IN uploadPOST");
        }
      }

      print("$photoURl from upload Post");

      Post post = Post(
          datePublished: DateTime.now(),
          loves: 0,
          postid: postId,
          postURL: photoURl,
          uid: uid,
          viewed: false,
          type: "post",
          description: description,
          profImg: "profilePic");

      _firestore.collection("Posts").doc(postId).set(
            post.toJson(),
          );

      res = "SUCCESS";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
