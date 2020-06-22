import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:skypeclone/models/log.dart';
import 'package:skypeclone/resources/local_db/interfaces/log_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfLiteMethods implements LogInterface {
  Database _db;

  String databaseName = "LogDb";

  String tableName = "Call_Logs";

  //columns
  String logid = "log_id";
  String callerName = "caller_name";
  String callerPic = "caller_pic";
  String receiverName = "receiver_name";
  String receiverPic = "receiver_pic";
  String callStatus = "call_status";
  String timeStamp = "timestamp";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    print("db was null");
    _db = await init();
    return _db;
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String createTableQuery =
        "CREATE TABLE $tableName ($logid INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT , $timeStamp TEXT)";
    await db.execute(createTableQuery);
    print("table created");
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  deleteLogs(int logId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$logid = ?", whereArgs: [logId]);
  }

  updateLogs(Log log) async {
    var dbClient = await db;
    await dbClient.update(tableName, log.toMap(log),
        where: "$logid = ?", whereArgs: [log.logId]);
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;

      List<Map> maps = await dbClient.query(tableName, columns: [
        logid,
        callerName,
        callerPic,
        receiverName,
        receiverPic,
        callStatus,
        timeStamp,
      ]);

      List<Log> logList = [];

      if (maps != null) {
        for (var map in maps) {
          logList.add(Log.fromMap(map));
        }
      }
      return logList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
