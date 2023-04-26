import 'package:flutter/material.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/Files/PageViewContainer/PageViewContainerImage.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/Files/PageViewContainer/PageViewContainerVideo.dart';
import 'package:google_fonts/google_fonts.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({super.key, required this.file});

  final file;

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  bool isImage = false;
  bool error = false;

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    String pathHere = widget.file!;
    Uri uri = Uri.parse(pathHere);
    String exIt = uri.path;
    String getExten = exIt.substring(exIt.length - 3).toLowerCase();
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
    } else {
      error = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        isImage
            ? Container(
                child: PageViewContainerImage(file: widget.file),
              )
            : error
                ? Container(
                    child: Text(
                        "Error Found. That's New. Developer will deal with it soon.",
                        style: GoogleFonts.itim(
                            textStyle: TextStyle(color: Colors.white, fontSize: 14))))
                : PageViewHereContainerVideo(file: widget.file),
      ],
    );
  }
}