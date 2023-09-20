import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'package:hackz_tyranno/view/home.dart';
import 'package:hackz_tyranno/view/auth.dart';

Future<void> main() async {

  // load .env
  await dotenv.load(fileName: '.env');

  // init firebase app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application for Tyranno-Cup',
      theme: _getCustomTheme(),
      home: StreamBuilder<User?> (
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // loading component
            return const SizedBox();
          }
          if (snapshot.hasData) {
            // user is logged in
            return const HomePage();
          }
          return const AuthPage();
        }
      ),
    );
  }
}

ThemeData _getCustomTheme() {
  var baseTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
    useMaterial3: true,
  );
  return baseTheme.copyWith(
    textTheme: GoogleFonts.murechoTextTheme(baseTheme.textTheme),
  );
}