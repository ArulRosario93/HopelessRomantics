import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hopeless_romantic/pages/Profile/FileControllerProfile.dart';
import 'package:hopeless_romantic/pages/Profile/ProfilephotoContainer/VideoController/PositionedPlayer.dart';
import 'package:hopeless_romantic/pages/Profile/ProfilephotoContainer/VideoController/VideoController.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePhotoContainer extends StatefulWidget {
  const ProfilePhotoContainer(
      {super.key,
      required this.file,
      required this.height,
      required this.desc,
      required this.linkID,
      required this.nameHere});

  final file;
  final linkID;
  final height;
  final desc;
  final nameHere;

  @override
  State<ProfilePhotoContainer> createState() => _ProfilePhotoContainerState();
}

class _ProfilePhotoContainerState extends State<ProfilePhotoContainer> {
  late bool isImage;
  bool connectionStatus = false;
  bool FoundOnCache = false;
  late File FileHERE;

  getDATA() async {
    var file = await DefaultCacheManager().getFileFromCache(widget.file);

    if (file?.file == null) {
      setState(() {
        FoundOnCache = false;
      });
    } else {
      var fileName = file?.file.toString();
      setState(() {
        FileHERE = File(fileName!.substring(12, fileName.length - 1));
      });
      setState(() {
        FoundOnCache = true;
      });
    }
  }

  void connectionCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connectionStatus = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connectionStatus = true;
      });
    } else {
      setState(() {
        connectionStatus = true;
      });
    }
  }

  @override
  void initState() {
    getDATA();
    connectionCheck();
    super.initState();
  }

  // final overLAy = createOverLay();

  @override
  Widget build(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    bool manyorNOt = false;

    List lenIT = widget.file;

    String url = widget.file[0];
    bool exten = url.contains("mp4");

    if (lenIT.length > 1) {
      setState(() {
        manyorNOt = true;
      });
    }

    if (exten) {
      setState(() {
        isImage = false;
      });
    } else {
      setState(() {
        isImage = true;
      });
    }

    print(widget.nameHere);
    print("CAME RIGHT HERE");

    return Container(
        alignment: Alignment.center,
        child: GestureDetector(
            onTap: () {
              print("Name Given");
              print(widget.linkID);
              if (isImage) {
                Navigator.pushNamed(context, "/postPage", arguments: {
                  "type": "photo",
                  "src": widget.file,
                  "name": widget.nameHere,
                  "desc": widget.desc,
                  "postid": widget.linkID,
                });
              }
            },
            onLongPress: () {
              // overlayEntry = OverlayEntry(builder: (context) {
              //   return ShowUpAnimation(
              //       delayStart: Duration(seconds: 0),
              //       animationDuration: Duration(milliseconds: 500),
              //       curve: Curves.bounceIn,
              //       direction: Direction.vertical,
              //       offset: 0.5,
              //       child: Positioned(
              //           child: Material(
              //         color: Colors.black,
              //         child: Container(
              //           decoration: BoxDecoration(
              //               // color: Colors.red,
              //               borderRadius:
              //                   BorderRadius.all(Radius.circular(20))),
              //           // height: widget.height - 580.0,
              //           // color: Colors.a,
              //           // constraints: BoxConstraints(maxHeight: 1200),
              //           alignment: Alignment.center,
              //           child: isImage
              //               ? FoundOnCache
              //                   ? Image.file(
              //                       FileHERE,
              //                       fit: BoxFit.contain,
              //                     )
              //                   : Image(
              //                       errorBuilder:
              //                           (context, error, stackTrace) =>
              //                               Container(
              //                         child: Icon(
              //                           Icons.error_outline,
              //                           color: Colors.red,
              //                         ),
              //                       ),
              //                       // height: 200,
              //                       fit: BoxFit.contain,
              //                       image: CachedNetworkImageProvider(
              //                           widget.file[0]),
              //                     )
              //               : PositionedPlayer(
              //                   file: widget.file[0], toPlay: true),
              //         ),
              //       )));
              // });
              // overlayState.insert(overlayEntry);
            },
            onLongPressEnd: (details) {
              // print("Hand Removed");
              // overlayEntry.remove();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                isImage
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        // height: 420,
                        child: FoundOnCache
                            ? Image.file(
                                FileHERE,
                                fit: BoxFit.contain,
                              )
                            : CachedNetworkImage(
                                height: 420,
                                errorWidget: (context, url, error) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            child: LottieBuilder.asset(
                                          "assets/images/undermaintanence.json",
                                          // height: 280,
                                          fit: BoxFit.contain,
                                        )),
                                        Text(
                                          "Try Checking after someTime",
                                          style: GoogleFonts.itim(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        )
                                      ],
                                    ),
                                imageUrl: widget.file[0]),
                      )
                    : VideoController(
                        file: widget.file,
                        toPlay: false,
                        desc: widget.desc,
                        manyorNOt: manyorNOt,
                        name: widget.nameHere),
                manyorNOt
                    ? Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.my_library_add_rounded,
                          size: 17,
                          color: Colors.white,
                        ),
                      )
                    : Container()
              ],
            )));
  }
}
