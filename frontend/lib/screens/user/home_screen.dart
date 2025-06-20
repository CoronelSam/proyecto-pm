import 'package:flutter/material.dart';
import 'package:frontend/components/app_drawer.dart';
import 'package:frontend/components/bottom_navbar.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/screens/user/menu_screen.dart';
import 'package:frontend/screens/user/order_screen.dart';
import 'package:frontend/screens/user/profile_screen.dart';
import 'package:frontend/screens/user/login_screen.dart';
import 'package:frontend/screens/user/cart_screen.dart';
import 'package:frontend/utils/user_session.dart';
import 'package:provider/provider.dart';
import '../../services/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    final session = UserSession();
    final String userName = session.userName ?? '';
    final String userEmail = session.userEmail ?? '';

    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    int cartCount = cartItems.isNotEmpty
        ? cartItems.fold(0, (sum, item) => sum + item.quantity)
        : 0;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground, 
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 4,
        shadowColor: Colors.black87,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
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