import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/Authentication/AuthMethods.dart';
import 'package:hopeless_romantic/Authentication/MainPageController.dart';
import 'package:hopeless_romantic/pages/Home.dart';
import 'package:hopeless_romantic/pages/StarterPages/AboutPage.dart';
import 'package:hopeless_romantic/pages/StarterPages/LoginPage.dart';
import 'package:hopeless_romantic/pages/StarterPages/PrivacyPolicy.dart';
import 'package:hopeless_romantic/pages/StarterPages/RegistringPage/RegisterPageOne.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key, required this.changeIt});

  final changeIt;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool otpVerfied = false;
  bool sayWhat = false;
  bool otpSent = false;
  bool connectionStatus = true;

  String whatSay = "";

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void connectionCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connectionStatus = false;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connectionStatus = false;
      });
    } else {
      setState(() {
        connectionStatus = true;
      });
    }
  }

  @override
  void initState() {
    connectionCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// remoteServerConfiguration : Signature
    // void SendOTP() async {
    //   bool result = await emailAuth.sendOtp(
    //       recipientMail: _emailController.text, otpLength: 5);
    //   if (result) {
    //     setState(() {
    //       otpSent = true;
    //       whatSay = "OTP sent.";
    //     });
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(whatSay),
    //     ));
    //   } else {
    //     // SnackBar(
    //     //   content: Text(whatSay),
    //     // );
    //     setState(() {
    //       whatSay = "Email ID provided is invalid";
    //     });
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(whatSay),
    //     ));
    //   }
    // }

    void verifyOTP() async {
      print("CLICKED");
      if (!connectionStatus) {
        // bool result = emailAuth.validateOtp(
        //     recipientMail: _emailController.text, userOtp: _otpController.text);
        print("CAME IN");
        print(_passwordController.text);
        print(_emailController.text);
        if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
          setState(() {
            whatSay = "Fill up Credentials";
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(whatSay),
          ));
        }

        if (_passwordController.text.isNotEmpty &&
            _emailController.text.isNotEmpty) {
          setState(() {
            otpVerfied = true;
          });

          String finalEmail = _emailController.text.replaceAll(' ', '');

          if (_otpController.text == _passwordController.text) {
            String res = await AuthMethods().signUpUser(
                email: finalEmail,
                password: _passwordController.text,
                name: "ros",
                nickName: "Pro licker",
                bio: "Ngoppa",
                profileSrc: "",
                darkTheme: true,
                loves: "20");

            print("Done here $res");

            if (res.toString() ==
                "[firebase_auth/weak-password] Password should be at least 6 characters") {
              setState(() {
                whatSay = "Password should be at least 6 characters";
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(whatSay),
              ));
            } else if (res.toString() ==
                "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
              setState(() {
                whatSay =
                    "The email address is already in use by another account";
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(whatSay),
              ));
            } else if (res.toString() ==
                "[firebase_auth/invalid-email] The email address is badly formatted.") {
              setState(() {
                whatSay = "The email address is badly formatted";
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(whatSay),
              ));
            } else if (res.toString() ==
                "[firebase_auth/internal-error] An internal AuthError has occurred.") {
              print("Why its not Seting this message");
              setState(() {
                whatSay = "Enter Password";
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(whatSay),
              ));
            } else if (res == "Success") {
              setState(() {
                _emailController.clear();
                _otpController.clear();
                _passwordController.clear();

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RegisterPageOne(changeIt: widget.changeIt)));
              });
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Password Doesn't match"),
            ));
          }
        }
      } else {
        setState(() {
          whatSay = "OTP not verfied";
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(whatSay),
        ));
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: sayWhat
            ? Color.fromARGB(255, 20, 20, 20)
            : Color.fromARGB(220, 255, 21, 107),
        body: SafeArea(
            child: Container(
          decoration: BoxDecoration(
            color: sayWhat
                ? Color.fromARGB(255, 20, 20, 20)
                : Color.fromARGB(220, 255, 21, 107),
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        sayWhat = !sayWhat;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 35,
                      height: 35,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: sayWhat
                              ? Color.fromARGB(220, 255, 21, 107)
                              : Color.fromARGB(255, 13, 13, 13),
                          borderRadius: BorderRadius.circular(17)),
                    ),
                  )
                ],
              ),
              Flexible(
                child: Container(),
                flex: 7,
              ),
              Container(
                alignment: Alignment.center,
                child: Text("REGISTER",
                    style: GoogleFonts.istokWeb(
                      textStyle: TextStyle(
                          letterSpacing: 5,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )),
              ),
              Flexible(
                child: Container(),
                flex: 9,
              ),
              connectionStatus
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(206, 253, 77, 65),
                        border: Border.all(color: Colors.red, width: 0.5),
                      ),
                      child: Text(
                        "No Internet Connection!",
                        style: TextStyle(color: Colors.red),
                      ))
                  : Container(),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 320),
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                    fillColor: Color(0xF2FFFFFF),
                    hoverColor: Colors.transparent,
                    hintText: "Email",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                  ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 320),
                alignment: Alignment.center,
                child: TextField(
                  controller: _otpController,
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    suffix: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Icon(
                        otpVerfied ? Icons.done_all_rounded : null,
                        size: 15,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                    fillColor: Color(0xF2FFFFFF),
                    hoverColor: Colors.transparent,
                    hintText: "Password",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                  ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 320),
                child: TextField(
                  controller: _passwordController,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                    fillColor: Color(0xF2FFFFFF),
                    hoverColor: Colors.transparent,
                    hintText: "Confirm Password",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Already Have An Account?",
                        style: GoogleFonts.itim(
                          textStyle: const TextStyle(
                              letterSpacing: 0,
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                  Padding(padding: EdgeInsets.only(left: 1)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage(changeIt: widget.changeIt)));
                    },
                    child: Text("Go To Login",
                        style: GoogleFonts.itim(
                          textStyle: const TextStyle(
                              letterSpacing: 0,
                              color: Color.fromARGB(
                                255,
                                0,
                                255,
                                255,
                              ),
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ],
              ),
              Flexible(
                child: Container(),
                flex: 4,
              ),
              TextButton(
                onPressed: () {
                  verifyOTP();
                },
                child: Container(
                  height: 55,
                  width: 289,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("Sign Up",
                      style: GoogleFonts.itim(
                        textStyle: const TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      )),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 4,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => AboutPage()),
                    //     );
                    //   },
                    //   child: Text("About",
                    //       style: GoogleFonts.itim(
                    //         textStyle: const TextStyle(
                    //             fontSize: 12,
                    //             letterSpacing: 1,
                    //             fontWeight: FontWeight.w500,
                    //             color: Colors.white),
                    //       )),
                    // ),
                    Padding(padding: EdgeInsets.only(left: 9)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicy()),
                        );
                      },
                      child: Text("Privacy Policy",
                          style: GoogleFonts.itim(
                            textStyle: const TextStyle(
                                fontSize: 12,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
