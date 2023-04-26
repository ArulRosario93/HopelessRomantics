import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lottie/lottie.dart';

class PageViewContainerImage extends StatefulWidget {
  const PageViewContainerImage({super.key, required this.file});

  final file;

  @override
  State<PageViewContainerImage> createState() => _PageViewContainerImageState();
}

class _PageViewContainerImageState extends State<PageViewContainerImage> {
  bool FoundOnCache = false;
  late File FileHERE;

  bool connectionStatus = false;

  getDATA() async {
    var file = await DefaultCacheManager().getFileFromCache(widget.file);

    print("SAME SMAE SMAENEA");
    print(file?.file);

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
        connectionStatus = false;
      });
    }
  }

  @override
  void initState() {
    getDATA();
    connectionCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    void errororr(){
      print("printing Error");
      print("printing Error");
      print("printing Error");
      print("printing Error");
    }

    return InteractiveViewer(
      minScale: 0.1,
      maxScale: 4.6,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 580),
        child: FoundOnCache
            ? Image.file(FileHERE)
            : connectionStatus
                ? 
                    CachedNetworkImage(
                      errorWidget: (context, url, error) => Container(
                          alignment: Alignment.center,
                          child: LottieBuilder.asset("assets/images/under-maintanence.json"),
                          // decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: Colors.white,
                          //     // borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          //     image: DecorationImage(
                          //       fit: BoxFit.cover,
                          //       image: AssetImage("assets/images/avata.png")
                          //     )),
                        ),
                      imageUrl: widget.file,
                    )
                : Container(
                    child: Icon(Icons.network_check_sharp),
                  ),
        // Image(image: NetworkImage(widget.file)),
      ),
    );
  }
}