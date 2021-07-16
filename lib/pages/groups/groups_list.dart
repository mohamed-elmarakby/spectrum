import 'package:flutter/material.dart';

class GroupsList extends StatefulWidget {
  @override
  _GroupsListState createState() => _GroupsListState();
}

List groupList = [1, 1, 1, 1, 11, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

class _GroupsListState extends State<GroupsList> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Groups'),
          backgroundColor: Color(0x707070),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20.0, right: 20),
                    hintText: 'Search for a Group...',
                    border: OutlineInputBorder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: groupList
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: ListTile(
                                    leading: new Container(
                                      height: 49.00,
                                      width: 49.00,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/user.png"),
                                        ),
                                        border: Border.all(
                                          width: 1.00,
                                          color: Color(0xff707070)
                                              .withOpacity(0.42),
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    title: new Text(
                                      "Group Name",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    trailing: new Container(
                                      child: Center(
                                        child: Text(
                                          'Enter',
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
                                        borderRadius:
                                            BorderRadius.circular(7.00),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                border: Border.all(
                                  width: 1.00,
                                  color: Color(0xff707070),
                                ),
                                borderRadius: BorderRadius.circular(16.00),
                              ),
                            ),
                          ),
                        )
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
