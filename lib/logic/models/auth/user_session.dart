import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String _keyUserId = "user_id";

  static Future<void> saveUser(int userId,String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
  }

  static Future<int?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  
}
