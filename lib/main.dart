import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/models/token_decryption_model.dart';
import 'package:graduation_project/pages/main_screens/home_screen.dart';
import 'package:graduation_project/pages/walkthrough/firstPage.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket socket;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MyApp(),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return ChangeNotifierProvider<ApplicationProvider>(
      create: (context) => ApplicationProvider(),
      child: MaterialApp(
        title: 'Spectrum',
        theme: ThemeData(
          primarySwatch: Palette.kToDark,
          fontFamily: 'Roboto',
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

UserInfo user;

class _MyHomePageState extends State<MyHomePage> {
  getUserInfo() async {
    // await SharedPref().remove('user');
    String tempUser = await readData(key: 'user');
    log(tempUser.toString());
    if (tempUser == null) {
      return Navigator.push(
          context,
          PageTransition(
              duration: Duration(milliseconds: 600),
              type: PageTransitionType.fade,
              child: FirstWalkThrough()));
    }
    user = UserInfo.fromJson(json.decode(tempUser));
    Future.delayed(Duration(seconds: 1, milliseconds: 800)).then((value) {
      Navigator.push(
          context,
          PageTransition(
              duration: Duration(milliseconds: 600),
              type: PageTransitionType.fade,
              child: HomeScreen()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/spectrum.png')),
                color: Colors.black,
                border: Border.all(
                  width: 1.00,
                  color: Color(0xff707070).withOpacity(0.50),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.00, 7.00),
                    color: Color(0xff3d3131).withOpacity(0.08),
                    blurRadius: 6,
                  ),
                ],
                shape: BoxShape.circle,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Graduation Project By Team Spectrum",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xffa0a0a0).withOpacity(0.48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
