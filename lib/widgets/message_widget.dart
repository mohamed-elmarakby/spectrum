import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  String sender, content, date, image;
  bool isMe;
  MessageWidget(
      {this.date, this.content, this.image, this.sender, this.isMe = false});
  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: !widget.isMe
            ? [
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      minRadius: 14,
                      maxRadius: 16,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.image,
                      ),
                    )),
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
                      style: TextStyle(
                          color: widget.isMe ? Colors.black : Colors.white),
                    ),
                  ),
                ),
              ]
            : [
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
                      style: TextStyle(
                          color: widget.isMe ? Colors.black : Colors.white),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      minRadius: 14,
                      maxRadius: 16,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.image,
                      ),
                    )),
              ],
      ),
    );
  }
}
