import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/TextController/EachTextHandler.dart';

class TextContainerhandle extends StatefulWidget {
  const TextContainerhandle({super.key, required this.setData});

  final setData;

  @override
  State<TextContainerhandle> createState() => _TextContainerhandleState();
}

class _TextContainerhandleState extends State<TextContainerhandle> {
  int addPage = 0;

  List textArray = [];
  List itsList = ["", ""];

  @override
  void initState() {
    Map hh = {
      "textField0": ["", 1]
    };

    setState(() {
      textArray.add(hh);
    });
    super.initState();
  }

  void getData() async {
    var ff = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var gg = ff.data()!;
  }

  void setData(n, int m, i) {
    setState(() {
      textArray[i]["textField$i"][0] = n;
      textArray[i]["textField$i"][1] = m;
    });

    widget.setData(textArray);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void addTextField(gg, mm) async {
      setState(() {
        addPage = addPage + 1;
      });
      Map hh = {
        "textField$addPage": ["", 1]
      };

      setState(() {
        textArray.add(hh);
      });
    }

    void removeSlide(bb) async {
      print("calling This");
      print(bb);
      setState(() {
        addPage = addPage - 1;
        textArray.removeAt(bb);
      });
      print(textArray);
      // setState(() {
      //   textArray.remove("textField$bb");
      // });
    }

    void gettingIT(String gg, int i, int alignment) {
      setData(gg, alignment, i);
    }

    return PageView(
      children: [
        for (var i = 0; i <= addPage; i++)
          EachTextHandler(
              addIT: addTextField,
              addPage: addPage,
              currentField: i,
              removeSlide: removeSlide,
              initialtextValue: textArray[i],
              getIT: gettingIT)
      ],
    );
  }
}
