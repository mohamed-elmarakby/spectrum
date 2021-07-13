import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allChats_model.dart';
import 'package:graduation_project/pages/main_screens/insideChat_screen.dart';
import 'package:graduation_project/pages/profile/profile_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ChatsListScreen extends StatefulWidget {
  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  List<AllChatsModel> allChatsModel = [];
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ApplicationProvider applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
      getChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF707070),
        title: Text('Chats List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: allChatsModel
                .map((e) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 600),
                                type: PageTransitionType.fade,
                                child: InsideChatScreen(
                                    // isMine: e.sId == user.id,
                                    // userId: e.sId,
                                    )));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: e.senderId.image == null
                              ? Container()
                              : Container(
                                  height: MediaQuery.of(context).size.width / 2,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            e.senderId.image)),
                                  ),
                                ),
                        ),
                        subtitle: Text('${e.content.toString()}'),
                        trailing: Text(dateFormat
                            .format(DateTime.parse(e.date))
                            .toString()),
                        title: Text(
                          e.senderId.name.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    ));
  }
}
