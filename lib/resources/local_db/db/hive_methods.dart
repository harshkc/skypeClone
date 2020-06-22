import 'package:skypeclone/models/log.dart';
import 'package:skypeclone/resources/local_db/interfaces/log_interface.dart';

class HiveMethods implements LogInterface {
  @override
  addLogs(Log log) {
    print("Adding logs through hive");
    return null;
  }

  @override
  close() {
    // TODO: implement close
    return null;
  }

  @override
  deleteLogs(int logId) {
    // TODO: implement deleteLogs
    return null;
  }

  @override
  Future<List<Log>> getLogs() {
    // TODO: implement getLogs
    return null;
  }

  @override
  init() {
    print("Init Hive methods");
    return null;
  }
}
