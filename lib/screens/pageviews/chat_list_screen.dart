import 'package:flutter/material.dart';
import 'package:skypeclone/screens/call_screens/pickups/pickup_layout.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/widgets/chat_list_screen/chat_list_container.dart';
import 'package:skypeclone/widgets/chat_list_screen/custom_fab.dart';
import 'package:skypeclone/widgets/custom_app_bar.dart';
import 'package:skypeclone/widgets/user_circle.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: kBlackColor,
        appBar: customAppBar(context),
        floatingActionButton: CustomFAB(),
        body: ChatListContainer(),
      ),
    );
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {}),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
