import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:hopeless_romantic/variables.dart' as variables;

class VideoController extends StatefulWidget {
  VideoController({super.key, required this.file, required this.toPlay});

  final file;
  final bool toPlay;

  @override
  State<VideoController> createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  VideoPlayerController? _controller;

  late bool playIt;

  bool initialized = false;

  double NUMHERE = 1.0;

  @override
  void initState() {
    // controlMusic();
    setController();
    super.initState();
  }

  void controlMusic() async {
    final decreasePerMs = (1 - 0) / Duration(seconds: 1).inMilliseconds;
    final decreasePerStep = decreasePerMs * 50; // 50ms per step
    final numSteps = (Duration(seconds: 1).inMilliseconds / 50).ceil();

    for (var i = 0; i < numSteps; i++) {
      Future.delayed(Duration(milliseconds: 50 * i), () {
        setState(() {
          NUMHERE = (NUMHERE - decreasePerStep).round().toDouble();
        });
      });
      await variables.audioPlayer.setVolume(NUMHERE);
    }
    await variables.audioPlayer.pause();
  }

  void setController() {
    Future.delayed(Duration(milliseconds: 800), (() {
      _controller = VideoPlayerController.file(widget.file!)
        ..addListener(() => setState(() {}))
        ..initialize()
        ..play()
        ..setLooping(true);

      setState(() {
        initialized = true;
      });
    }));

    setState(() {
      playIt = widget.toPlay ? false : true;
    });
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
      child: initialized
          ? _controller!.value.isInitialized
              ? Container(
                  constraints: BoxConstraints(maxHeight: 580),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          playIt = !playIt;
                        });
                        setState(() {
                          playIt ? _controller!.pause() : _controller!.play();
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: Stack(
                          children: [
                            Container(
                                // color: Colors.amberAccent,
                                child: Center(
                              child: VideoPlayer(
                                _controller!,
                              ),
                            )),
                            Container(
                              height: 2,
                              child: VideoProgressIndicator(
                                _controller!,
                                allowScrubbing: true,
                              ),
                            ),
                          ],
                        ),
                      )))
              : Container(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
          : Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/images/undermaintanence.json"),
                  )),
            ),
    );
  }
}
