import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/models/allGroups_model.dart';
import 'package:graduation_project/pages/main_screens/insideChat_screen.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:page_transition/page_transition.dart';

class GroupWidget extends StatefulWidget {
  Groups groups;
  GroupWidget({this.groups});
  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF707070).withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(21),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(
                  child: FaIcon(
                FontAwesomeIcons.users,
                color: Colors.black,
              )),
            ),
            title: Text(widget.groups.name.toString()),
            trailing: GestureDetector(
              onTap: () async {
                await HomeServices()
                    .getChatMessages(chatId: widget.groups.groupId)
                    .then((value) {
                  log('enter group value: ${json.encode(value)}');
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          type: PageTransitionType.fade,
                          child: InsideChatScreen(
                            insideChatResponseModel: value,
                            isGroup: true,
                          )));
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF4F62C4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
                  child: Text(
                    'Enter',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
