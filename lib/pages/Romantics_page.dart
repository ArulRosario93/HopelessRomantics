import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class RomanticsPage extends StatelessWidget {
  const RomanticsPage({super.key, required this.ImageSrc, required this.name, required this.bio});

  final String ImageSrc;
  final String name;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 15, 15),
        elevation: 0.0,
      ),
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      body: Container(
        alignment: Alignment.center,
        // color: Colors.amber,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover, image: AssetImage(ImageSrc)),
                          borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                    SizedBox(height: 40,),
                    Container(
                      child: Text(name, style: GoogleFonts.itim(
                        textStyle: TextStyle(fontSize:19, color: Colors.white, fontWeight: FontWeight.w500)
                      ),),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.center,
                      width: 300,
                      // color: Colors.amber,
                      child: Text(bio, textAlign: TextAlign.center, style: GoogleFonts.itim(
                        textStyle: TextStyle(fontSize: 15, color: Colors.white)
                      ),),
                    ),

                    Container(
                      child: Text("Posts here /",style: TextStyle(color: Colors.white),),
                    ),
                  ]
                )
              )
            )
          )
        ],
      ),
      )
    ));
  }
}
