import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/login_model.dart';
import 'package:graduation_project/models/token_decryption_model.dart';
import 'package:graduation_project/pages/authentication/signin.dart';
import 'package:graduation_project/pages/authentication/signup.dart';
import 'package:graduation_project/pages/main_screens/home_screen.dart';
import 'package:graduation_project/services/authentication_services.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/error_text.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:page_transition/page_transition.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();
  bool showError = false;
  bool loginLoading = false;
  Future resetPassword() async {}

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontFamily: "GE_SS_TWO",
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Email",
                    style: TextStyle(
                      fontFamily: "GE_SS_TWO",
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20),
                      hintText: 'Your Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                showError
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ErrorText(),
                      )
                    : Container()
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 8),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: resetPassword,
                child: Container(
                  height: height / 16,
                  width: width / 2.25,
                  decoration: BoxDecoration(
                    color: Color(0xff000000),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0.00, 3.00),
                        color: Color(0xff000000).withOpacity(0.35),
                        blurRadius: 6,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20.00),
                  ),
                  child: Center(
                    child: loginLoading
                        ? SpinKitWave(
                            color: Colors.white,
                            size: 14,
                          )
                        : Text(
                            "Send Code",
                            style: TextStyle(
                              fontFamily: "GE_SS_TWO",
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Color(0xffffffff),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 21.0),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          type: PageTransitionType.fade,
                          child: SignIn()));
                },
                child: Text(
                  "Go to Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "GE_SS_TWO",
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: Color(0xff575d63),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
