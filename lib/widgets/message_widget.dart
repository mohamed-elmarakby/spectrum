import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  String sender, content, date;
  bool isMe;
  MessageWidget({this.date, this.content, this.sender, this.isMe = false});
  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              color: widget.isMe ? Color(0xFFEFCDCD) : Color(0xFF707070),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                widget.content,
                style:
                    TextStyle(color: widget.isMe ? Colors.black : Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              widget.date,
              style: TextStyle(color: Color(0xFF707070).withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
