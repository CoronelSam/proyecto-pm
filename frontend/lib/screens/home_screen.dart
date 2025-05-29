import 'package:flutter/material.dart';
import 'package:frontend/components/bottom_navbar.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/screens/menu_screen.dart';
import 'package:frontend/screens/order_screen.dart';
import 'package:frontend/screens/profile_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground, 
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 4,
        shadowColor: Colors.black87,
        title: const Text('Home Screen'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu button press
          },
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}