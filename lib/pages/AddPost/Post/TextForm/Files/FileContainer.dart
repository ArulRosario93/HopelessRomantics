import 'dart:io';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/Files/VideoController/VideoController.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FileContainer extends StatefulWidget {
  FileContainer({
    super.key,
    required this.file,
    required this.description,
    required this.data,
    required this.nowWhat,
    required this.lenIT,
  });

  final file;
  final data;
  final nowWhat;
  final String description;
  final lenIT;

  @override
  State<FileContainer> createState() => _FileContainerState();
}

class _FileContainerState extends State<FileContainer> {
  late File file;
  bool isImage = false;

  @override
  void initState() {
    setState(() {
      file = File(widget.file!);
    });
    setData();
    super.initState();
  }

  void setData() {
    setState(() {
      file = File(widget.file!);
    });

    String pathHere = widget.file!;
    String getExten = pathHere.substring(pathHere.length - 3).toLowerCase();
    if (getExten == "mp4") {
      setState(() {
        isImage = false;
      });
    } else if (getExten == "jpg") {
      setState(() {
        isImage = true;
      });
    } else if (getExten == "peg") {
      setState(() {
        isImage = true;
      });
    } else if (getExten == "png") {
      setState(() {
        isImage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            //widget.data["profileSrc"])

            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(75)),
                        child: CachedNetworkImage(
                          errorWidget: (context, url, error) => Container(
                            width:  20,
                            height: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                // borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage("assets/images/avata.png"))),
                          ),
                          fit: BoxFit.cover,
                          imageUrl: widget.data["profileSrc"]),
                        ),
                      ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.description.isNotEmpty
                            ? Container(
                                child: Text(
                                  widget.description,
                                  style: GoogleFonts.itim(
                                      textStyle: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                ),
                              )
                            : Container(),
                        Container(
                          child: Text(
                            widget.data["username"],
                            style: GoogleFonts.itim(
                                textStyle: TextStyle(
                                    fontWeight: widget.description.length > 1
                                        ? FontWeight.w700
                                        : FontWeight.w800,
                                    fontSize: widget.description.length > 1
                                        ? 17
                                        : 19)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                isImage
                    ? Container(
                        constraints: const BoxConstraints(maxHeight: 580),
                        child: Center(
                          child: Image(
                            image: FileImage(file),
                            // fit: BoxFit,
                          ),
                        ))
                    : VideoController(
                        file: file,
                        toPlay: false,
                      ),

                //Indicating POSTS
                widget.lenIT > 1?
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 575,
                  // color: Colors.red,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for(var i=0; i<widget.lenIT;i++ )
                          i == widget.nowWhat? Container(child:  Text(".", style: TextStyle(fontSize: 30,color: Colors.red),),): Container(child:  Text(".", style: TextStyle(fontSize: 30,color: Colors.blue),),)
                      ],
                    ),
                  ),
                ) : Container()
              ],
            ),
          ],
        ));
  }
}
