import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/screens/pageviews/chat_list_screen.dart';
import 'package:skypeclone/utils/constants.dart';

import 'call_screens/pickups/pickup_layout.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;

  int _page = 0;

  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    //To update the provider values after the screen is created
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });

    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: kBlackColor,
        body: PageView(
          children: <Widget>[
            ChatListScreen(), //i.e.first screen of app after logining
            Center(
              child: Text(
                "Call Logs",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                "Contact Screen",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: CupertinoTabBar(
              backgroundColor: kBlackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.commentText,
                    color: (_page == 0) ? kLightBlueColor : kGreyColor,
                  ),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: kLabelFontSize,
                        color: (_page == 0) ? kLightBlueColor : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.phone,
                    color: (_page == 1) ? kLightBlueColor : kGreyColor,
                  ),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontSize: kLabelFontSize,
                        color: (_page == 1) ? kLightBlueColor : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MdiIcons.cardAccountPhone,
                    color: (_page == 2) ? kLightBlueColor : kGreyColor,
                  ),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                        fontSize: kLabelFontSize,
                        color: (_page == 2) ? kLightBlueColor : Colors.grey),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
