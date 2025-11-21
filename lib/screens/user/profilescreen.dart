import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:electrical_store_mobile_app/logic/models/auth/auth.dart';
import 'package:electrical_store_mobile_app/logic/models/auth/user_session.dart';
import 'package:electrical_store_mobile_app/screens/auth/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:electrical_store_mobile_app/helpers/database_helper.dart';
 
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final id = await UserSession.getUser();
    if (id != null) {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query("users", where: "id = ?", whereArgs: [id]);

      if (result.isNotEmpty) {
        setState(() {
          currentUser = User.fromMap(result.first);
        });
      }
    }
  }

  void logout() async {
    await UserSession.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الملف الشخصي",style: TextStyle(color: kBackgroundColor),),        backgroundColor: kPrimaryColor,
),
      body: currentUser == null
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor,))
          : Padding(
              padding: const EdgeInsets.all(70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("الاسم: ${currentUser!.name}",
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("البريد الإلكتروني: ${currentUser!.email}",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: logout,
                    child: Text("تسجيل خروج",style: TextStyle(color: kPrimaryColor),),
                  ),
                ],
              ),
            ),
    );
  }
}
