import 'dart:io';

import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/TextController/TextForm.dart';
import "./Post//TextForm/Files/Files.dart";

class AddPost extends StatelessWidget {
  const AddPost({super.key, required this.data});

  final data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: TextButton(
                  onPressed: () {
                    
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TextForm(
                                  haveLike: false,
                                )));
                  },
                  child: Text(
                    "Wanna Write",
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                "OR",
                style: GoogleFonts.istokWeb(
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextButton(
                  onPressed: () async {
                    try {
                      final results = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg', "mp4"],
                      );

                      int couutnt = results!.files.length;
                      var link;

                      if (results == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("No file Selected")));
                        return null;
                      }

                      if (results != null) {
                        if (couutnt == 1) {
                          print("Coming THrough1");
                          List link = [];
                          String fileName = results.files.first.name;
                          print("Coming THrough2");

                          File file = File(results.files.first.path!);
                          print("Coming THrough3");

                          link.add(file.path);

                          print(link);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Files(
                                        data: data,
                                        fileName: fileName,
                                        filePath: link,
                                      )));
                        }

                        if (couutnt >= 2) {
                          // List<File> files =
                          List<String> files =
                              results.paths.map((path) => (path!)).toList();
                          link = files;
                          // var LINK = links[0];

                          

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Files(
                                        data: data,
                                        fileName: "rosari",
                                        filePath: link,
                                      )));
                        }
                      }
                    } catch (e) {
                      print("ERRRRR EREROEOROEROER");
                      print("ERRRRR EREROEOROEROER");
                      print(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Error Captured. Try Clearing the Cache Data.")));
                    }
                  },
                  child: Text(
                    "Wanna Post?",
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
