import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/InsideChatResponse_model.dart';
import 'package:graduation_project/models/allOfCurrentUser_model.dart';
import 'package:graduation_project/models/socket_models.dart/comment_added_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/dislike_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/like_added_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/received_message_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/recieved_friend_request_socket_model.dart';
import 'package:graduation_project/models/socket_models.dart/user_info_socket_model.dart';
import 'package:graduation_project/pages/authentication/signin.dart';
import 'package:graduation_project/pages/main_screens/post_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/services/push_notifications.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/alrert_manger.dart';
import 'package:graduation_project/widgets/bottom_bar.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:graduation_project/widgets/loading_shimmer.dart';
import 'package:graduation_project/widgets/post_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';
import '../../pages/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchFor = '';
  int chosenPage = 0;
  bool loading = false;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');
    //check here notification sound of ios should be here
    var iOSChannelSpecifics = IOSNotificationDetails(
        // sound: 'notification.aiff',
        // presentSound: true,
        );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    print('body: $body');
    print('title: $title');
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: '');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('mipmap/ic_notification');
    var initializationSettingsIOS = new IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: onSelectNotification,
    );
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print('https://humhumapp.com/client_notification.wav');
        // AudioPlayer audioPlayer = AudioPlayer();
        // await audioPlayer.play(
        //   'https://humhumapp.com/client_notification.wav',
        //   isLocal: false,
        //   respectSilence: true,
        // );
        // print(message);
        // if (await Vibration.hasVibrator()) {
        //   Vibration.vibrate();
        // }

        showNotification(
            message['notification']['title'], message['notification']['body']);
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }
        print("onLaunch: $message");
        // Navigator.pushNamed(context, '/notify');
      },
      onBackgroundMessage: backgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print(message);
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }
        print("onResume: $message");
      },
    );
    connect();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ApplicationProvider applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
      try {
        applicationProvider.getMyPosts().catchError((onError) {
          log(onError.toString());
          setState(() {
            loading = false;
          });
        });
        applicationProvider.getAllPosts().catchError((onError) {
          log(onError.toString());
          setState(() {
            loading = false;
          });
        });

        applicationProvider.getNotification().catchError((onError) {
          log(onError.toString());
          setState(() {
            loading = false;
          });
        });
        applicationProvider.getRequest().catchError((onError) {
          log(onError.toString());
          setState(() {
            loading = false;
          });
        });
        applicationProvider.getChatMsg().catchError((onError) {
          log(onError.toString());
          setState(() {
            loading = false;
          });
        });
        applicationProvider.getGroupMsg().catchError((onError) {
          log(onError.toString());
          setState(() {
            loading = false;
          });
        });
        applicationProvider.getAllUsers().catchError((onError) {
          log(onError.toString());
          setState(() {
            loading = false;
          });
        });
        applicationProvider.getAllMyFriends().then((value) {
          setState(() {
            loading = false;
          });
        });
      } catch (e) {
        log(e);
        setState(() {
          loading = false;
        });
        AlertsManager().showError(
            context: context,
            title: 'Ops..',
            body: 'Something Went Wrong',
            description: 'Something Went Wrong');
        Navigator.pushReplacement(
            context,
            PageTransition(
                duration: Duration(milliseconds: 600),
                type: PageTransitionType.fade,
                child: HomeScreen()));
      }
    });
  }

  void connect() {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    socket = IO.io("http://192.168.1.7:3000", <String, dynamic>{
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
            postOwner: msg['postOwner'],
            comment: msg['commentId']);
      });
      socket.on("commentDeleted", (msg) async {
        log(Map<String, dynamic>.from(msg).toString());
        applicationProvider.commentRemoved(
          id: msg['commenterId'],
          postId: msg['postId'],
          postOwner: msg['postOwner'],
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
      socket.on("msgRecieved", (msgReceived) {
        log('msgReceived: ');
        log(msgReceived.toString());
        log(ReceivedMessageSocketModel.fromJson(msgReceived)
            .content
            .toString());
      });
      socket.on("newGbMsg", (gbMessage) {
        log('newGbMsg: ');
        log(gbMessage.toString());
        log(ReceivedMessageSocketModel.fromJson(gbMessage).type.toString());
        setState(() {
          applicationProvider.gotGroupMsg = true;
        });
        saveData(key: 'hasGroupMsg', saved: "true");
      });
      socket.on("addRequestSent", (addRequestSent) {
        log('addRequestSent: ');
        log(addRequestSent.toString());
      });
      socket.on("requestCanceledSuccessfully", (requestCanceledSuccessfully) {
        log('requestCanceledSuccessfully: ');
        log(requestCanceledSuccessfully.toString());
      });
      socket.on("requestConfirmedS", (requestConfirmedS) {
        log('requestConfirmedS: ');
        log(requestConfirmedS.toString());
      });
      socket.on("requestRejectedS", (requestRejectedS) {
        log('requestRejectedS: ');
        log(requestRejectedS.toString());
      });
      socket.on("addRequestRecieved", (addRequestRecieved) {
        log('addRequestRecieved: ');
        log(addRequestRecieved.toString());
        ReceivedFriendRequestSocketModel receivedFriendRequestSocketModel =
            ReceivedFriendRequestSocketModel.fromJson(addRequestRecieved);
        setState(() {
          applicationProvider.gotFriendRequest = true;
        });
        saveData(key: 'hasFriendRequest', saved: "true");
      });
      socket.on("requestCanceled", (requestCanceled) {
        log('requestCanceled: ');
        log(requestCanceled.toString());
        setState(() {
          applicationProvider.gotFriendRequest = false;
        });
        saveData(key: 'hasFriendRequest', saved: "false");
      });
      socket.on("requestConfirmed", (requestConfirmed) {
        log('requestConfirmed: ');
        log(requestConfirmed.toString());
        setState(() {
          if (profilePageScreenState != null &&
              profilePageScreenState.mounted) {
            profilePageScreenState.setState(() {
              profilePageScreenState.load = true;
            });
            applicationProvider.getAllMyFriends();
            applicationProvider.getAllPosts().then((value) {
              profilePageScreenState.setState(() {
                profilePageScreenState.load = false;
                Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        type: PageTransitionType.fade,
                        child: ProfilePageScreen(
                          isMine: false,
                          userId: requestConfirmed['reciever']['_id'],
                        )));
              });
            });
          } else {
            applicationProvider.getAllMyFriends();
            applicationProvider.getAllPosts().then((value) {});
          }
        });
      });
      socket.on("requestRejected", (requestRejected) {
        log('requestRejected: ');
        log(requestRejected.toString());
      });
      socket.on("removingDone", (removingDone) {
        log('removingDone: ');
        log(removingDone.toString());
      });
      socket.on("msgRecieved", (msgRecieved) {
        log('msgRecieved: ');
        log(msgRecieved.toString());
        Messages messages = Messages.fromJson(msgRecieved);
        log('messages: ' + json.encode(messages));
        setState(() {
          applicationProvider.gotChatMsg = true;
        });
        saveData(key: 'hasChatMsg', saved: "true");
      });
      socket.on("joinedGroupS", (joinedGroupS) {
        log('joinedGroupS: ');
        log(joinedGroupS.toString());
        setState(() {
          applicationProvider.gotGroupMsg = true;
        });
        saveData(key: 'hasGroupMsg', saved: "true");
      });
      socket.on("youRemoved", (youRemoved) {
        log('youRemoved: ');
        log(youRemoved.toString());
        setState(() {
          if (profilePageScreenState != null &&
              profilePageScreenState.mounted) {
            profilePageScreenState.setState(() {
              profilePageScreenState.load = true;
            });
            applicationProvider.getAllMyFriends();
            applicationProvider.getAllPosts().then((value) {
              profilePageScreenState.setState(() {
                profilePageScreenState.load = false;
                Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        type: PageTransitionType.fade,
                        child: ProfilePageScreen(
                          isMine: false,
                          userId: youRemoved['remover'],
                        )));
              });
            });
          } else {
            applicationProvider.getAllMyFriends();
            applicationProvider.getAllPosts().then((value) {});
          }
        });
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
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     await PushNotificationService().callOnFcmApiSendPushNotifications(
          //         userToken: [
          //           'dzf-Xi3ZS5imk7BmBGYw77:APA91bGIkBPDMVTRFC_uD5ffECWtiOXbaALsb4Hre3gW6mcnCamGizpS3y4BEUfQBt82AdYJeGY4XDvNxL5n1cvmYyy0iKaRFKJAi-Jvm2k-M7reQHR8qJJg4JFighd9T5RG11LiarTT'
          //         ],
          //         body: 'sending from mobile to tablet emulators',
          //         title: 'test sending without backend');
          //   },
          // ),
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
                                      element.name.contains(searchFor) &&
                                      element.sId != user.id)
                                  .map((e) => Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      duration: Duration(
                                                          milliseconds: 600),
                                                      type: PageTransitionType
                                                          .fade,
                                                      child: ProfilePageScreen(
                                                        isMine:
                                                            e.sId == user.id,
                                                        userId: e.sId,
                                                      )));
                                            },
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: e.image == null
                                                    ? Container()
                                                    : Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
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
                                                          element.id.sId ==
                                                          e.sId)
                                                  ? applicationProvider
                                                          .allOnline
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
                                              // trailing: applicationProvider
                                              //         .allMyFriends
                                              //         .any((element) =>
                                              //             element.id.sId ==
                                              //             e.sId)
                                              //     ? Container(
                                              //         width: width / 4,
                                              //         child: FlatButton(
                                              //             color: Colors.black,
                                              //             onPressed: () {},
                                              //             child: Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .all(8.0),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .center,
                                              //                 children: [
                                              //                   Text(
                                              //                     'Chat',
                                              //                     style: TextStyle(
                                              //                         fontSize:
                                              //                             14,
                                              //                         color: Colors
                                              //                             .white),
                                              //                   ),
                                              //                   Icon(
                                              //                     Icons.chat,
                                              //                     size: 16,
                                              //                     color: Colors
                                              //                         .white,
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             )),
                                              //       )
                                              //     : Container(
                                              //         width: width / 4,
                                              //         child: FlatButton(
                                              //             color: Colors.black,
                                              //             onPressed: () {},
                                              //             child: Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .all(8.0),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .center,
                                              //                 children: [
                                              //                   Text(
                                              //                     'add',
                                              //                     style: TextStyle(
                                              //                         fontSize:
                                              //                             14,
                                              //                         color: Colors
                                              //                             .white),
                                              //                   ),
                                              //                   Icon(
                                              //                     Icons.add,
                                              //                     color: Colors
                                              //                         .white,
                                              //                     size: 16,
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             )),
                                              //       ),
                                              title: Text(
                                                e.name,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
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
                                try {
                                  setState(() {
                                    loading = true;
                                  });
                                  applicationProvider.getMyPosts();
                                  applicationProvider.getAllPosts();
                                  applicationProvider.getRequest();
                                  applicationProvider.getNotification();
                                  applicationProvider.getAllUsers();
                                  applicationProvider
                                      .getAllMyFriends()
                                      .then((value) {
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                } catch (e) {
                                  log(e);
                                  setState(() {
                                    loading = false;
                                  });
                                  AlertsManager().showError(
                                      context: context,
                                      title: 'Ops..',
                                      body: 'Something Went Wrong',
                                      description: 'Something Went Wrong');
                                }
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
                    loading ? LoadingShimmer(width: width) : Container(),
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
