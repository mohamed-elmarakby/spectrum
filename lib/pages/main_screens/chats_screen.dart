import 'package:flutter/material.dart';
import 'package:graduation_project/pages/main_screens/insideChat_screen.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:page_transition/page_transition.dart';

List chatsList = [
  {
    'username': 'Username Here',
    'lastMessage': 'Last Message is here',
    'isChatPage': true,
    'date': '2:26:25 AM',
  },
  {
    'username': 'Username Here',
    'lastMessage': 'Last Message is here',
    'isChatPage': true,
    'date': '2:26:25 AM',
  },
  {
    'username': 'Username Here',
    'lastMessage': 'Last Message is here',
    'isChatPage': true,
    'date': '2:26:25 AM',
  },
  {
    'username': 'Username Here',
    'lastMessage': 'Last Message is here',
    'isChatPage': true,
    'date': '2:26:25 AM',
  },
  {
    'username': 'Username Here',
    'lastMessage': 'Last Message is here',
    'isChatPage': true,
    'date': '2:26:25 AM',
  },
];

class ChatsListScreen extends StatefulWidget {
  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF707070),
        title: Text('Chats List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: chatsList
              .map((e) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 600),
                              type: PageTransitionType.fade,
                              child: InsideChatScreen(
                                chatName: e['username'],
                                isGroup: false,
                              )));
                    },
                    // child: FriendWidget(
                    //   date: e['date'],
                    //   userImage: e['userImage'],
                    //   username: e['username'],
                    //   lastMessage: e['lastMessage'],
                    //   isOnline: e['isOnline'],
                    //   isChatPage: e['isChatPage'],
                    // ),
                  ))
              .toList(),
        ),
      ),
    ));
  }
}
