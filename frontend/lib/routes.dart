import 'package:flutter/material.dart';
import 'screens/user/login_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/admin/admin_home_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginScreen(),
  '/userHome': (context) => const MyHomePage(),
  '/adminHome': (context) => const AdminHomeScreen(),
};