import 'package:flutter/material.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allGroups_model.dart';
import 'package:graduation_project/pages/main_screens/insideChat_screen.dart';
import 'package:graduation_project/services/home_services.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
            : (allGroupsModel.groups == null || allGroupsModel.groups.isEmpty)
                ? Center(
                    child: Text('No Groups Yet'),
                  )
                : ListView(
                    children: allGroupsModel.groups
                        .map((e) => GroupWidget(
                              groups: e,
                            ))
                        .toList(),
                  ),
      ),
    ));
  }
}
