import 'package:flutter/material.dart';
import 'package:skypeclone/utils/constants.dart';

class ChatLayout extends StatelessWidget {
  bool isSender = true;
  ChatLayout({@required this.isSender});
  Radius messageRadius = Radius.circular(10);

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
        child: Text(
          "Hello",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
