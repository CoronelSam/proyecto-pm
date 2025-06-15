class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  int? userId;
  String? userName;
  String? userEmail;
  String? userPhone;

  void clear() {
    userId = null;
    userName = null;
    userEmail = null;
    userPhone = null;
  }
}