import "package:flutter/material.dart";
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/Files/VideoController/VideoController.dart';

class FileControllerProfile extends StatelessWidget {
  const FileControllerProfile({super.key, required this.file, required this.sayIT});

  final file;
  final bool sayIT;

  @override
  Widget build(BuildContext context) {
    bool isImage;

    String uri = file;

    if (uri.contains("mp4")) {
      isImage = false;
    } else {
      isImage = true;
    }

    return Container(
      child: isImage
          ? Image(image: NetworkImage(uri))
          : VideoController(file: file, toPlay: sayIT),
    );
  }
}