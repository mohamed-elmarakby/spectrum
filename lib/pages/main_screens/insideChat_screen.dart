import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/InsideChatResponse_model.dart';
import 'package:graduation_project/pages/groups/groupsList_screen.dart';
import 'package:graduation_project/pages/main_screens/chats_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/message_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

InsideChatScreenState insideChatScreenState;

class InsideChatScreen extends StatefulWidget {
  bool isGroup;
  InsideChatResponseModel insideChatResponseModel;
  InsideChatScreen({this.insideChatResponseModel, this.isGroup = false});
  @override
  InsideChatScreenState createState() {
    insideChatScreenState = InsideChatScreenState();
    return insideChatScreenState;
  }
}

class InsideChatScreenState extends State<InsideChatScreen> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    if (widget.isGroup) {
      socket.on('newGbMsg', (data) {
        Messages msgRecieved = Messages.fromJson(data);
        if (insideChatScreenState != null && insideChatScreenState.mounted) {
          setState(() {
            widget.insideChatResponseModel.messages.add(msgRecieved);
            final ids = widget.insideChatResponseModel.messages
                .map((e) => e.sId)
                .toSet();
            widget.insideChatResponseModel.messages
                .retainWhere((x) => ids.remove(x.sId));
          });
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
      });
    } else {
      socket.on("msgRecieved", (msgRecieved) {
        log('inside chat msgRecieved: ');
        log(msgRecieved.toString());
        Messages messages = Messages.fromJson(msgRecieved);
        log('messages: ' + json.encode(messages));
        if (insideChatScreenState != null && insideChatScreenState.mounted) {
          setState(() {
            widget.insideChatResponseModel.messages.add(messages);
            final ids = widget.insideChatResponseModel.messages
                .map((e) => e.sId)
                .toSet();
            widget.insideChatResponseModel.messages
                .retainWhere((x) => ids.remove(x.sId));
          });
          setState(() {
            applicationProvider.gotChatMsg = false;
          });
          saveData(key: 'hasChatMsg', saved: "false");
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
      });
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              if (widget.isGroup) {
                Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        type: PageTransitionType.fade,
                        child: GroupsListScreen()));
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        type: PageTransitionType.fade,
                        child: ChatsListScreen()));
              }
            },
            child: Icon(Icons.arrow_back)),
        backgroundColor: Color(0xFF707070),
        title: Row(
          children: [
            // widget.isGroup
            //     ? Container()
            //     : Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: CircleAvatar(
            //           backgroundColor: Colors.blue,
            //         ),
            //       ),
            Text(
              widget.insideChatResponseModel.chatInfo.users
                  .firstWhere((element) => element.sId != user.id)
                  .name
                  .toString(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            return Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 600),
                    type: PageTransitionType.fade,
                    child: ChatsListScreen()));
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 45.0),
                child: ListView(
                  controller: _scrollController,
                  children: widget.insideChatResponseModel.messages
                      .map((e) => MessageWidget(
                            image: e.senderId.image,
                            content: e.content.toString(),
                            sender: e.senderId.name.toString(),
                            isMe: e.senderId.sId == user.id,
                          ))
                      .toList(),
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
                              if (!widget.isGroup) {
                                if (_messageController.text.trim().isNotEmpty) {
                                  socket.emit('newMsg', {
                                    'chatId': widget
                                        .insideChatResponseModel.chatInfo.sId,
                                    'senderId': user.id,
                                    'recieverId': widget
                                        .insideChatResponseModel.chatInfo.users
                                        .firstWhere(
                                            (element) => element.sId != user.id)
                                        .sId,
                                    'content': _messageController.text.trim(),
                                  });
                                  socket.on('msgSent', (data) {
                                    Messages msgRecieved =
                                        Messages.fromJson(data);
                                    if (insideChatScreenState != null &&
                                        insideChatScreenState.mounted) {
                                      setState(() {
                                        widget.insideChatResponseModel.messages
                                            .add(msgRecieved);
                                        final ids = widget
                                            .insideChatResponseModel.messages
                                            .map((e) => e.sId)
                                            .toSet();
                                        widget.insideChatResponseModel.messages
                                            .retainWhere(
                                                (x) => ids.remove(x.sId));
                                      });
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                      });
                                    }
                                  });

                                  _messageController.clear();
                                }
                              } else {
                                if (_messageController.text.trim().isNotEmpty) {
                                  socket.emit('newGroupMsg', {
                                    'chatId': widget
                                        .insideChatResponseModel.chatInfo.sId,
                                    'senderId': user.id,
                                    'content': _messageController.text.trim(),
                                  });
                                  socket.on('newGbMsg', (data) {
                                    Messages msgRecieved =
                                        Messages.fromJson(data);
                                    if (insideChatScreenState != null &&
                                        insideChatScreenState.mounted) {
                                      setState(() {
                                        widget.insideChatResponseModel.messages
                                            .add(msgRecieved);
                                        final ids = widget
                                            .insideChatResponseModel.messages
                                            .map((e) => e.sId)
                                            .toSet();
                                        widget.insideChatResponseModel.messages
                                            .retainWhere(
                                                (x) => ids.remove(x.sId));
                                      });
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                      });
                                    }
                                  });

                                  _messageController.clear();
                                }
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
        ),
      ),
    ));
  }
}
