import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/pages/authentication/signin.dart';
import 'package:graduation_project/pages/groups/groupsList_screen.dart';
import 'package:page_transition/page_transition.dart';

class AlertsManager {
  showError(
      {BuildContext context, String title, String body, String description}) {
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.ERROR,
      title: '$title',
      desc: '$description',
    )..show();
  }

  showInfo(
      {BuildContext context, String title, String body, String description}) {
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      dialogType: DialogType.INFO,
      title: '$title',
      desc: '$description',
    )..show();
  }

  showSuccess(
      {BuildContext context,
      String title,
      String body,
      String description,
      bool signup = false}) {
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.SUCCES,
      body: Center(
        child: Text(
          '$body',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      title: '$title',
      desc: '$description',
      btnOkOnPress: () {
        if (signup) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 600),
                  type: PageTransitionType.fade,
                  child: SignIn()));
        } else {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 600),
                  type: PageTransitionType.fade,
                  child: GroupsListScreen()));
        }
      },
    )..show();
  }
}
