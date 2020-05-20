import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/models/contact.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/resources/chat_methods.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/widgets/chat_list_screen/contact_view.dart';
import 'package:skypeclone/widgets/quiet_box.dart';

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _chatMethods.fetchAllContacts(userId: userProvider.getUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data.documents;

            if (docList.isEmpty) {
              return QuietBox();
            }
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: docList.length,
              itemBuilder: (context, index) {
                Contact contact = Contact.fromMap(docList[index].data);

                return ContactView(contact: contact);
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kGradientColorEnd,
            ),
          );
        },
      ),
    );
  }
}
