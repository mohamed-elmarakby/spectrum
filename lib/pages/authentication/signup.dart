import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/register_model.dart';
import 'package:graduation_project/models/token_decryption_model.dart';
import 'package:graduation_project/pages/authentication/signin.dart';
import 'package:graduation_project/pages/groups/groups_list.dart';
import 'package:graduation_project/pages/main_screens/home_screen.dart';
import 'package:graduation_project/services/authentication_services.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/error_text.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:developer';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmationController =
      TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  bool showError = false;
  bool showPassword = true;
  bool showConfirmationPassword = true;
  bool registerLoading = false;
  RegisterResponse registerResponse = RegisterResponse();
  Future signUp() async {
    if (_passwordController.text.isEmpty ||
        _passwordConfirmationController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _addressController.text.isEmpty) {
      setState(() {
        showError = true;
      });
      return;
    }
    if (_passwordController.text
            .compareTo(_passwordConfirmationController.text) !=
        0) {
      return;
    } else {
      setState(() {
        registerLoading = true;
      });
      await AuthenticationServices()
          .registerApi(
        name: _nameController.text,
        address: _addressController.text,
        age: _ageController.text,
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((value) async {
        if (!value.created) {
          log(value.text.toString());
        }
        if (value.created) {
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 600),
                  type: PageTransitionType.fade,
                  child: SignIn()));
        }
        setState(() {
          registerLoading = false;
        });
      }).onError((error, stackTrace) {
        log(error.toString());
        setState(() {
          registerLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Up",
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Password",
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
                      controller: _passwordController,
                      obscureText: showPassword,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20.0, right: 20),
                        hintText: 'Your Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: !showPassword
                              ? Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  color: Color(0xff000000),
                                )
                              : Icon(
                                  FontAwesomeIcons.eye,
                                  color: Color(0xff000000),
                                ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Confirm Password",
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
                      controller: _passwordConfirmationController,
                      obscureText: showConfirmationPassword,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20.0, right: 20),
                        hintText: 'Your Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: !showConfirmationPassword
                              ? Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  color: Color(0xff000000),
                                )
                              : Icon(
                                  FontAwesomeIcons.eye,
                                  color: Color(0xff000000),
                                ),
                          onPressed: () {
                            setState(() {
                              showConfirmationPassword =
                                  !showConfirmationPassword;
                            });
                          },
                        ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Name",
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
                      controller: _nameController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20.0, right: 20),
                        hintText: 'Your Name',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Address",
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
                      controller: _addressController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20.0, right: 20),
                        hintText: 'Your Address',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Age",
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
                      controller: _ageController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20.0, right: 20),
                        hintText: 'Your Age',
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
                  onTap: signUp,
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
                      child: registerLoading
                          ? SpinKitWave(
                              color: Colors.white,
                              size: 14,
                            )
                          : Text(
                              "Sign Up",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "GE_SS_TWO",
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Color(0xff575d63),
                    ),
                  ),
                  InkWell(
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
                      "Sign In!",
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
