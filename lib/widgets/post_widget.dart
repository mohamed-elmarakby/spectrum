import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allOfCurrentUser_model.dart';
import 'package:graduation_project/models/socket_models.dart/comment_added_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/user_info_socket_model.dart';
import 'package:graduation_project/pages/main_screens/post_screen.dart';
import 'package:graduation_project/pages/profile/profile_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/widgets/full_photo.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Post extends StatefulWidget {
  Posts post;
  bool insidePost;
  Post({
    this.post,
    this.insidePost = false,
  });
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  TextEditingController _postCommentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0x5D707070),
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  widget.insidePost
                      ? Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 600),
                              type: PageTransitionType.fade,
                              child: ProfilePageScreen(
                                isMine: widget.post.authorId.sId == user.id,
                                userId: widget.post.authorId.sId,
                              )))
                      : Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 600),
                              type: PageTransitionType.fade,
                              child: PostScreen(
                                post: applicationProvider.posts[
                                    applicationProvider.posts.indexWhere(
                                        (element) =>
                                            element.sId == widget.post.sId)],
                              )));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: applicationProvider
                                .posts[applicationProvider.posts.indexWhere(
                                    (element) =>
                                        element.sId == widget.post.sId)]
                                .authorId
                                .image ==
                            null
                        ? Container()
                        : Container(
                            height: MediaQuery.of(context).size.width / 2,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      applicationProvider
                                          .posts[applicationProvider.posts
                                              .indexWhere((element) =>
                                                  element.sId ==
                                                  widget.post.sId)]
                                          .authorId
                                          .image)),
                            ),
                          ),
                  ),
                  title: Text(
                    applicationProvider
                        .posts[applicationProvider.posts.indexWhere(
                            (element) => element.sId == widget.post.sId)]
                        .authorId
                        .name,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  subtitle: Text(
                    dateFormat
                        .format(DateTime.parse(applicationProvider
                            .posts[applicationProvider.posts.indexWhere(
                                (element) => element.sId == widget.post.sId)]
                            .date))
                        .toString(),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.41), fontSize: 12),
                  ),
                ),
              ),
              Wrap(
                children: [
                  Text(applicationProvider
                      .posts[applicationProvider.posts.indexWhere(
                          (element) => element.sId == widget.post.sId)]
                      .text)
                ],
              ),
              applicationProvider
                          .posts[applicationProvider.posts.indexWhere(
                              (element) => element.sId == widget.post.sId)]
                          .image ==
                      null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPhoto(
                                      url: applicationProvider
                                          .posts[applicationProvider.posts
                                              .indexWhere((element) =>
                                                  element.sId ==
                                                  widget.post.sId)]
                                          .image)));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 2,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    applicationProvider
                                        .posts[applicationProvider.posts
                                            .indexWhere((element) =>
                                                element.sId == widget.post.sId)]
                                        .image)),
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Row(
                  children: [
                    Icon(Icons.thumb_up_outlined),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(applicationProvider
                          .posts[applicationProvider.posts.indexWhere(
                              (element) => element.sId == widget.post.sId)]
                          .likes
                          .length
                          .toString()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Divider(),
              ),
              GestureDetector(
                onTap: () {
                  if (applicationProvider
                      .posts[applicationProvider.posts.indexWhere(
                          (element) => element.sId == widget.post.sId)]
                      .likes
                      .any((element) => element.id.sId == user.id)) {
                    socket.emit('dislike', {
                      "adder": user.id,
                      "postOwner": widget.post.authorId.sId,
                      "likeId": applicationProvider
                          .posts[applicationProvider.posts.indexWhere(
                              (element) => element.sId == widget.post.sId)]
                          .likes[applicationProvider
                              .posts[applicationProvider.posts.indexWhere(
                                  (element) => element.sId == widget.post.sId)]
                              .likes
                              .indexWhere(
                                  (element) => element.id.sId == user.id)]
                          .sId,
                      "postId": widget.post.sId,
                    });
                  } else {
                    socket.emit('addLike', {
                      "adder": user.id,
                      "postOwner": applicationProvider
                          .posts[applicationProvider.posts.indexWhere(
                              (element) =>
                                  element.authorId.sId ==
                                  widget.post.authorId.sId)]
                          .authorId
                          .sId,
                      "likeId": null,
                      "postId": applicationProvider
                          .posts[applicationProvider.posts.indexWhere(
                              (element) => element.sId == widget.post.sId)]
                          .sId,
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      color: applicationProvider
                              .posts[applicationProvider.posts.indexWhere(
                                  (element) => element.sId == widget.post.sId)]
                              .likes
                              .any((element) => element.id.sId == user.id)
                          ? Colors.blue
                          : Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Like',
                        style: TextStyle(
                            color: applicationProvider
                                    .posts[applicationProvider.posts.indexWhere(
                                        (element) =>
                                            element.sId == widget.post.sId)]
                                    .likes
                                    .any((element) => element.id.sId == user.id)
                                ? Colors.blue
                                : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TextField(
                  controller: _postCommentController,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        if (_postCommentController.text.trim().isNotEmpty) {
                          socket.emit('addComment', {
                            "userId": user.id,
                            "postOwner": applicationProvider
                                .posts[applicationProvider.posts.indexWhere(
                                    (element) =>
                                        element.sId == widget.post.sId)]
                                .authorId
                                .sId,
                            "comment": _postCommentController.text,
                            "postId": applicationProvider
                                .posts[applicationProvider.posts.indexWhere(
                                    (element) =>
                                        element.sId == widget.post.sId)]
                                .sId,
                          });
                          _postCommentController.clear();
                          socket.onConnect((data) {
                            print('hello connected? ' + data.toString());
                            print("Connected");
                            socket.on("commentAddedS", (msg) async {
                              log(msg.toString());
                              log(msg.runtimeType.toString());
                              CommentAddedSocketModel commentAddedSocketModel =
                                  CommentAddedSocketModel.fromJson(msg);
                              Dio dio = Dio();
                              await dio
                                  .get(
                                Constants().apiUrl + 'info',
                                options: Options(
                                  headers: {
                                    'id': commentAddedSocketModel.userId
                                  },
                                ),
                              )
                                  .then((value) {
                                setState(() {
                                  postScreenState.setState(() {
                                    UserInfoSocketModel userInfoSocketModel =
                                        UserInfoSocketModel();
                                    userInfoSocketModel =
                                        UserInfoSocketModel.fromJson(
                                            value.data);
                                    applicationProvider
                                        .posts[applicationProvider.posts
                                            .indexWhere((element) =>
                                                element.sId == widget.post.sId)]
                                        .comments
                                        .add(Comments(
                                      commenterId: AuthorId(
                                        name: userInfoSocketModel.name,
                                        sId: userInfoSocketModel.sId,
                                        image: userInfoSocketModel.image,
                                      ),
                                      isEdited: commentAddedSocketModel
                                          .comment.isEdited,
                                      sId: commentAddedSocketModel.comment.sId,
                                      text:
                                          commentAddedSocketModel.comment.text,
                                    ));
                                  });
                                });
                              });

                              log(commentAddedSocketModel.comment.text);
                              // setMessage("destination", msg["message"]);
                              //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                              //       duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                            });
                            socket.on("commentAdded", (msg) async {
                              log(msg.runtimeType.toString());
                              log(msg.toString());
                              CommentAddedSocketModel commentAddedSocketModel =
                                  CommentAddedSocketModel.fromJson(msg);
                              Dio dio = Dio();
                              await dio
                                  .get(
                                Constants().apiUrl + 'info',
                                options: Options(
                                  headers: {
                                    'id': commentAddedSocketModel.userId
                                  },
                                ),
                              )
                                  .then((value) {
                                setState(() {
                                  postScreenState.setState(() {
                                    UserInfoSocketModel userInfoSocketModel =
                                        UserInfoSocketModel();
                                    userInfoSocketModel =
                                        UserInfoSocketModel.fromJson(
                                            value.data);
                                    applicationProvider
                                        .posts[applicationProvider.posts
                                            .indexWhere((element) =>
                                                element.sId == widget.post.sId)]
                                        .comments
                                        .add(Comments(
                                      commenterId: AuthorId(
                                        name: userInfoSocketModel.name,
                                        sId: userInfoSocketModel.sId,
                                        image: userInfoSocketModel.image,
                                      ),
                                      isEdited: commentAddedSocketModel
                                          .comment.isEdited,
                                      sId: commentAddedSocketModel.comment.sId,
                                      text:
                                          commentAddedSocketModel.comment.text,
                                    ));
                                  });
                                });
                              });
                              // setMessage("destination", msg["message"]);
                              //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                              //       duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                            });
                            socket.on("likeAdded", (msg) {
                              print(msg);
                              // setMessage("destination", msg["message"]);
                              //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                              //       duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                            });
                            socket.on("likeAddedS", (msg) {
                              print(msg);
                              // setMessage("destination", msg["message"]);
                              //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                              //       duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                            });

                            socket.emit("createUserRoom", {user.id});
                            socket.emit('activeNow', {'id': user.id});
                            print(json.encode(user));
                          });
                        }
                        setState(() {
                          applicationProvider.posts[applicationProvider.posts
                              .indexWhere((element) =>
                                  element.sId ==
                                  widget.post.sId)] = applicationProvider.posts[
                              applicationProvider.posts.indexWhere(
                                  (element) => element.sId == widget.post.sId)];
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.only(left: 20, right: 20),
                    hintText: 'Write a Comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
