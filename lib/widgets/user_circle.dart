import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/utils/utilities.dart';
import 'package:skypeclone/widgets/chat_list_screen/user_details_container.dart';

class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        backgroundColor: kBlackColor,
        isScrollControlled: true,
        context: context,
        builder: (context) => UserDetailsContainer(),
      ),
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: kSeparatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                Utils.getInitials(userProvider.getUser.name),
                style: TextStyle(
                  color: kLightBlueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
              ),
            ),
            kAlignedOnlineDot, //online dot Widget Aligned bottom right
          ],
        ),
      ),
    );
  }
}
