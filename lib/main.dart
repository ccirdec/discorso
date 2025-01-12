import 'package:discorso/firebase_options.dart';
import 'package:discorso/pages/splash_screen.dart';
import 'package:discorso/services/auth/auth_gate.dart';
import 'package:discorso/services/database/database_provider.dart';
import 'package:discorso/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => DatabaseProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context) => const SplashScreen(),
        '/splash': (context)=> const SplashScreen(),
        '/auth':(context) => const AuthGate()
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
