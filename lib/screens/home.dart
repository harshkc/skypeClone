import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/enum/user_state.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/resources/auth_methods.dart';
import 'package:skypeclone/screens/pageviews/chat_list_screen.dart';
import 'package:skypeclone/utils/constants.dart';

import 'call_screens/pickups/pickup_layout.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;

  final AuthMethods _authMethods = AuthMethods();

  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    //To update the provider values after the screen is created
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId,
                userState: UserState.Online,
              )
            : print("Application resumed");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId,
                userState: UserState.Offline,
              )
            : print("Application resumed");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId,
                userState: UserState.Waiting,
              )
            : print("Application resumed");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId,
                userState: UserState.Offline,
              )
            : print("Application resumed");
        break;
    }
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
            padding: EdgeInsets.symmetric(vertical: 8.0),
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
