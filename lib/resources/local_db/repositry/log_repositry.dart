import 'package:flutter/material.dart';
import 'package:skypeclone/models/log.dart';
import 'package:skypeclone/resources/local_db/db/hive_methods.dart';
import 'package:skypeclone/resources/local_db/db/sqflite_methods.dart';

class LogRepository {
  static var dbObject;
  static bool isHive;

  static init({@required bool isHive}) {
    dbObject = isHive ? HiveMethods() : SqfLiteMethods();
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(String logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}
