import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allOfCurrentUser_model.dart';
import 'package:graduation_project/models/socket_models.dart/comment_added_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/dislike_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/like_added_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/user_info_socket_model.dart';
import 'package:graduation_project/pages/authentication/signin.dart';
import 'package:graduation_project/pages/main_screens/post_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/bottom_bar.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:graduation_project/widgets/post_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchFor = '';
  int chosenPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ApplicationProvider applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
      applicationProvider.getMyPosts();
      applicationProvider.getAllPosts();
      applicationProvider.getNotification();
      applicationProvider.getAllUsers();
      applicationProvider.getAllMyFriends();
    });
  }

  void connect() {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
    // socket.emit("signin", widget.sourchat.id);
    socket = IO.io("http://192.168.1.9:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((data) {
      print('hello connected? ' + data.toString());
      print("Connected");
      socket.on("commentAddedS", (msg) async {
        log('msg');
        applicationProvider.commentAddedS(data: msg);
      });
      socket.on("commentAdded", (msg) async {
        log(Map<String, dynamic>.from(msg).toString());
        applicationProvider.commentAdded(data: msg);
        applicationProvider.gotNotification = true;
        await saveData(key: 'hasNotification', saved: "true");
      });
      socket.on("commentDeletedS", (msg) async {
        log(Map<String, dynamic>.from(msg).toString());
        applicationProvider.commentRemovedS(
            id: msg['commenterId'],
            postId: msg['postId'],
            comment: msg['commentId']);
      });
      socket.on("commentDeleted", (msg) async {
        log(Map<String, dynamic>.from(msg).toString());
        applicationProvider.commentRemoved(
          id: msg['commenterId'],
          postId: msg['postId'],
          comment: msg['commentId'],
        );
      });
      socket.on("likeAdded", (msg) async {
        log(Map<String, dynamic>.from(msg).toString());
        applicationProvider.addedLike(
            likeAddedSocketModel: LikeAddedSocketModel.fromJson(msg));
        applicationProvider.gotNotification = true;
        await saveData(key: 'hasNotification', saved: "true");
      });
      socket.on("likeAddedS", (msg) {
        log(Map<String, dynamic>.from(msg).toString());
        applicationProvider.addedLikeS(
            likeAddedSocketModel: LikeAddedSocketModel.fromJson(msg));
      });
      socket.on("disliked", (msg) {
        log(Map<String, dynamic>.from(msg).toString());
        applicationProvider.removedLike(
            dislikeSocketModel: DislikeSocketModel.fromJson(msg));
      });
      socket.on("dislikedS", (msg) {
        log(Map<String, dynamic>.from(msg).toString());
        applicationProvider.removedLikeS(
            dislikeSocketModel: DislikeSocketModel.fromJson(msg));
      });
      socket.on("onlineFriends", (friends) {
        log('online friends');
        log(friends.toString());
        for (var friend in friends) {
          applicationProvider.allOnline
              .add(UserInfoSocketModel.fromJson(friend));
          final ids = applicationProvider.allOnline.map((e) => e.sId).toSet();
          applicationProvider.allOnline.retainWhere((x) => ids.remove(x.sId));
          log(applicationProvider.allOnline.toString());
        }
      });
      socket.on("friendGotOnline", (friends) {
        log('friend signed in');
        log(friends.toString());
        setState(() {
          applicationProvider.allOnline
              .add(UserInfoSocketModel.fromJson(friends));
          final ids = applicationProvider.allOnline.map((e) => e.sId).toSet();
          applicationProvider.allOnline.retainWhere((x) => ids.remove(x.sId));
        });
        log(applicationProvider.allOnline.toString());
      });
      socket.on("friendGotOffline", (friends) {
        log('friend signed out');
        log(friends.toString());
        setState(() {
          applicationProvider.allOnline.removeWhere((friend) =>
              friend.sId == UserInfoSocketModel.fromJson(friends).sId);
        });

        log(applicationProvider.allOnline.toString());
      });
      socket.emit("createUserRoom", {user.id});
      socket.emit('activeNow', {'id': user.id});
      socket.emit('getOnlineFriends', {user.id});

      print(json.encode(user));
    });
    print(socket.connected);
  }

  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return;
        },
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: ListView(
                  children: [
                    Container(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            searchFor = value;
                            log(searchFor);
                          });
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                          hintText: 'Search for Friends...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          )),
                        ),
                      ),
                    ),
                    _searchController.text.isNotEmpty
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 12, bottom: 8, left: 32, right: 32),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                  child: Container(
                                    width: width / 2.25,
                                    decoration: BoxDecoration(
                                      color: Color(0xff000000),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.00, 3.00),
                                          color: Color(0xff000000)
                                              .withOpacity(0.35),
                                          blurRadius: 6,
                                        ),
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(20.00),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "Return Home",
                                          style: TextStyle(
                                            fontFamily: "GE_SS_TWO",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ...applicationProvider.allUsers
                                  .where((element) =>
                                      element.name.contains(searchFor))
                                  .map((e) => Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: e.image == null
                                                  ? Container()
                                                  : Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                CachedNetworkImageProvider(
                                                                    e.image)),
                                                      ),
                                                    ),
                                            ),
                                            subtitle: applicationProvider
                                                    .allMyFriends
                                                    .any((element) =>
                                                        element.id.sId == e.sId)
                                                ? applicationProvider.allOnline
                                                        .any((element) =>
                                                            element.sId ==
                                                            e.sId)
                                                    ? Text(
                                                        'Online',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                      )
                                                    : Text('Offline')
                                                : Text(''),
                                            trailing: applicationProvider
                                                    .allMyFriends
                                                    .any((element) =>
                                                        element.id.sId == e.sId)
                                                ? Container(
                                                    width: width / 4,
                                                    child: FlatButton(
                                                        color: Colors.black,
                                                        onPressed: () {},
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Chat',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Icon(
                                                                Icons.chat,
                                                                size: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  )
                                                : Container(
                                                    width: width / 4,
                                                    child: FlatButton(
                                                        color: Colors.black,
                                                        onPressed: () {},
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'add',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                            title: Text(
                                              e.name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Divider(),
                                        ],
                                      ))
                                  .toList()
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                top: 12, bottom: 8, left: 50, right: 50),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              onTap: () {
                                applicationProvider.getMyPosts();
                                applicationProvider.getAllPosts();
                                applicationProvider.getNotification();
                                applicationProvider.getAllUsers();
                                applicationProvider.getAllMyFriends();
                              },
                              child: Container(
                                width: width / 2,
                                decoration: BoxDecoration(
                                  color: Color(0xff000000),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0.00, 3.00),
                                      color:
                                          Color(0xff000000).withOpacity(0.35),
                                      blurRadius: 6,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Recent Posts",
                                          style: TextStyle(
                                            fontFamily: "GE_SS_TWO",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    applicationProvider.getLoading()
                        ? Column(
                            children: [
                              ...List.generate(
                                  4,
                                  (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4),
                                        child: SizedBox(
                                          height: 160.0,
                                          child: Shimmer.fromColors(
                                            baseColor:
                                                Colors.black.withOpacity(0.4),
                                            highlightColor:
                                                Colors.black.withOpacity(0.6),
                                            child: Card(
                                              child: ListTile(
                                                dense: true,
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      width: width * 0.4,
                                                      child: Text(
                                                        '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 15.0),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          '',
                                                          // textDirection: ui.TextDirection.ltr,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Arial"),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                ),
                                                subtitle: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      width: width * 0.4,
                                                      child: Text(
                                                        '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                            ],
                          )
                        : Container(),
                    applicationProvider.posts.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child:
                                  Center(child: Text('No Available Posts Yet')),
                            ),
                          )
                        : Column(
                            children: [
                              ...applicationProvider.posts.reversed
                                  .map((e) => Post(
                                        post: e,
                                      ))
                                  .toList()
                            ],
                          ),
                  ],
                ),
              ),
              BottomBar(
                chosenPage: chosenPage,
              )
            ],
          ),
        ),
      ),
    );
  }
}
