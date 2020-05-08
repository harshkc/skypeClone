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
}
