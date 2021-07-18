import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allGroups_model.dart';
import 'package:graduation_project/pages/groups/groupsList_screen.dart';
import 'package:graduation_project/pages/main_screens/insideChat_screen.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/widgets/alrert_manger.dart';
import 'package:graduation_project/widgets/error_text.dart';
import 'package:graduation_project/widgets/friend.dart';
import 'package:graduation_project/widgets/group_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  bool loading = false;
  bool creating = false;
  TextEditingController _groupNameController = TextEditingController();
  bool showError = false;
  Future getAllFriends() async {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    await applicationProvider.getAllMyFriends();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ApplicationProvider applicationProvider =
          Provider.of<ApplicationProvider>(context, listen: false);
      getAllFriends().then((value) {
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
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF707070),
        title: Text('Create Group'),
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
                                      borderRadius: BorderRadius.circular(25.0),
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
            : (applicationProvider.allMyFriends == null ||
                    applicationProvider.allMyFriends.isEmpty)
                ? Center(
                    child: Text(
                        'No Friends Found, to make a group you must have friends'),
                  )
                : ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Group Name",
                              style: TextStyle(
                                fontFamily: "GE_SS_TWO",
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _groupNameController,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 20.0, right: 20),
                                hintText: 'Enter Group name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          showError
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ErrorText(),
                                )
                              : Container()
                        ],
                      ),
                      ...applicationProvider.allMyFriends
                          .map(
                            (e) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(e.id.image),
                                  maxRadius: 18,
                                  minRadius: 14,
                                ),
                                title: Text(e.id.name.toString()),
                                trailing: Checkbox(
                                    value: e.chosen ?? false,
                                    tristate: false,
                                    activeColor: Colors.green,
                                    onChanged: (bool newValue) {
                                      setState(() {
                                        e.chosen = newValue;
                                      });
                                    })),
                          )
                          .toList(),
                      GestureDetector(
                        onTap: () async {
                          if (!creating) {
                            if (_groupNameController.text.trim().isNotEmpty) {
                              setState(() {
                                creating = true;
                              });
                              List<String> members = [];
                              setState(() {
                                members.add(user.id);
                              });
                              for (var userSample
                                  in applicationProvider.allMyFriends) {
                                log(userSample.id.sId +
                                    ' - chosen: ' +
                                    userSample.chosen.toString());
                                if ((userSample.id.sId != user.id) &&
                                    userSample.chosen) {
                                  setState(() {
                                    members.add(userSample.id.sId);
                                  });
                                }
                              }
                              if (members.length >= 3) {
                                await HomeServices()
                                    .createGroupApi(
                                  name: _groupNameController.text
                                      .trim()
                                      .toString(),
                                  members: members,
                                )
                                    .then((value) {
                                  log('status of creating= ' +
                                      value.toString());

                                  setState(() {
                                    creating = false;
                                  });
                                  if (value == "created") {
                                    AlertsManager().showSuccess(
                                      context: context,
                                      title: 'Done',
                                      body: 'Group Created Successfully',
                                      description: 'Group Created Successfully',
                                      signup: false,
                                    );
                                  } else {
                                    AlertsManager().showError(
                                        context: context,
                                        title: 'Ops..',
                                        body: 'Something Went Wrong',
                                        description: 'Something Went Wrong');
                                  }
                                }).catchError((onError) {
                                  setState(() {
                                    creating = false;
                                  });
                                  AlertsManager().showError(
                                      context: context,
                                      title: 'Ops..',
                                      body: 'Something Went Wrong',
                                      description: 'Something Went Wrong');
                                });
                              } else {
                                setState(() {
                                  creating = false;
                                });
                                AlertsManager().showInfo(
                                    context: context,
                                    title: 'Warning',
                                    body: 'Group Must Have at least 3 members',
                                    description:
                                        'Group Must Have at least 3 members');
                              }
                            }
                          }
                        },
                        child: Container(
                          child: Center(
                            child: creating
                                ? SpinKitWave(
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : Text(
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
                    ],
                  ),
      ),
    ));
  }
}
