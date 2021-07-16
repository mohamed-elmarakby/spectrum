import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allMyFriends_model.dart';
import 'package:graduation_project/models/allOfCurrentUser_model.dart';
import 'package:graduation_project/models/userInfo_model.dart';
import 'package:graduation_project/pages/main_screens/home_screen.dart';
import 'package:graduation_project/pages/main_screens/insideChat_screen.dart';
import 'package:graduation_project/pages/profile/edit_profile_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/freinds_services.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/alrert_manger.dart';
import 'package:graduation_project/widgets/full_photo.dart';
import 'package:graduation_project/widgets/my_post_widget.dart';
import 'package:graduation_project/widgets/post_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

_ProfilePageScreenState profilePageScreenState;

class ProfilePageScreen extends StatefulWidget {
  bool isMine;
  String chatId;
  bool isRequest;
  String userId;
  ProfilePageScreen(
      {this.chatId, this.isRequest = false, this.isMine = true, this.userId});
  @override
  _ProfilePageScreenState createState() {
    profilePageScreenState = _ProfilePageScreenState();
    return profilePageScreenState;
  }
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  TextEditingController _postTextController;
  bool load = false;
  bool alreadySent = false;
  UserInfoResponse userInfoResponse = UserInfoResponse();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future getInfo() async {
    await FriendsServices().userInfoApi(userId: widget.userId).then((value) {
      setState(() {
        userInfoResponse = value;
        print(user.id);
        print(userInfoResponse.id);
      });
    });
  }

