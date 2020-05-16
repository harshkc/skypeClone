import 'package:flutter/material.dart';
import 'package:skypeclone/models/message.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/widgets/cached_image.dart';

class ChatLayout extends StatelessWidget {
  final bool isSender;
  final Message message;
  final Radius messageRadius = Radius.circular(10);

  ChatLayout({this.isSender = true, @required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: isSender ? kSenderColor : kReceiverColor,
        borderRadius: isSender
            ? BorderRadius.only(
                topLeft: messageRadius,
                topRight: messageRadius,
                bottomLeft: messageRadius,
              )
            : BorderRadius.only(
                bottomRight: messageRadius,
                topRight: messageRadius,
                bottomLeft: messageRadius,
              ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return message.type != "image"
        ? Text(
            message.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        : message.photoUrl != null
            ? CachedImage(
                message.photoUrl,
                height: 250,
                width: 250,
                radius: 10,
              )
            : Text("Url was null");
  }
}
