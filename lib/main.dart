import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import indispensable
import 'firebase_options.dart'; // Le fichier généré par flutterfire configure
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  // Initialiser Firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Pour enlever la bannière "Debug"
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
