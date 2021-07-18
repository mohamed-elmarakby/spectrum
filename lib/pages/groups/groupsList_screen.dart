import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allGroups_model.dart';
import 'package:graduation_project/pages/groups/createGroup_model.dart';
import 'package:graduation_project/pages/main_screens/home_screen.dart';
import 'package:graduation_project/pages/main_screens/insideChat_screen.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/widgets/alrert_manger.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:graduation_project/widgets/group_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class GroupsListScreen extends StatefulWidget {
  @override
  _GroupsListScreenState createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  AllGroupsModel allGroupsModel = AllGroupsModel();
  bool loading = false;
  Future getGroups() async {
    await HomeServices().getAllGroupsApi(userId: user.id).then((value) {
      setState(() {
        allGroupsModel = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    getGroups().then((value) {
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
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
            child: Icon(Icons.arrow_back),
          ),
          backgroundColor: Color(0xFF707070),
          title: Text('Groups'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: loading
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
                                    highlightColor:
                                        Colors.black.withOpacity(0.6),
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
                                                style:
                                                    TextStyle(fontSize: 15.0),
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    duration: Duration(milliseconds: 600),
                                    type: PageTransitionType.fade,
                                    child: CreateGroupScreen()));
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                'Create Group',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            height: 40.00,
                            width: 100.00,
                            decoration: BoxDecoration(
                              color: Color(0xff4f62c4),
                              border: Border.all(
                                width: 1.00,
                                color: Color(0xff707070),
                              ),
                              borderRadius: BorderRadius.circular(7.00),
                            ),
                          ),
                        ),
                      ),
                      (allGroupsModel.groups == null ||
                              allGroupsModel.groups.isEmpty)
                          ? Center(
                              child: Text('No Groups Yet'),
                            )
                          : Expanded(
                              flex: 9,
                              child: ListView(
                                children: allGroupsModel.groups
                                    .map((e) => GroupWidget(
                                          groups: e,
                                        ))
                                    .toList(),
                              ),
                            ),
                    ],
                  )),
      ),
    ));
  }
}
