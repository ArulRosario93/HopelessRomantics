import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoContainer extends StatefulWidget {
  const PhotoContainer({super.key, required this.picClicked});

  final picClicked;

  @override
  State<PhotoContainer> createState() => _PhotoContainerState();
}

class _PhotoContainerState extends State<PhotoContainer> {
  bool picChanged = false;
  File file = File("");

  @override
  void initState() {
    setDataSon();
    super.initState();
  }

  void setDataSon() {
    setState(() {
      picChanged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            child: Text(
              "Upload Profile",
              style: GoogleFonts.istokWeb(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                onTap: () async {
                  final results = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: [
                      "png",
                      "jpg",
                    ],
                  );

                  if (results == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No file Selected")));

                    setState(() {
                      widget.picClicked("");
                    });

                    return null;
                  }

                  if (results != null) {
                    List link = [];
                    String filePath = results.files.first.path!;

                    setState(() {
                      picChanged = true;
                      file = File(filePath);
                      widget.picClicked("$filePath");
                    });
                  }
                },
                child: picChanged
                    ? Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(file),
                          )),
                    )
                    : Image.network(
                        "https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png",
                        height: 150.0,
                        width: 100.0,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
