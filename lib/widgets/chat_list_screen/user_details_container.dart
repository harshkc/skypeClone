import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/enum/user_state.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/resources/auth_methods.dart';
import 'package:skypeclone/screens/login.dart';
import 'package:skypeclone/widgets/cached_image.dart';
import 'package:skypeclone/widgets/custom_app_bar.dart';

class UserDetailsContainer extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    signOut() async {
      final bool isloggedOut = await _authMethods.signOut();
      if (isloggedOut) {
        //setting user offline when they signout
        _authMethods.setUserState(
          userId: userProvider.getUser.uid,
          userState: UserState.Offline,
        );
        //Move user to login Screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            actions: <Widget>[
              FlatButton(
                onPressed: () => signOut(),
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Icon(
              MdiIcons.skype,
              size: 35.0,
            ),
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user.email,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
