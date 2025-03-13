import 'package:admin_adelle/screens/homepage.dart';
import 'package:admin_adelle/screens/login.dart';

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://afndskoljshrlbvemsyu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmbmRza29sanNocmxidmVtc3l1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcyNjk5NDEsImV4cCI6MjA1Mjg0NTk0MX0.OfQrC9UvHGbJrEq2KZwwwQDM8eBhd1h6JjslnUy7iJA',
  );
  runApp(MainApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Adelle", debugShowCheckedModeBanner: false, home: Homepage());
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is already logged in
    final session = supabase.auth.currentSession;

    if (session != null) {
      // User is logged in, navigate to HomePage
      return Homepage();
    } else {
      // User is not logged in, navigate to LandingPage
      return LoginPage();
    }
  }
}
