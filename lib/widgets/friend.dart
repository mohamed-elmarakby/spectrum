import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/models/allMyFriends_model.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:provider/provider.dart';

class FriendWidget extends StatefulWidget {
  MyFriends friend;
  bool isChatPage;
  bool isOnline;
  FriendWidget({
    this.friend,
    this.isChatPage = false,
    this.isOnline = false,
  });
  @override
  _FriendWidgetState createState() => _FriendWidgetState();
}

class _FriendWidgetState extends State<FriendWidget> {
  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    return Column(
      children: [
        ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:
                  CachedNetworkImageProvider(widget.friend.id.image),
            ),
            title: Text(
              widget.friend.id.name,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            trailing: widget.isOnline
                ? Text(
                    'Online',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  )
                : Text('Offline')),
        Divider(),
      ],
    );
  }
}
