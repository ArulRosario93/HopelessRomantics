import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopeless_romantic/Authentication/AuthMethods.dart';
import 'package:hopeless_romantic/Authentication/MainPageController.dart';
import 'package:hopeless_romantic/pages/Home.dart';
import 'package:hopeless_romantic/pages/StarterPages/SignUpPage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.changeIt});

  final changeIt;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool sayWhat = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool connectionStatus = true;

  String whatSay = "";

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
    void signtheuserIn() async {
      if (!connectionStatus) {
        String finalEmail = _emailController.text.replaceAll(' ', '');

        String res = await AuthMethods()
            .signInUser(email: finalEmail, password: _passwordController.text);

        if (res ==
            "[firebase_auth/invalid-email] The email address is badly formatted.") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Email address is badly formatted."),
          ));
        } else if (res ==
            "[firebase_auth/internal-error] An internal AuthError has occurred.") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Enter Password"),
          ));
        } else if (res ==
            "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Password is invalid"),
          ));
        } else if (res ==
            "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "There is no user record corresponding to this identifier."),
          ));
        } else if (res ==
            "[firebase_auth/unknown] Given String is empty or null") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Given String is empty or null"),
          ));
        } else {
          print(res);
          if (_emailController.text.isNotEmpty &&
              _passwordController.text.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.pinkAccent,
              content: Text("Logging In"),
            ));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainPageController()));
          }
        }
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        // backgroundColor: Color.fromARGB(179, 0, 0, 0),
        backgroundColor: sayWhat
            ? Color.fromARGB(255, 20, 20, 20)
            : Color.fromARGB(220, 255, 21, 107),
        body: SafeArea(
            child: Container(
          decoration: BoxDecoration(
              color: sayWhat
                  ? Color.fromARGB(255, 29, 29, 29)
                  : Color.fromARGB(220, 255, 21, 107)),
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
                      // print("CLicked");
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 15,
                      ),
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
                child: Text(
                  "LOGIN",
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        fontSize: 26.5,
                        color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 5,
              ),
              connectionStatus
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color:sayWhat? Color.fromARGB(68, 0, 0, 0): Color.fromARGB(143, 244, 67, 54),
                        border: sayWhat? Border.all(color: Colors.black, width: 0.5): Border.all(color: Colors.red, width: 0.5),
                      ),
                      child: Text(
                        "No Internet Connection!",
                        style: TextStyle(color: sayWhat?Colors.white : Color.fromARGB(211, 255, 255, 255)),
                      ))
                  : Container(),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 320),
                // padding: EdgeInsets.symmetric(vertical: 8),
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
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    hoverColor: Colors.transparent,
                    hintText: "Enter Email",
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
                // width: 300,
                constraints: BoxConstraints(maxWidth: 320),
                // padding: EdgeInsets.symmetric(vertical: 8),

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
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    hoverColor: Colors.transparent,
                    hintText: "Enter Password",
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
              Container(
                margin: EdgeInsets.only(right: 10),
                width: 300,
                alignment: Alignment.centerRight,
                child: Text(
                  "",
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(
                        letterSpacing: 1,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 4,
              ),
              TextButton(
                child: Container(
                  height: 55,
                  constraints: BoxConstraints(maxWidth: 320),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Login",
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                onPressed: () {
                  signtheuserIn();
                },
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't Have An Account? ",
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                SignUpPage(changeIt: widget.changeIt)));
                      },
                      // style: TextButton(),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 0, 255, 255)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
            ],
          ),
        )));
  }
}
