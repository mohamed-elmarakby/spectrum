import 'package:flutter/material.dart';

class GroupWidget extends StatefulWidget {
  String groupName, groupImage;
  GroupWidget({this.groupImage, this.groupName});
  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF707070).withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(21),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
            ),
            title: Text(widget.groupName),
            trailing: Container(
              decoration: BoxDecoration(
                color: Color(0xFF4F62C4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
                child: Text(
                  'Enter',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
