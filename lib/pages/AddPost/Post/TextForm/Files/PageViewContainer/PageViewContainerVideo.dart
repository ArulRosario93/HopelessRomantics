import 'package:connectivity_plus/connectivity_plus.dart';
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/variables.dart' as variables;


class PageViewHereContainerVideo extends StatefulWidget {
  PageViewHereContainerVideo({super.key, required this.file});

  final file;

  @override
  State<PageViewHereContainerVideo> createState() =>
      _PageViewHereContainerVideoState();
}

class _PageViewHereContainerVideoState
    extends State<PageViewHereContainerVideo> {
  VideoPlayerController? _controller;

  bool playIt = true;
  bool setMaintanence = false;
  bool connectionStatus = false;

  @override
  void initState() {
    setController();
    connectionCheck();
    Future.delayed(Duration(seconds: 9), () => setMaintanenceNow());
    super.initState();
  }

  void setMaintanenceNow() {
    if (!_controller!.value.isInitialized) {
      setState(() {
        setMaintanence = true;
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

  void setController() {
    try {
      _controller = VideoPlayerController.network(widget.file)
        ..addListener(() => setState(() {}))
        ..initialize()
        ..setLooping(true);
    } catch (e) {
      print("Error In Playing Video");
      print("Error In Playing Video");
      print("Error In Playing Video");
      print("Error In Playing Video");
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
        child: GestureDetector(
          onTap: () {
            setState(() {
              playIt = !playIt;
            });
            setState(() {
              playIt ? _controller!.pause() : _controller!.play();
            });
          },
          child: connectionStatus
              ? _controller!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VisibilityDetector(
                        key: Key(_controller!.dataSource),
                        onVisibilityChanged: (VisibilityInfo info) {
                          if (info.visibleFraction >= 0.7) {
                            if (variables.playing) {
                                variables.playing = false;

                                Future.delayed(
                                    Duration(milliseconds: 3100), () => {variables.audioPlayer.pause()});
                              }
                            setState(() {
                              playIt = !playIt;
                            });
                            print(playIt);
                            _controller!.play();
                          } else {
                            if (variables.playing) {
                              variables.playing = true;
                              variables.audioPlayer.setVolume(1);
                              variables.audioPlayer.resume();
                            }
                            setState(() {
                              playIt = !playIt;
                            });
                            print(playIt);
                            _controller!.pause();
                          }
                        },
                        child: Stack(children: <Widget>[
                          Container(
                            child: VideoPlayer(
                              _controller!,
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 630),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            height: 6,
                            alignment: Alignment.center,  
                            child: VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                            ),
                          ),
                        ]),
                      ))
                  : setMaintanence? ShowUpAnimation(
                              delayStart: Duration(seconds: 1),
                              animationDuration: Duration(seconds: 2),
                              curve: Curves.easeIn,
                              direction: Direction.vertical,
                              offset: 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: LottieBuilder.asset(
                                          "assets/images/undermaintanence.json", height: 300, ),
                                    ),
                                    Text(
                                      "Try Checking after some time",
                                    style: GoogleFonts.itim(textStyle: TextStyle(color: Colors.white, fontSize: 12),),
                                    ),
                                  ],
                                )): Center(
                                  child: CircularProgressIndicator(color: Colors.white,),
                                )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(Icons.network_check_sharp, color: Colors.white,),
                              ),
                              Text("Low Network Connectivity or No Network Connection", style: TextStyle(color: Colors.white),)
                            ],
                          ),
                    ));
  }
}