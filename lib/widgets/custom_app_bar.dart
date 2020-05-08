import 'package:flutter/material.dart';
import 'package:skypeclone/utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  CustomAppBar({
    @required this.actions,
    @required this.centerTitle,
    @required this.leading,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: kBlackColor,
        border: Border(
          bottom: BorderSide(
            color: kSeparatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: kBlackColor,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  final Size preferredSize = Size.fromHeight(kToolbarHeight + 10.0);
}
