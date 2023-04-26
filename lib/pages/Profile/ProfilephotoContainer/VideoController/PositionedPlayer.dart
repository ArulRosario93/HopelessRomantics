import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PositionedPlayer extends StatefulWidget {
  PositionedPlayer({super.key, required this.file, required this.toPlay});

  final file;
  final bool toPlay;

  @override
  State<PositionedPlayer> createState() => _PositionedPlayerState();
}

class _PositionedPlayerState extends State<PositionedPlayer> {
  VideoPlayerController? _controller;

  bool initialized = false;

  @override
  void initState() {
    setController();
    super.initState();
  }

  void setController() {
      _controller = VideoPlayerController.network(widget.file!)
        ..addListener(() => setState(() {}))
        ..initialize()
        ..play()
        ..setLooping(true);

      print(widget.toPlay);

      // widget.toPlay ? _controller?.play() : _controller?.pause();

      setState(() {
        initialized = true;
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
        // constraints: BoxConstraints(maxHeight:50),
        child: _controller!.value.isInitialized
            ? Container(
                // constraints: BoxConstraints(maxHeight: 580),
                child: InkWell(
                    onTap: () {},
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
                            constraints: BoxConstraints(maxWidth: 630),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            height: 6,
                            // color: Colors.white,
                            alignment: Alignment.center,
                            child: VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                            ),
                          ),
                        ],
                      ),
                    )))
            : Container(
                child: Center(child: CircularProgressIndicator(color: Colors.white,)),
              ));
  }
}
