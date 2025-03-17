import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_adelle/screens/home.dart';
import 'package:user_adelle/screens/login.dart';
import 'package:user_adelle/screens/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://afndskoljshrlbvemsyu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmbmRza29sanNocmxidmVtc3l1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcyNjk5NDEsImV4cCI6MjA1Mjg0NTk0MX0.OfQrC9UvHGbJrEq2KZwwwQDM8eBhd1h6JjslnUy7iJA',
  );

  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isFirstTime = true; // Default to true

  @override
  void initState() {
    super.initState();
    checkFirstTimeUser();
  }

  Future<void> checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('isFirstTime') ?? true;

    setState(() {
      isFirstTime = firstTime;
    });

    if (isFirstTime) {
      // Mark that the user has seen WelcomePage
      await prefs.setBool('isFirstTime', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = supabase.auth.currentSession;

    if (isFirstTime) {
      return const WelcomePage(); // Show WelcomePage only on first launch
    } else if (session != null) {
      return const HomePage(); // If logged in, go to HomePage
    } else {
      return const LoginPage(); // If not logged in, go to LoginPage
    }
  }
}
