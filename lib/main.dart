import 'package:electrical_store_mobile_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:electrical_store_mobile_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async{
      WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Shopping",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.almaraiTextTheme(Theme.of(context).textTheme),
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: kPrimaryColor,
        ),
      ),

      // اللغات المدعومة
      supportedLocales: const [
        Locale('ar', 'AE'), // عربي
      ],
      locale: Locale('ar', 'AE'),

      // مكتبات الترجمة الافتراضية
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: SplashScreen(),
    );
  }
}
