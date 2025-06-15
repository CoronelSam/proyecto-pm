import 'package:flutter/material.dart';
import 'package:frontend/components/app_drawer.dart';
import 'package:frontend/components/bottom_navbar.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/screens/menu_screen.dart';
import 'package:frontend/screens/order_screen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/utils/user_session.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    MenuScreen(),
    OrderScreen(),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
// Ejemplo, reemplaza por tu lógica real
  @override
  Widget build(BuildContext context) {
    final session = UserSession();
    final String userName = session.userName ?? '';
    final String userEmail = session.userEmail ?? '';
    return Scaffold(
      backgroundColor: AppColors.primaryBackground, 
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 4,
        shadowColor: Colors.black87,
        title: const Text('Home Screen'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        onSelectPage: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        onLogout: _logout,
        userName: userName,
        userEmail: userEmail,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}