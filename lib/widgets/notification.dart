import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/models/socket_models.dart/comment_added_socket_model.dart';

class NotificationWidget extends StatefulWidget {
  NotificationModel notification;
  NotificationWidget({this.notification});
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.userCircle,
              color: Colors.grey,
            ),
          ),
          title: Text(
            widget.notification.notification,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          subtitle: Text(
            dateFormat
                .format(DateTime.parse(widget.notification.date))
                .toString(),
            style:
                TextStyle(color: Colors.black.withOpacity(0.41), fontSize: 10),
          ),
          trailing: widget.notification.likeId == null
              ? Icon(
                  Icons.comment_outlined,
                  color: Colors.green,
                )
              : Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.blue,
                ),
        ),
        Divider(),
      ],
    );
  }
}
