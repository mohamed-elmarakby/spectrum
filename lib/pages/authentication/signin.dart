import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/login_model.dart';
import 'package:graduation_project/models/token_decryption_model.dart';
import 'package:graduation_project/pages/authentication/forgot_password.dart';
import 'package:graduation_project/pages/authentication/signup.dart';
import 'package:graduation_project/pages/main_screens/home_screen.dart';
import 'package:graduation_project/services/authentication_services.dart';
import 'package:graduation_project/services/freinds_services.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/alrert_manger.dart';
import 'package:graduation_project/widgets/error_text.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:page_transition/page_transition.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool showError = false;
  bool showPassword = true;
  bool loginLoading = false;
  LoginResponse registerResponse = LoginResponse();
  Future login() async {
    if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
      setState(() {
        showError = true;
      });
      return;
    } else {
      setState(() {
        loginLoading = true;
      });
      await AuthenticationServices()
          .loginApi(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((value) async {
        if (value.success) {
          log(value.success.toString());
          log(json.encode(value).toString());
          // log(json.encode(value).toString());
          Map<String, dynamic> info = Jwt.parseJwt(value.token);
          log(info['address'].toString());
          info.putIfAbsent('address', () => null);
          log(info.toString());
          log(info['id'].toString());
          await SharedPref().save('user', info);
          String tempUser = await readData(key: 'user');
          setState(() {
            user = UserInfo.fromJson(json.decode(tempUser));
          });
          print(info);
          await FriendsServices()
              .userInfoApi(userId: info['id'].toString())
              .then((value1) async {
            await AuthenticationServices()
                .sendToken(userId: value1.id)
                .then((value) async {
              if (value) {
                setState(() {
                  loginLoading = false;
                });
                log(value1.address);
                setState(() {
                  user.address = value1.address;
                  info['address'] = user.address;
                });
                await SharedPref().save('user', info);
                log(user.toString() +
                    user.runtimeType.toString() +
                    user.address);
                log('value1.id: ${value1.id} , mobileToken: $mobileToken');
                Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        type: PageTransitionType.fade,
                        child: HomeScreen()));
              } else {
                setState(() {
                  loginLoading = false;
                });
                AlertsManager().showError(
                    context: context,
                    title: 'Ops..',
                    body: 'Something Went Wrong',
                    description: 'Something Went Wrong');
              }
            }).catchError((onError) {
              log(onError.toString());
              setState(() {
                loginLoading = false;
              });
              AlertsManager().showError(
                  context: context,
                  title: 'Ops..',
                  body: 'Something Went Wrong',
                  description: 'Something Went Wrong');
            });
          }).catchError((onError) {
            log(onError.toString());
            setState(() {
              loginLoading = false;
            });
            AlertsManager().showError(
                context: context,
                title: 'Ops..',
                body: 'Something Went Wrong',
                description: 'Something Went Wrong');
          });
        } else {
          setState(() {
            loginLoading = false;
          });
          AlertsManager().showError(
              context: context,
              title: 'Ops..',
              body: 'Email or Password is Incorrect',
              description: 'Email or Password is Incorrent');
        }
      }).catchError((onError) {
        log(onError.toString());
        setState(() {
          loginLoading = false;
        });
        AlertsManager().showError(
            context: context,
            title: 'Ops..',
            body: 'Something Went Wrong',
            description: 'Something Went Wrong');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
                    "Login",
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
              Padding(
                padding: EdgeInsets.only(top: 12, bottom: 8),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: login,
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
                              "Login",
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
                    "Don't have an account? ",
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
                              child: SignUp()));
                    },
                    child: Text(
                      "Sign Up now!",
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
                            child: ForgotPassword()));
                  },
                  child: Text(
                    "Forgot Password?",
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
      ),
    );
  }
}
