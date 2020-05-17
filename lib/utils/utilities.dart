import 'package:skypeclone/enum/user_state.dart';

class Utils {
  static String getUsername(String email) {
    return "live:${email.split("@")[0]}";
  }

  static String getInitials(String name) {
    List<String> names = name.split(" ");
    String initial = "";
    initial = names[0][0] + names[1][0];
    return initial;
  }

  ///UserState utils///
  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;
      case UserState.Online:
        return 1;
      default:
        return 2;
    }
  }

  static UserState numToState(int num) {
    switch (num) {
      case 0:
        return UserState.Offline;
      case 1:
        return UserState.Online;
      default:
        return UserState.Waiting;
    }
  }

  ///UserState utils///
}
