import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/resources/firebase_repositry.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/widgets/custom_tile.dart';

import 'chat_screens/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepositry _repositry = FirebaseRepositry();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repositry.getCurrentUser().then((FirebaseUser currentUser) {
      _repositry.fetchAllUsers(currentUser).then((List<User> users) {
        setState(() {
          userList = users;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      appBar: appBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: buildSuggestions(query),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [kGradientColorStart, kGradientColorEnd]),
        ),
      ),
      bottom: PreferredSize(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: kBlackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30.0,
            ),
            decoration: InputDecoration(
              suffixIcon: query.isEmpty
                  ? Icon(
                      MdiIcons.minus,
                      size: 0.0,
                    )
                  : IconButton(
                      icon: Icon(
                        MdiIcons.closeCircleOutline,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback(
                            (_) => searchController.clear());
                        setState(() {
                          query = "";
                        });
                      },
                    ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                color: Color(0x88ffffff),
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight + 10.0),
      ),
    );
  }

  Widget buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList
            .where((User user) =>
                (user.username.toLowerCase().contains(query.toLowerCase())) ||
                (user.name.toLowerCase().contains(query.toLowerCase())))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username);
        return CustomTile(
          mini: false,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(receiver: searchedUser),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(color: kGreyColor),
          ),
        );
      },
    );
  }
}
