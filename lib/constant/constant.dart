import 'package:flutter/material.dart';

class Constants {
  String apiUrl = 'http://192.168.1.7:3000/api/';
}

class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xff000000, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff000000), //10%
      100: const Color(0xff000000), //20%
      200: const Color(0xff000000), //30%
      300: const Color(0xff000000), //40%
      400: const Color(0xff000000), //50%
      500: const Color(0xff000000), //60%
      600: const Color(0xff000000), //70%
      700: const Color(0xff000000), //80%
      800: const Color(0xff000000), //90%
      900: const Color(0xff000000), //100%
    },
  );
}

Color scaffoldBgColor = Color(0xFFF4F4F4);
Color primaryColor = Color(0xFF44B6C8);
Color greyColor = Colors.grey;
Color whiteColor = Colors.white;
Color blackColor = Colors.black;
Color lightPrimaryColor = primaryColor.withOpacity(0.3);

double fixPadding = 10.0;

SizedBox widthSpace = SizedBox(width: 10.0);

SizedBox heightSpace = SizedBox(height: 10.0);

TextStyle splashBigTextStyle = TextStyle(
  color: whiteColor,
  fontSize: 40.0,
  fontFamily: 'Pacifico',
);

TextStyle appBarTextStyle = TextStyle(
  fontSize: 18.0,
  color: blackColor,
  fontWeight: FontWeight.w500,
);

// Black Text Style Start

TextStyle extraLargeBlackTextStyle = TextStyle(
  fontSize: 35.0,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle blackHeadingTextStyle = TextStyle(
  fontSize: 20.0,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle blackBigTextStyle = TextStyle(
  fontSize: 18.0,
  color: blackColor,
  fontWeight: FontWeight.w500,
);

TextStyle blackBigBoldTextStyle = TextStyle(
  fontSize: 18.0,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle blackNormalTextStyle = TextStyle(
  fontSize: 18.0,
  color: blackColor,
);

TextStyle blackSmallBoldTextStyle = TextStyle(
  fontSize: 15.0,
  color: blackColor,
  fontWeight: FontWeight.w500,
);

TextStyle blackSmallTextStyle = TextStyle(
  fontSize: 15.0,
  color: blackColor,
);

TextStyle blackExtraSmallTextStyle = TextStyle(
  fontSize: 13.0,
  color: blackColor,
);

TextStyle blackExtraSmallBoldTextStyle = TextStyle(
  fontSize: 13.0,
  color: blackColor,
);

TextStyle blackColorButtonTextStyle = TextStyle(
  fontSize: 18.0,
  color: blackColor,
  fontWeight: FontWeight.w500,
);

// Black Text Style End

// White Text Style Start

TextStyle extraLargeWhiteTextStyle = TextStyle(
  fontSize: 35.0,
  color: whiteColor,
  fontWeight: FontWeight.bold,
);

TextStyle whiteSmallBoldTextStyle = TextStyle(
  fontSize: 15.0,
  color: whiteColor,
  fontWeight: FontWeight.w500,
);

TextStyle whiteSmallTextStyle = TextStyle(
  fontSize: 15.0,
  color: whiteColor,
);

TextStyle whiteExtraSmallTextStyle = TextStyle(
  fontSize: 13.0,
  color: whiteColor,
);

TextStyle whiteColorButtonTextStyle = TextStyle(
  fontSize: 18.0,
  color: whiteColor,
  fontWeight: FontWeight.w500,
);

// White Text Style End

// Grey Text Style Start

TextStyle smallBoldGreyTextStyle = TextStyle(
  fontSize: 15.0,
  color: greyColor,
  fontWeight: FontWeight.w500,
);

TextStyle greySmallTextStyle = TextStyle(
  fontSize: 15.0,
  color: greyColor,
);
TextStyle greyExtraSmallTextStyle = TextStyle(
  fontSize: 12.0,
  color: greyColor,
);
TextStyle greyNormalTextStyle = TextStyle(
  fontSize: 18.0,
  color: greyColor,
);

// Grey Text Style End

// Primary Color Text Style Start

TextStyle primaryColorButtonTextStyle = TextStyle(
  fontSize: 18.0,
  color: primaryColor,
  fontWeight: FontWeight.w500,
);

TextStyle primaryColorHeadingTextStyle = TextStyle(
  fontSize: 20.0,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle primaryColorSmallTextStyle = TextStyle(
  fontSize: 15.0,
  color: primaryColor,
);

// Primary Color Text Style End

TextStyle bigPriceTextStyle = TextStyle(
  fontSize: 14.0,
  color: primaryColor,
  fontFamily: 'Noto Sans',
);

// Map Text Style Start

TextStyle mapHeadingStyle = TextStyle(
  fontSize: 14.0,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle mapAddressStyle = TextStyle(
  fontSize: 12.0,
  color: blackColor,
  fontWeight: FontWeight.w500,
);

TextStyle mapDescStyle = TextStyle(
  fontSize: 11.0,
  color: primaryColor,
  fontWeight: FontWeight.w500,
);

// Map Text Style End

TextStyle blueSmallTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.blue,
);

TextStyle yellowExtraLargeTextStyle = TextStyle(
  color: Colors.yellow,
  fontWeight: FontWeight.w500,
  fontSize: 40.0,
  height: 1.3,
);

// Login Signup Text Style

TextStyle loginBigTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 30.0,
  fontWeight: FontWeight.w600,
);
TextStyle whiteBigLoginTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  fontWeight: FontWeight.w400,
);
TextStyle whiteSmallLoginTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
);

TextStyle blackSmallLoginTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
);

TextStyle inputLoginTextStyle = TextStyle(
  fontFamily: 'Noto Sans',
  color: Colors.white,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);

TextStyle inputOtpTextStyle = TextStyle(
  fontFamily: 'Noto Sans',
  color: Colors.white,
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
);

// Walkthrough Text

TextStyle walkthroughWhiteBigTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 30.0,
  fontWeight: FontWeight.w600,
);

TextStyle walkthroughPrimaryColorBigTextStyle = TextStyle(
  color: primaryColor,
  fontSize: 30.0,
  fontWeight: FontWeight.w600,
);

TextStyle walkrhroughWhiteSmallTextStyle = TextStyle(
  fontSize: 15.0,
  color: whiteColor.withOpacity(0.7),
);
