import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allnotifications_model.dart';
import 'package:graduation_project/models/socket_models.dart/comment_added_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/like_added_socket_model.dart';
import 'package:graduation_project/pages/main_screens/my_post_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/comment.dart';
import 'package:graduation_project/widgets/loading_shimmer.dart';
import 'package:graduation_project/widgets/notification.dart';
import 'package:graduation_project/widgets/post_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool loading = false;
  List<AllNotificationsModel> allNotificationsModel = [];
  Future getNotifications() async {
    log('getting chats...');
    log('${user.id}');
    await HomeServices().getMyNotifications(userId: user.id).then((value) {
      setState(() {
        allNotificationsModel.addAll(value);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      loading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ApplicationProvider applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
      getNotifications().then((value) {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    applicationProvider.gotNotification = false;
    // socket.on("commentAdded", (msg) async {
    //   log(Map<String, dynamic>.from(msg).toString());
    //   applicationProvider.commentAdded(data: msg);
    //   applicationProvider.gotNotification = true;
    //   await saveData(key: 'hasNotification', saved: "true");
    // });
    // socket.on("likeAdded", (msg) async {
    //   log(Map<String, dynamic>.from(msg).toString());
    //   applicationProvider.addedLike(
    //       likeAddedSocketModel: LikeAddedSocketModel.fromJson(msg));
    //   applicationProvider.gotNotification = true;
    //   await saveData(key: 'hasNotification', saved: "true");
    // });
    saveData(saved: 'false', key: 'hasNotification');
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF707070),
        title: Text('Notifications'),
      ),
      body: loading
          ? LoadingShimmer(width: width)
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: allNotificationsModel.isEmpty
                  ? Center(
                      child: Text(
                        'No Notifications Yet',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView(
                      children: allNotificationsModel
                          .map((e) => GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  await HomeServices()
                                      .goToPostApi(postId: e.postId)
                                      .then((value) {
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            duration:
                                                Duration(milliseconds: 600),
                                            type: PageTransitionType.fade,
                                            child: MyPostScreen(
                                              post: value,
                                            )));
                                  });
                                },
                                child: NotificationWidget(
                                  notification: NotificationModel(
                                    commentId: e.commentId,
                                    date: e.date,
                                    isViewed: e.isViewed,
                                    notification: e.notification,
                                    postId: e.postId,
                                    sId: e.sId,
                                    likeId: e.likeId,
                                  ),
                                ),
                              ))
                          .toList()
                          .reversed
                          .toList(),
                    ),
            ),
    ));
  }
}
