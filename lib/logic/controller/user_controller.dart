import '../../helpers/database_helper.dart';

class UserController {
  final dbHelper = DatabaseHelper.instance;

  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await dbHelper.database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
