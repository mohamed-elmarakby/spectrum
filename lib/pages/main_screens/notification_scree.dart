import 'package:flutter/material.dart';
import 'package:graduation_project/models/socket_models.dart/comment_added_socket_model.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/comment.dart';
import 'package:graduation_project/widgets/notification.dart';
import 'package:graduation_project/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ApplicationProvider applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
      applicationProvider.getAllPosts();
      applicationProvider.getMyPosts();
      applicationProvider.getNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    applicationProvider.gotNotification = false;
    saveData(saved: 'false', key: 'hasNotification');
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF707070),
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: applicationProvider.notificationsList.isEmpty
            ? Center(
                child: Text(
                  'No Notifications Yet',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView(
                children: applicationProvider.notificationsList
                    .map((e) => NotificationWidget(
                          notification: e,
                        ))
                    .toList(),
              ),
      ),
    ));
  }
}
