import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduation_project/pages/main_screens/chats_screen.dart';
import 'package:graduation_project/widgets/message_widget.dart';
import 'package:page_transition/page_transition.dart';

List<MessageWidget> messagesList = [
  MessageWidget(
    sender: 'Username Here',
    content: 'Message Here',
    date: '2:26:25 AM',
    isMe: false,
  ),
  MessageWidget(
    sender: 'Username Here',
    content:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin purus purus, accumsan quis ipsum in, consectetur vulputate nisl. Sed condimentum nec ex in molestie. Nulla facilisi..',
    date: '2:26:25 AM',
    isMe: true,
  ),
  MessageWidget(
    sender: 'Username Here',
    content:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin purus purus, accumsan quis ipsum in, consectetur vulputate nisl. Sed condimentum nec ex in molestie. Nulla facilisi..',
    date: '2:26:25 AM',
    isMe: false,
  ),
  MessageWidget(
    sender: 'Username Here',
    content:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin purus purus, accumsan quis ipsum in, consectetur vulputate nisl. Sed condimentum nec ex in molestie. Nulla facilisi..',
    date: '2:26:25 AM',
    isMe: true,
  ),
  MessageWidget(
    sender: 'Username Here',
    content:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin purus purus, accumsan quis ipsum in, consectetur vulputate nisl. Sed condimentum nec ex in molestie. Nulla facilisi..',
    date: '2:26:25 AM',
    isMe: false,
  ),
  MessageWidget(
    sender: 'Username Here',
    content:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin purus purus, accumsan quis ipsum in, consectetur vulputate nisl. Sed condimentum nec ex in molestie. Nulla facilisi..',
    date: '2:26:25 AM',
    isMe: true,
  ),
  MessageWidget(
    sender: 'Username Here',
    content:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin purus purus, accumsan quis ipsum in, consectetur vulputate nisl. Sed condimentum nec ex in molestie. Nulla facilisi..',
    date: '2:26:25 AM',
    isMe: false,
  ),
];

class InsideChatScreen extends StatefulWidget {
  bool isGroup;
  String chatName;
  InsideChatScreen({this.chatName, this.isGroup = false});
  @override
  InsideChatScreenState createState() => InsideChatScreenState();
}

class InsideChatScreenState extends State<InsideChatScreen> {
  TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      duration: Duration(milliseconds: 600),
                      type: PageTransitionType.fade,
                      child: ChatsListScreen()));
            },
          )
        ],
        backgroundColor: Color(0xFF707070),
        title: Row(
          children: [
            widget.isGroup
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                    ),
                  ),
            Text(widget.chatName),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: ListView(
              children: messagesList,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        // filled: true,
                        fillColor: Colors.white,
                        hintText: 'Send a message..',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        log('sent done');
                        setState(() {
                          if (_messageController.text.isNotEmpty) {
                            messagesList.add(
                              MessageWidget(
                                sender: 'Username Here',
                                content: _messageController.text,
                                date: '2:26:25 AM',
                                isMe: true,
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
