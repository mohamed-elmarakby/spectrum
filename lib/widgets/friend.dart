import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allMyFriends_model.dart';
import 'package:graduation_project/pages/main_screens/friendsList_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FriendWidget extends StatefulWidget {
  MyFriends friend;
  bool isChatPage;
  bool isOnline;
  bool isRequest;
  FriendWidget({
    this.friend,
    this.isRequest = false,
    this.isChatPage = false,
    this.isOnline = false,
  });
  @override
  _FriendWidgetState createState() => _FriendWidgetState();
}

class _FriendWidgetState extends State<FriendWidget> {
  bool accepting = false;
  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: CachedNetworkImageProvider(widget.friend.id.image),
          ),
          title: Text(
            widget.friend.id.name,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          trailing: widget.isRequest
              ? Text('')
              : widget.isOnline
                  ? Text(
                      'Online',
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    )
                  : Text('Offline'),
          subtitle: widget.isRequest
              ? Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              accepting = true;
                            });
                            log(widget.friend.id.sId.toString());
                            log(user.id.toString());
                            socket.emit("confirmRequest", {
                              "sender": {"_id": widget.friend.id.sId},
                              "reciever": {"_id": user.id}
                            });
                            Future.delayed(Duration(milliseconds: 500),
                                () async {
                              await applicationProvider.getAllPosts();
                              await applicationProvider
                                  .getAllMyFriends()
                                  .then((value) {});
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF0E5FDA),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: accepting
                                      ? SpinKitWave(
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Accept',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Icon(
                                                Icons.person_add,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            log(widget.friend.id.sId.toString());
                            log(user.id.toString());
                            socket.emit("rejectRequest", {
                              "sender": {"_id": widget.friend.id.sId},
                              "reciever": {"_id": user.id}
                            });

                            Future.delayed(Duration(milliseconds: 500),
                                () async {
                              await applicationProvider.getAllPosts();
                              await applicationProvider
                                  .getAllMyFriends()
                                  .then((value) {});
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Reject',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.person_remove,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
        Divider(),
      ],
    );
  }
}
