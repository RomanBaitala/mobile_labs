import 'package:flutter/material.dart';

import 'package:iot_flutter_lab/screens/dashboard.dart';
import 'package:iot_flutter_lab/screens/login.dart';
import 'package:iot_flutter_lab/screens/profile.dart';
import 'package:iot_flutter_lab/screens/register.dart';


void main() {
  runApp(const HomeServerApp());
}

class HomeServerApp extends StatelessWidget {
  const HomeServerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Home Server Monitor',
      
      theme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: const Color(0xFF121212),
      
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
  
  useMaterial3: true,
),
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
