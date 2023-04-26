import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class TextContainer extends StatelessWidget {
  const TextContainer({super.key, required this.title, required this.hintText, required this.data});

  final title;
  final hintText;
  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 200,
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: GoogleFonts.istokWeb(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: TextField(              
              controller: data,
              style: GoogleFonts.itim(),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  focusColor: null,
                  hintText: hintText,
                  hintStyle: GoogleFonts.itim(),
                  suffixIcon: Icon(Icons.settings_suggest)),
            ),
          )
        ],
      ),
    );
  }
}
