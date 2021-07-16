import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allChats_model.dart';
import 'package:graduation_project/pages/main_screens/home_screen.dart';
import 'package:graduation_project/pages/main_screens/insideChat_screen.dart';
import 'package:graduation_project/pages/profile/profile_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/widgets/alrert_manger.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:graduation_project/widgets/loading_shimmer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

_ChatsListScreenState chatsListScreenState;

class ChatsListScreen extends StatefulWidget {
  @override
  _ChatsListScreenState createState() {
    chatsListScreenState = _ChatsListScreenState();
    return chatsListScreenState;
  }
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  List<AllChatsModel> allChatsModel = [];
  bool loading = false;
  Future getChats() async {
    log('getting chats...');
    log('${user.id}');
    await HomeServices().getAllMyChats(userId: user.id).then((value) {
      setState(() {
        allChatsModel = value;
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
      getChats().then((value) {
        setState(() {
          loading = false;
        });
      }).catchError((onError) {
        log(onError.toString());
        setState(() {
          loading = false;
        });
        AlertsManager().showError(
            context: context,
            title: 'Ops..',
            body: 'Something Went Wrong',
            description: 'Something Went Wrong');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
    double width = MediaQuery.of(context).size.width;
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    return SafeArea(
        child: WillPopScope(
      onWillPop: () {
        return Navigator.push(
            context,
            PageTransition(
                duration: Duration(milliseconds: 600),
                type: PageTransitionType.fade,
                child: HomeScreen()));
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        type: PageTransitionType.fade,
                        child: HomeScreen()));
              },
              child: Icon(Icons.arrow_back)),
          backgroundColor: Color(0xFF707070),
          title: Text('Chats List'),
        ),
        body: loading
            ? LoadingShimmer(width: width)
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: allChatsModel
                        .map((e) => GestureDetector(
                              onTap: () async {
                                await HomeServices()
                                    .getChatMessages(chatId: e.chat.sId)
                                    .then((value) {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 600),
                                          type: PageTransitionType.fade,
                                          child: InsideChatScreen(
                                            insideChatResponseModel: value,
                                            isGroup: false,
                                          )));
                                }).catchError((onError) {
                                  log(onError.toString());
                                  AlertsManager().showError(
                                      context: context,
                                      title: 'Ops..',
                                      body: 'Something Went Wrong',
                                      description: 'Something Went Wrong');
                                });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: CachedNetworkImageProvider(e
                                      .chat.users
                                      .firstWhere(
                                          (element) => element.sId != user.id)
                                      .image),
                                  minRadius: 16,
                                  maxRadius: 24,
                                  // child: e.senderId.image == null
                                  //     ? Container()
                                  //     : Container(
                                  //         height:
                                  //             MediaQuery.of(context).size.width /
                                  //                 2,
                                  //         width:
                                  //             MediaQuery.of(context).size.width,
                                  //         decoration: BoxDecoration(
                                  //           image: DecorationImage(
                                  //               fit: BoxFit.cover,
                                  //               image: CachedNetworkImageProvider(
                                  //                   e.senderId.image)),
                                  //         ),
                                  //       ),
                                ),
                                subtitle: Text('${e.content.toString()}'),
                                trailing: Text(
                                  dateFormat
                                      .format(DateTime.parse(e.date))
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                title: Text(
                                  e.chat.users
                                      .firstWhere(
                                          (element) => element.sId != user.id)
                                      .name
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
      ),
    ));
  }
}
