import 'package:flutter/material.dart';
import 'package:skypeclone/models/log.dart';
import 'package:skypeclone/resources/local_db/repositry/log_repositry.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text(
            "Press me to check db",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            LogRepository.init(isHive: true);
            LogRepository.addLogs(Log());
          },
        ),
      ),
    );
  }
}
