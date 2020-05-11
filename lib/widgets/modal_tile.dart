import 'package:flutter/material.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/widgets/custom_tile.dart';

class ModalTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;

  ModalTile({
    @required this.title,
    this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: kReceiverColor,
          ),
          padding: EdgeInsets.all(10.0),
          child: Icon(
            icon,
            size: 38.0,
            color: kGreyColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.0,
            color: kGreyColor,
          ),
        ),
      ),
    );
  }
}
