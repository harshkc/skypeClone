import 'package:flutter/material.dart';
import 'package:skypeclone/models/message.dart';

class LastMessageContainer extends StatelessWidget {
  final Stream stream;

  LastMessageContainer({this.stream});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;

          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data);

            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                message.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            );
          }
          return Text(
            "No Messages",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
            ),
          );
        }
        return Text(
          "Error: Check Your Connection",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
        );
      },
    );
  }
}
