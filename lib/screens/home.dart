import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
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
    double _labelFontSize = 10;

    return Scaffold(
      backgroundColor: Constants.blackColor,
      body: PageView(
        children: <Widget>[
          Center(
            child: Text(
              "Chat List Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
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
      ),
      bottomNavigationBar: Container(
        child: CupertinoTabBar(
          backgroundColor: Constants.blackColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                color: (_page == 0)
                    ? Constants.lightBlueColor
                    : Constants.greyColor,
              ),
              title: Text(
                "Chats",
                style: TextStyle(
                    fontSize: _labelFontSize,
                    color:
                        (_page == 0) ? Constants.lightBlueColor : Colors.grey),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.call,
                color: (_page == 1)
                    ? Constants.lightBlueColor
                    : Constants.greyColor,
              ),
              title: Text(
                "Calls",
                style: TextStyle(
                    fontSize: _labelFontSize,
                    color:
                        (_page == 1) ? Constants.lightBlueColor : Colors.grey),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.contact_phone,
                color: (_page == 2)
                    ? Constants.lightBlueColor
                    : Constants.greyColor,
              ),
              title: Text(
                "Contacts",
                style: TextStyle(
                    fontSize: _labelFontSize,
                    color:
                        (_page == 2) ? Constants.lightBlueColor : Colors.grey),
              ),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}
