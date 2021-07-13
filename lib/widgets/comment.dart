import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allOfCurrentUser_model.dart';
import 'package:page_transition/page_transition.dart';
import '../pages/profile/profile_screen.dart';

class CommentWidget extends StatefulWidget {
  Posts post;
  Comments comment;
  CommentWidget({this.post, this.comment});
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 600),
                    type: PageTransitionType.fade,
                    child: ProfilePageScreen(
                      isMine: widget.comment.commenterId.sId == user.id,
                      userId: widget.comment.commenterId.sId,
                    )));
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: CachedNetworkImage(
                imageUrl: widget.comment.commenterId.image,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              widget.comment.commenterId.name,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            subtitle: Text(
              widget.comment.text,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
