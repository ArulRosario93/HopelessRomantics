import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 15, 15, 15),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 15, 15, 15),
          elevation: 0,
        ),
        body: Column( 
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.bottomRight,
                    height: 100,
                    margin: EdgeInsets.only(left: 20),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "About",
                      style: GoogleFonts.itim(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                          color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 230,
                    child: Image.asset("assets/images/sun.png"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
