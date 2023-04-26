import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/AddPost/Post/TextForm/Files/PostController.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key, this.audioPlayer, this.pauseNow});

  final audioPlayer;
  final pauseNow;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    String desc = arg["desc"];

    return Scaffold(
        backgroundColor: Color.fromARGB(184, 8, 8, 8),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            "${arg["name"]}",
            style: GoogleFonts.alegreyaSansSc(
              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
        ),
        body: Container(
            height: height,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:Container(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        
                        Container(
                          height: height - 120,
                          // height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          // color: Colors.white,
                          // child: arg['type'] == "photo"
                          //     ? Text("PHOTTOO")
                          //     : Text("VIDEEOOO"),

                          child: TextButton(
                            onPressed: () {
                              print("caaaaaaling");
                              pauseNow();
                            },
                            child: PostController(
                              file: arg['src'],
                              linkID: arg["postid"],
                            ),
                          ),
                          // child:PostController(file: arg['src']),

                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //     fit: BoxFit.contain,
                          //     image: NetworkImage("https://images.hellomagazine.com/imagenes/celebrities/20201113100685/ed-sheeran-hello-magazine-kind-list/0-482-478/ed-sheeran-d.jpg"),
                          //   )
                          // ),
                        ),

                        desc.length >= 1
                            ? Container(
                                height: height - 120,
                                // color: Colors.amber,
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  // alignment: Alignment.bottomCenter,
                                  // color: Colors.white,
                                  child: Stack(
                                    children: [
                                      Container(
                                        // alignment: Alignment.bottomCenter,
                                        constraints:
                                            BoxConstraints(maxWidth: 250),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 39, 39, 39),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          arg["desc"],
                                          style: GoogleFonts.itim(
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )),
            ));
  }
}
