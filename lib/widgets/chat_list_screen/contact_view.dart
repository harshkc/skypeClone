import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/models/contact.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/resources/auth_methods.dart';
import 'package:skypeclone/resources/chat_methods.dart';
import 'package:skypeclone/screens/chat_screens/chat_screen.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/widgets/cached_image.dart';
import 'package:skypeclone/widgets/chat_list_screen/last_message_container.dart';
import 'package:skypeclone/widgets/custom_tile.dart';
import 'package:skypeclone/widgets/online_dot_indicator.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView({this.contact});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          return ContactContainer(contact: user);
        }
        return Center(
          child: CircularProgressIndicator(backgroundColor: kGradientColorEnd),
        );
      },
    );
  }
}

class ContactContainer extends StatelessWidget {
  final User contact;
  final _chatMethods = ChatMethods();

  ContactContainer({this.contact});
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            receiver: contact,
          ),
        ),
      ),
      title: Text(
        (contact != null ? contact.name : null) != null
            ? contact.name
            : "No Contact retrieved\nCheck Your connection",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
            senderId: userProvider.getUser.uid, receiverId: contact.uid),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 60.0),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80.0,
              isRound: true,
            ),
            OnlineDotIndicator(uid: contact.uid),
          ],
        ),
      ),
    );
  }
}
