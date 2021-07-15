import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allOfCurrentUser_model.dart';
import 'package:graduation_project/models/socket_models.dart/comment_added_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/user_info_socket_model.dart';
import 'package:graduation_project/pages/main_screens/home_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/widgets/comment.dart';
import 'package:graduation_project/widgets/my_post_widget.dart';
import 'package:graduation_project/widgets/post_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

_MyPostScreenState myPostScreenState;

class MyPostScreen extends StatefulWidget {
  Posts post;
  MyPostScreen({this.post});
  @override
  _MyPostScreenState createState() {
    myPostScreenState = _MyPostScreenState();
    return myPostScreenState;
  }
}

class _MyPostScreenState extends State<MyPostScreen> {
  List<Comments> comments = [];
  TextEditingController _editCommentController = TextEditingController();
  TextEditingController _editPostController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    _showDialog({bool post = false, String commentId}) async {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Colors.white,
          builder: (BuildContext bc) {
            return Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post ? "Edit Post" : 'Edit Comment',
                      style: TextStyle(fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller:
                            post ? _editPostController : _editCommentController,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.done),
                                onPressed: () async {
                                  if (!post) {
                                    if (_editCommentController.text
                                        .trim()
                                        .isNotEmpty) {
                                      log(_editCommentController.text);
                                      log(widget.post.sId);
                                      log(commentId);
                                      await HomeServices()
                                          .editCommentApi(
                                              commentId: commentId,
                                              postId: widget.post.sId,
                                              newComment:
                                                  _editCommentController.text)
                                          .then((value) {
                                        setState(() {
                                          widget.post.comments
                                                  .firstWhere((element) =>
                                                      element.sId == commentId)
                                                  .text =
                                              _editCommentController.text;
                                          _editCommentController.clear();
                                        });
                                        Navigator.pop(context);
                                      });
                                    }
                                  } else {
                                    log(_editPostController.text
                                        .trim()
                                        .isNotEmpty
                                        .toString());
                                    log(widget.post.sId);
                                    log(_editPostController.text);
                                    if (_editPostController.text
                                        .trim()
                                        .isNotEmpty) {
                                      log(_editPostController.text);
                                      log(widget.post.sId);
                                      await HomeServices()
                                          .editPostApi(
                                              postId: widget.post.sId,
                                              newText: _editPostController.text)
                                          .then((value) {
                                        setState(() {
                                          widget.post.text =
                                              _editPostController.text;
                                          _editPostController.clear();
                                        });
                                        Navigator.pop(context);
                                      });
                                    }
                                  }
                                }),
                          ),
                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                          hintText: post
                              ? 'write new post content...'
                              : 'Write a Comment...',
                          hintMaxLines: 4,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF707070),
        title: Text(applicationProvider
            .myPosts[applicationProvider.myPosts
                .indexWhere((element) => element.sId == widget.post.sId)]
            .authorId
            .name
            .toString()),
      ),
      body: ListView(
        children: [
          widget.post.authorId.sId == user.id
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            _showDialog(post: true);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Edit Post',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.edit,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            await HomeServices()
                                .deletePost(postId: widget.post.sId)
                                .then((value) {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 600),
                                      type: PageTransitionType.fade,
                                      child: HomeScreen()));
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Delete Post',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.delete,
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
                  ],
                )
              : Container(),
          MyPostWidget(
            insidePost: true,
            post: applicationProvider.myPosts[applicationProvider.myPosts
                .indexWhere((element) => element.sId == widget.post.sId)],
          ),
          applicationProvider
                  .myPosts[applicationProvider.myPosts
                      .indexWhere((element) => element.sId == widget.post.sId)]
                  .comments
                  .isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(21),
                  child: Center(
                    child: Text(
                      "No Comments Yet",
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 18,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0x5D707070),
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Other Comments",
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 18,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          ...applicationProvider
                              .myPosts[applicationProvider.myPosts.indexWhere(
                                  (element) => element.sId == widget.post.sId)]
                              .comments
                              .reversed
                              .map((e) => Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: CommentWidget(
                                              post: applicationProvider.myPosts[
                                                  applicationProvider.myPosts
                                                      .indexWhere((element) =>
                                                          element.sId ==
                                                          widget.post.sId)],
                                              comment: e,
                                            ),
                                          ),
                                          e.commenterId.sId == user.id
                                              ? Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            _showDialog(
                                                                commentId:
                                                                    e.sId);
                                                          },
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            socket.emit(
                                                                'deleteComment',
                                                                {
                                                                  "commenterId":
                                                                      user.id,
                                                                  "postOwner":
                                                                      widget
                                                                          .post
                                                                          .authorId
                                                                          .sId,
                                                                  "commentId":
                                                                      e.sId,
                                                                  "postId": applicationProvider
                                                                      .myPosts[applicationProvider.myPosts.indexWhere((element) =>
                                                                          element
                                                                              .sId ==
                                                                          widget
                                                                              .post
                                                                              .sId)]
                                                                      .sId,
                                                                });
                                                          },
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .trash,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                              : Container()
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Divider(),
                                      ),
                                    ],
                                  ))
                              .toList()
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    ));
  }
}
