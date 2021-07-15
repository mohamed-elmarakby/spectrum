import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduation_project/models/allMyFriends_model.dart';
import 'package:graduation_project/models/socket_models.dart/user_info_socket_model.dart';
import 'package:graduation_project/pages/profile/profile_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:graduation_project/widgets/loading_shimmer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:graduation_project/main.dart';

_FriendsListScreenState friendsListScreenState;

class FriendsListScreen extends StatefulWidget {
  @override
  _FriendsListScreenState createState() {
    friendsListScreenState = _FriendsListScreenState();
    return friendsListScreenState;
  }
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  bool loading = false;

  Future c() async {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    socket.on("friendGotOnline", (friends) {
      log('friend signed in');
      log(friends.toString());
      if (mounted) {
        setState(() {
          applicationProvider.allOnline
              .add(UserInfoSocketModel.fromJson(friends));
          final ids = applicationProvider.allOnline.map((e) => e.sId).toSet();
          applicationProvider.allOnline.retainWhere((x) => ids.remove(x.sId));
        });
      }
      log(applicationProvider.allOnline.toString());
    });
    socket.on("friendGotOffline", (friends) {
      log('friend signed out');
      log(friends.toString());
      if (mounted) {
        setState(() {
          applicationProvider.allOnline.removeWhere((friend) =>
              friend.sId == UserInfoSocketModel.fromJson(friends).sId);
        });
      }

      log(applicationProvider.allOnline.toString());
    });
    applicationProvider.getAllMyFriends().then((value) async {
      await HomeServices().getFriendRequests(userId: user.id).then((value) {
        ApplicationProvider applicationProvider =
            Provider.of<ApplicationProvider>(context, listen: false);
        setState(() {
          for (var friend in value) {
            applicationProvider.allMyFriends.add(MyFriends(
                sId: friend.sId,
                isRequest: true,
                id: Id(
                  sId: friend.sId,
                  image: friend.image,
                  name: friend.name,
                )));
          }
          final ids =
              applicationProvider.allMyFriends.map((e) => e.sId).toSet();
          applicationProvider.allMyFriends
              .retainWhere((x) => ids.remove(x.sId));
          loading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    setState(() {
      loading = true;
    });
    c();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    print('updated friend list screen');
    for (var friend in applicationProvider.allMyFriends) {
      print(applicationProvider.allOnline
          .any((element) => element.sId == friend.id.sId)
          .toString());
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF707070),
        title: Text('Freinds List'),
      ),
      body: loading
          ? LoadingShimmer(width: width)
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: applicationProvider.allMyFriends.isEmpty
                  ? Center(
                      child: Text('No Friends Yet'),
                    )
                  : ListView(
                      children: applicationProvider.allMyFriends
                          .map((e) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 600),
                                          type: PageTransitionType.fade,
                                          child: ProfilePageScreen(
                                            isMine: e.id.sId == user.id,
                                            chatId: e.chatId,
                                            userId: e.id.sId,
                                            isRequest: e.isRequest == null
                                                ? false
                                                : e.isRequest,
                                          )));
                                },
                                child: FriendWidget(
                                  friend: e,
                                  isRequest:
                                      e.isRequest == null ? false : e.isRequest,
                                  isOnline: applicationProvider.allOnline.any(
                                      (element) => element.sId == e.id.sId),
                                ),
                              ))
                          .toList(),
                    ),
            ),
    ));
  }
}
