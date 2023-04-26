import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoController extends StatefulWidget {
  VideoController(
      {super.key,
      required this.file,
      required this.name,
      required this.toPlay,
      required this.manyorNOt,
      required this.desc});

  final file;
  final bool toPlay;
  final manyorNOt;
  final desc;
  final name;

  @override
  State<VideoController> createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  VideoPlayerController? _controller;

  bool connectionStatus = true;
  bool showMaintanence = false;
  bool initialized = false;
  bool error = false;

  void connectionCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connectionStatus = false;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connectionStatus = false;
      });
    } else {
      setState(() {
        connectionStatus = true;
      });
    }
  }

  @override
  void initState() {
    setController();
    connectionCheck();
    super.initState();
    Future.delayed(Duration(seconds: 9), () => setMaintanenceNow());
  }

  void setMaintanenceNow() {
    if (!_controller!.value.isInitialized) {
      setState(() {
        showMaintanence = true;
      });
    }
  }

  void setController() {
    try {
      print("Started Checking Video");
      _controller = VideoPlayerController.network(widget.file[0]!)
        ..addListener(() => setState(() {}))
        ..initialize()
        ..pause()
        ..setLooping(true);

      print(widget.toPlay);

      print("Checking Video");

      // widget.toPlay ? _controller?.play() : _controller?.pause();

      setState(() {
        initialized = true;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        // constraints: BoxConstraints(maxHeight:50),
        child: _controller!.value.isInitialized
            ? Container(
                // constraints: BoxConstraints(maxHeight: 580),
                child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: InkWell(
                  onTap: () {
                    print("Clicked");
                    if (_controller!.value.isInitialized) {
                      print(widget.file!);
                      Navigator.pushNamed(context, "/postPage", arguments: {
                        "type": "video",
                        "src": widget.file!,
                        "desc": widget.desc,
                        "name": widget.name,
                      });
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                          // constraints: BoxConstraints(maxWidth: 180),
                          // color: Colors.amberAccent,
                          child: VideoPlayer(
                        _controller!,
                      )),
                      widget.manyorNOt
                          ? Container()
                          : Container(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            )
                    ],
                  ),
                ),
              ))
            : Container(
                child: connectionStatus
                    ? Center(
                        child: Icon(
                        Icons.network_check_rounded,
                        color: Colors.white,
                      ))
                    : showMaintanence
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: LottieBuilder.asset(
                                  "assets/images/under-maintanence.json",
                                  height: 250,
                                ),
                              ),
                              Text(
                                "Try Checking after someTime",
                                style: GoogleFonts.itim(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              )
                            ],
                          )
                        : Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
              ));
  }
}
