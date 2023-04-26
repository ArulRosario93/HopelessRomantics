import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/pages/HomeMain/TextPostContainer/TextPostContainer.dart';

class TextPage extends StatefulWidget {
  const TextPage({super.key, required this.snap, required this.name});

  final snap;
  final name;

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    // final arg = ModalRoute.of(context)!.settings.arguments as Map;
    String desc = widget.snap["description"];


    return Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          elevation: 0.0,
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: Text(
            "${widget.name}",
            style: GoogleFonts.alegreyaSansSc(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: GestureDetector(
                onTap: () {
                  print("Clicked Tap");
                  print("Clicked Tap");
                },
                
                child: Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: TextPostContainer(
                          snap: widget.snap,
                          topmar: 0.0,
                          haveLike: true,
                          fontSize: 15.0,
                          func: null,
                          height: height - 180,
                          header: false,
                          padding: 0.0,
                        ),
                      ),
                      desc.length >= 1
                          ? Container(
                              height: height - 130,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 250),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 204, 204, 204),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        widget.snap["description"],
                                        style: GoogleFonts.itim(
                                          textStyle:
                                              TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
          ),
        )
          ],
        ));
  }
}
