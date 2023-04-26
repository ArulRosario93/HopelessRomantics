import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
              padding: EdgeInsets.symmetric(horizontal: 20),
              // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    child: Image.asset("assets/images/private.png"),
                  ),
                  Container(
                    width: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(alignment: Alignment.centerLeft,child: Text("Privacy", style: GoogleFonts.itim(
                          textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),),),
                        ),
                        Container(alignment: Alignment.centerRight, child: Text("Policy", style: GoogleFonts.itim(
                          textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),),),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}