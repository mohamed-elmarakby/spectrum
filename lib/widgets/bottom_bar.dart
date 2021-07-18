import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/pages/main_screens/chats_screen.dart';
import 'package:graduation_project/pages/main_screens/friendsList_screen.dart';
import 'package:graduation_project/pages/groups/groupsList_screen.dart';
import 'package:graduation_project/pages/main_screens/notification_screen.dart';
import 'package:graduation_project/pages/profile/profile_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  int chosenPage;
  BottomBar({this.chosenPage = 0});
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ApplicationProvider applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
      applicationProvider.getRequest();
      applicationProvider.getNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xFFD4DDE8)),
          color: Color(0xFFF8F9FC),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  setState(() {
                    widget.chosenPage = 0;
                  });
                  applicationProvider.gotNotification = false;
                  await saveData(key: 'hasNotification', saved: 'false');
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          type: PageTransitionType.fade,
                          child: NotificationScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.solidBell,
                      color: applicationProvider.gotNotification == null ||
                              applicationProvider.gotNotification == false
                          ? Colors.black
                          : Colors.red,
                    ),
                    Text('Notification',
                        style: TextStyle(
                          color: applicationProvider.gotNotification == null ||
                                  applicationProvider.gotNotification == false
                              ? Colors.black
                              : Colors.red,
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  log('message');
                  setState(() {
                    widget.chosenPage = 1;
                  });
                  setState(() {
                    applicationProvider.gotChatMsg = false;
                  });
                  saveData(key: 'hasChatMsg', saved: "false");
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          type: PageTransitionType.fade,
                          child: ChatsListScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.facebookMessenger,
                      color: applicationProvider.gotChatMsg == null ||
                              applicationProvider.gotChatMsg == false
                          ? Colors.black
                          : Colors.red,
                    ),
                    Text('Chats', style: TextStyle()),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    widget.chosenPage = 2;
                  });
                  applicationProvider.gotFriendRequest = false;
                  await saveData(key: 'hasFriendRequest', saved: 'false');
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          type: PageTransitionType.fade,
                          child: FriendsListScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.userFriends,
                      color: applicationProvider.gotFriendRequest == null ||
                              applicationProvider.gotFriendRequest == false
                          ? Colors.black
                          : Colors.red,
                    ),
                    Text('Friends List',
                        style: TextStyle(
                          color: applicationProvider.gotFriendRequest == null ||
                                  applicationProvider.gotFriendRequest == false
                              ? Colors.black
                              : Colors.red,
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    widget.chosenPage = 3;
                  });
                  applicationProvider.gotGroupMsg = false;
                  await saveData(key: 'hasGroupMsg', saved: 'false');
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          type: PageTransitionType.fade,
                          child: GroupsListScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.users,
                      color: applicationProvider.gotGroupMsg == null ||
                              applicationProvider.gotGroupMsg == false
                          ? Colors.black
                          : Colors.red,
                    ),
                    Text('Groups', style: TextStyle()),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.chosenPage = 4;
                  });
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          type: PageTransitionType.fade,
                          child: ProfilePageScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.userCircle,
                    ),
                    Text('Profile', style: TextStyle()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