  final picker = ImagePicker();
  String base64Image;
  File imageFile;
  Uint8List bytes;
  Future getImage() async {
    ImageSource source;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            elevation: 3,
            title: Text("Add Image"),
            content: Text("Where do you want to get the image?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Camera",
                ),
                onPressed: () {
                  setState(() {
                    source = ImageSource.camera;
                  });
                  Navigator.pop(context);
                },
              ),
              Builder(
                builder: (context) {
                  return FlatButton(
                    child: Text(
                      "Gallery",
                    ),
                    onPressed: () {
                      setState(() {
                        source = ImageSource.gallery;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              )
              // usually buttons at the bottom of the dialog
              ,
            ],
          ),
        );
      },
    ).then((value) async {
      var image = await picker.getImage(
        source: source,
        imageQuality: 60,
      );
      if (image != null) {
        List<int> imageBytes = File(image.path).readAsBytesSync();
        setState(() {
          imageFile = File(image.path);
          base64Image = base64Encode(imageBytes);
          bytes = base64.decode(base64Image);
          print('Encoded Image here $base64Image');
        });
      }
    }).catchError((onError) {
      log(onError.toString());
      AlertsManager().showError(
          context: context,
          title: 'Ops..',
          body: 'Something Went Wrong',
          description: 'Something Went Wrong');
    });
  }

  bool addingPost = false;
  Future post() async {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    if (_postTextController.text.isNotEmpty) {
      setState(() {
        addingPost = true;
      });
      await HomeServices()
          .addPostApi(text: _postTextController.text, file: imageFile)
          .then((value) async {
        await applicationProvider.getMyPosts().then((value) {
          setState(() {
            addingPost = false;
            imageFile = null;
          });
          _postTextController.clear();
        }).catchError((onError) {
          log(onError.toString());
          setState(() {
            addingPost = false;
            imageFile = null;
          });
          AlertsManager().showError(
              context: context,
              title: 'Ops..',
              body: 'Something Went Wrong',
              description: 'Something Went Wrong');
        });
      }).catchError((onError) {
        log(onError.toString());
        setState(() {
          addingPost = false;
          imageFile = null;
        });
        AlertsManager().showError(
            context: context,
            title: 'Ops..',
            body: 'Something Went Wrong',
            description: 'Something Went Wrong');
      });
    }
  }

  @override
  void initState() {
    print(user.id);
    super.initState();
    if (!widget.isMine) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          load = true;
        });
        getInfo().then((value) {
          ApplicationProvider applicationProvider =
              Provider.of<ApplicationProvider>(context, listen: false);
          applicationProvider
              .getSomeonePosts(id: widget.userId)
              .then((value) async {
            await HomeServices().getSendRequests(userId: user.id).then((value) {
              for (var sent in value) {
                if (sent.sId == widget.userId) {
                  setState(() {
                    alreadySent = true;
                  });
                }
              }
              setState(() {
                load = false;
              });
            }).catchError((onError) {
              log(onError.toString());
              setState(() {
                load = false;
              });
              AlertsManager().showError(
                  context: context,
                  title: 'Ops..',
                  body: 'Something Went Wrong',
                  description: 'Something Went Wrong');
            });
          }).catchError((onError) {
            log(onError.toString());
            setState(() {
              load = false;
            });
            AlertsManager().showError(
                context: context,
                title: 'Ops..',
                body: 'Something Went Wrong',
                description: 'Something Went Wrong');
          });
        }).catchError((onError) {
          log(onError.toString());
          setState(() {
            load = false;
          });
          AlertsManager().showError(
              context: context,
              title: 'Ops..',
              body: 'Something Went Wrong',
              description: 'Something Went Wrong');
        });
      });
    }
    _postTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    bool accepting = false;
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF707070),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: Text(
          'Profile Page',
        ),
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            return Navigator.pushReplacement(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 600),
                    type: PageTransitionType.fade,
                    child: HomeScreen()));
          },
          child: load
              ? ListView(
                  children: [
                    ...List.generate(
                        4,
                        (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4),
                              child: SizedBox(
                                height: 160.0,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.black.withOpacity(0.4),
                                  highlightColor: Colors.black.withOpacity(0.6),
                                  child: Card(
                                    child: ListTile(
                                      dense: true,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: width * 0.4,
                                            child: Text(
                                              '',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '',
                                                // textDirection: ui.TextDirection.ltr,
                                                style: TextStyle(
                                                    fontFamily: "Arial"),
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
                                            BorderRadius.circular(25.0),
                                      ),
                                      subtitle: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: width * 0.4,
                                            child: Text(
                                              '',
                                              overflow: TextOverflow.ellipsis,
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
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Stack(
                              children: [
                                load
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullPhoto(
                                                          url: widget.isMine
                                                              ? user.cover
                                                              : userInfoResponse
                                                                  .cover)));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: widget.isMine
                                              ? user.cover
                                              : userInfoResponse.cover,
                                          useOldImageOnUrlChange: true,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                Align(
                                  alignment: Alignment(0, 0.45),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullPhoto(
                                                  url: widget.isMine
                                                      ? user.image
                                                      : userInfoResponse
                                                          .image)));
                                    },
                                    child: CircleAvatar(
                                      minRadius: 20,
                                      maxRadius: 45,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        widget.isMine
                                            ? user.image
                                            : userInfoResponse.image,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment(0, 0.9),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: AutoSizeText(
                                      widget.isMine
                                          ? user.name.toString()
                                          : userInfoResponse.name.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          widget.isMine
                              ? Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    duration: Duration(
                                                        milliseconds: 600),
                                                    type:
                                                        PageTransitionType.fade,
                                                    child:
                                                        EditProfileScreen()));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Edit Profile',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
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
                                            socket.emit("customDisconnect",
                                                {"id": user.id});
                                            await SharedPref().remove('user');
                                            Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                    duration: Duration(
                                                        milliseconds: 600),
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: MyHomePage()));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Sign Out',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Icon(
                                                        Icons.logout,
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
                              : !applicationProvider.allMyFriends.any(
                                      (element) =>
                                          element.id.sId == widget.userId)
                                  ? alreadySent
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    //add friend request
                                                    log(user.id.toString());
                                                    log(widget.userId
                                                        .toString());
                                                    socket
                                                        .emit("cancelRequest", {
                                                      "sender": {
                                                        "_id": user.id
                                                      },
                                                      "reciever": {
                                                        "_id": widget.userId
                                                      }
                                                    });
                                                    setState(() {
                                                      alreadySent = false;
                                                    });
                                                    // Navigator.push(
                                                    //     context,
                                                    //     PageTransition(
                                                    //         duration: Duration(
                                                    //             milliseconds: 600),
                                                    //         type: PageTransitionType.fade,
                                                    //         child: EditProfileScreen()));
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.red),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Cancel Request',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Icon(
                                                                FontAwesomeIcons
                                                                    .userTimes,
                                                                size: 16,
                                                                color:
                                                                    Colors.red,
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
                                      : Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    //add friend request
                                                    log(user.id.toString());
                                                    log(widget.userId
                                                        .toString());
                                                    socket.emit("addFriend", {
                                                      "sender": {
                                                        "_id": user.id
                                                      },
                                                      "reciever": {
                                                        "_id": widget.userId
                                                      }
                                                    });

                                                    setState(() {
                                                      alreadySent = true;
                                                    });
                                                    // Navigator.push(
                                                    //     context,
                                                    //     PageTransition(
                                                    //         duration: Duration(
                                                    //             milliseconds: 600),
                                                    //         type: PageTransitionType.fade,
                                                    //         child: EditProfileScreen()));
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF0E5FDA),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Add Friend',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Icon(
                                                                FontAwesomeIcons
                                                                    .userPlus,
                                                                size: 16,
                                                                color: Colors
                                                                    .white,
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
                                  : widget.isRequest
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    accepting = true;
                                                  });
                                                  log(widget.userId.toString());
                                                  log(user.id.toString());
                                                  socket
                                                      .emit("confirmRequest", {
                                                    "sender": {
                                                      "_id": widget.userId
                                                    },
                                                    "reciever": {"_id": user.id}
                                                  });
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 500),
                                                      () async {
                                                    await applicationProvider
                                                        .getAllPosts();
                                                    await applicationProvider
                                                        .getAllMyFriends()
                                                        .then((value) {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          PageTransition(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      600),
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              child:
                                                                  ProfilePageScreen(
                                                                isMine: false,
                                                                isRequest:
                                                                    false,
                                                                userId: widget
                                                                    .userId,
                                                              )));
                                                    }).catchError((onError) {
                                                      log(onError.toString());
                                                      AlertsManager().showError(
                                                          context: context,
                                                          title: 'Ops..',
                                                          body:
                                                              'Something Went Wrong',
                                                          description:
                                                              'Something Went Wrong');
                                                    });
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF0E5FDA),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Center(
                                                        child: accepting
                                                            ? SpinKitWave(
                                                                color: Colors
                                                                    .white,
                                                                size: 14,
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Accept',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .person_add,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .white,
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
                                              child: GestureDetector(
                                                onTap: () async {
                                                  log(widget.userId.toString());
                                                  log(user.id.toString());
                                                  socket.emit("rejectRequest", {
                                                    "sender": {
                                                      "_id": widget.userId
                                                    },
                                                    "reciever": {"_id": user.id}
                                                  });
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 500),
                                                      () async {
                                                    await applicationProvider
                                                        .getAllPosts();
                                                    await applicationProvider
                                                        .getAllMyFriends()
                                                        .then((value) {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          PageTransition(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      600),
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              child:
                                                                  ProfilePageScreen(
                                                                isMine: false,
                                                                isRequest:
                                                                    false,
                                                                userId: widget
                                                                    .userId,
                                                              )));
                                                    }).catchError((onError) {
                                                      log(onError.toString());
                                                      AlertsManager().showError(
                                                          context: context,
                                                          title: 'Ops..',
                                                          body:
                                                              'Something Went Wrong',
                                                          description:
                                                              'Something Went Wrong');
                                                    });
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      border: Border.all(
                                                          color: Colors.red),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Reject',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Icon(
                                                                Icons
                                                                    .person_remove,
                                                                size: 16,
                                                                color:
                                                                    Colors.red,
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
                                      : Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await HomeServices()
                                                        .getChatMessages(
                                                            chatId: widget
                                                                        .chatId ==
                                                                    null
                                                                ? applicationProvider
                                                                    .allMyFriends
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .id
                                                                            .sId ==
                                                                        widget
                                                                            .userId)
                                                                    .chatId
                                                                : widget.chatId)
                                                        .then((value) {
                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      600),
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              child:
                                                                  InsideChatScreen(
                                                                insideChatResponseModel:
                                                                    value,
                                                                isGroup: false,
                                                              )));
                                                    }).catchError((onError) {
                                                      log(onError.toString());
                                                      AlertsManager().showError(
                                                          context: context,
                                                          title: 'Ops..',
                                                          body:
                                                              'Something Went Wrong',
                                                          description:
                                                              'Something Went Wrong');
                                                    });
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF0E5FDA),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Message',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Icon(
                                                                FontAwesomeIcons
                                                                    .facebookMessenger,
                                                                size: 16,
                                                                color: Colors
                                                                    .white,
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // unfriend user
                                                    socket.emit(
                                                        "removeFriend", {
                                                      "remover": user.id,
                                                      "removed": widget.userId
                                                    });
                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 500),
                                                        () async {
                                                      await applicationProvider
                                                          .getAllPosts()
                                                          .catchError(
                                                              (onError) {
                                                        log(onError.toString());
                                                        AlertsManager().showError(
                                                            context: context,
                                                            title: 'Ops..',
                                                            body:
                                                                'Something Went Wrong',
                                                            description:
                                                                'Something Went Wrong');
                                                      });
                                                      await applicationProvider
                                                          .getAllMyFriends()
                                                          .then((value) {
                                                        Navigator
                                                            .pushReplacement(
                                                                context,
                                                                PageTransition(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            600),
                                                                    type: PageTransitionType
                                                                        .fade,
                                                                    child:
                                                                        ProfilePageScreen(
                                                                      isMine:
                                                                          false,
                                                                      isRequest:
                                                                          false,
                                                                      userId: widget
                                                                          .userId,
                                                                    )));
                                                      }).catchError((onError) {
                                                        log(onError.toString());
                                                        AlertsManager().showError(
                                                            context: context,
                                                            title: 'Ops..',
                                                            body:
                                                                'Something Went Wrong',
                                                            description:
                                                                'Something Went Wrong');
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.red),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Unfriend',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Icon(
                                                                FontAwesomeIcons
                                                                    .userTimes,
                                                                size: 16,
                                                                color:
                                                                    Colors.red,
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
                                        ),
                        ],
                      ),
                      widget.isMine
                          ? Padding(
                              padding: EdgeInsets.all(12),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Color(0x00EEEEEE),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Color(0x4D707070),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        TextFormField(
                                          controller: _postTextController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'What\'s on your mind?',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF707070)
                                                  .withOpacity(0.75),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x4D707070),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                bottomRight:
                                                    Radius.circular(12),
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x4D707070),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                bottomRight:
                                                    Radius.circular(12),
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.start,
                                          maxLines: 3,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 12, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      getImage();
                                                    },
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.08,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Upload Image',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .upload,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (addingPost) {
                                                        return;
                                                      } else {
                                                        log('posting');
                                                        post();
                                                      }
                                                    },
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.08,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF4F62C4),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        child: Center(
                                                          child: addingPost
                                                              ? SpinKitWave(
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                )
                                                              : Text(
                                                                  'Post',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      widget.isMine
                          ? applicationProvider.myPosts.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'You Have No Posts Yet',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: applicationProvider.myPosts
                                        .map((e) => MyPostWidget(
                                              post: e,
                                            ))
                                        .toList(),
                                  ),
                                )
                          : widget.isRequest
                              ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Center(
                                      child: Text('Accept Friend to see posts'),
                                    ),
                                  ),
                                )
                              : !applicationProvider.allMyFriends.any(
                                      (element) =>
                                          element.id.sId == widget.userId)
                                  ? Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Center(
                                          child:
                                              Text('Add Friend to see posts'),
                                        ),
                                      ),
                                    )
                                  : applicationProvider.someUserPosts.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'This User has No Posts Yet',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: applicationProvider
                                                .someUserPosts
                                                .map((e) => Post(
                                                      post: e,
                                                    ))
                                                .toList(),
                                          ),
                                        )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
