import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/pages/walkthrough/secondPage.dart';
import 'package:page_transition/page_transition.dart';

class FirstWalkThrough extends StatefulWidget {
  @override
  _FirstWalkThroughState createState() => _FirstWalkThroughState();
}

class _FirstWalkThroughState extends State<FirstWalkThrough> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: height / 2,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/signup.png"),
              ),
            ),
          ),
          Text(
            "Register",
            style: TextStyle(
              fontFamily: "GE_SS_TWO",
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xff000000),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Register now and connect with your friends",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "GE_SS_TWO",
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Color(0xff575d63),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
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
                        child: SecondWalkThrough()));
              },
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Next",
                        style: TextStyle(
                          fontFamily: "GE_SS_TWO",
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Color(0xffffffff),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: FaIcon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: Color(0x000000).withOpacity(0.42),
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
