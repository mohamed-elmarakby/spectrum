import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduation_project/models/socket_models.dart/user_info_socket_model.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:graduation_project/main.dart';

class FriendsListScreen extends StatefulWidget {
  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  c() {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ApplicationProvider applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
    });
    c();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: applicationProvider.allMyFriends
              .map((e) => FriendWidget(
                    friend: e,
                    isOnline: applicationProvider.allOnline
                        .any((element) => element.sId == e.id.sId),
                  ))
              .toList(),
        ),
      ),
    ));
  }
}
