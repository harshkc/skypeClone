import 'package:flutter/material.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/widgets/custom_tile.dart';

class ChatListContainer extends StatefulWidget {
  ChatListContainer({@required this.currentUserId});

  final String currentUserId;

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomTile(
            mini: false,
            onPressed: () {},
            title: Text(
              "Harsh Choudhary",
              style: TextStyle(
                  color: Colors.white, fontFamily: "Arial", fontSize: 19.0),
            ),
            subtitle: Text(
              "Hello there!!",
              style: TextStyle(color: kGreyColor, fontSize: 14.0),
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      "https://instagram.fagr1-1.fna.fbcdn.net/v/t51.2885-19/s320x320/89859496_210935153553074_1500473290446077952_n.jpg?_nc_ht=instagram.fagr1-1.fna.fbcdn.net&_nc_ohc=y2wc-6i7cuUAX9eHoZ1&oh=a7ee62727b0dd4065bf18ad5711eeead&oe=5EDDC52D",
                    ),
                  ),
                  kAlignedOnlineDot, //online dot Widget Aligned bottom right
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
