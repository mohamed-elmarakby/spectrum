import 'package:flutter/material.dart';
import 'package:graduation_project/pages/main_screens/insideChat_screen.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:graduation_project/widgets/group_widget.dart';
import 'package:page_transition/page_transition.dart';

List<GroupWidget> groupsList = [
  GroupWidget(
    groupImage: 'Group Image',
    groupName: 'Group Name',
  ),
  GroupWidget(
    groupImage: 'Group Image',
    groupName: 'Group Name',
  ),
  GroupWidget(
    groupImage: 'Group Image',
    groupName: 'Group Name',
  ),
  GroupWidget(
    groupImage: 'Group Image',
    groupName: 'Group Name',
  ),
  GroupWidget(
    groupImage: 'Group Image',
    groupName: 'Group Name',
  ),
  GroupWidget(
    groupImage: 'Group Image',
    groupName: 'Group Name',
  ),
  GroupWidget(
    groupImage: 'Group Image',
    groupName: 'Group Name',
  ),
  GroupWidget(
    groupImage: 'Group Image',
    groupName: 'Group Name',
  ),
];

class GroupsListScreen extends StatefulWidget {
  @override
  _GroupsListScreenState createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF707070),
        title: Text('Groups'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: groupsList,
        ),
      ),
    ));
  }
}
