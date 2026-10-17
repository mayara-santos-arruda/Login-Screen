// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:login_flutter/login_screen.dart';
import 'package:login_flutter/pallete.dart';
import 'package:login_flutter/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:login_flutter/auth_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tmenhnzkxraofqmitkdz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtZW5obnpreHJhb2ZxbWl0a2R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk1OTQ2NDAsImV4cCI6MjEwNTE3MDY0MH0.Ua9H0e6Lfr-gRxy7DsI4OlSIsTIZPJIQ-upREZyp4Z8',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Tela de Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Pallete.backgroundColor,
      ),
      
      home: StreamBuilder<AuthState>(
        stream: AuthService.estadoAutenticacao,
        builder: (context, snapshot) {
          if (AuthService.estaAutenticado) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}

