import 'package:flutter/material.dart';
import 'package:frontend/utils/user_session.dart';
import 'package:frontend/components/admin_drawer.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/text_style.dart';
import 'admin_add_product_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_products_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AdminOrdersScreen(),
    AdminProductsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final session = UserSession();
    if (session.userRole != 'admin') {
      if (mounted) {
        Future.microtask(() {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/userHome');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = UserSession();
    if (session.userRole != 'admin') {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Ordenes Realizadas' : 'Productos',
          style: AppTextStyle.sectionTitle,
        ),
        backgroundColor: AppColors.primaryBackground,
        iconTheme: const IconThemeData(color: AppColors.sectionTitle),
        elevation: 0,
      ),
      drawer: AdminDrawer(
        onAddProduct: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdminAddProductScreen()),
          );
        },
        onViewOrders: () {
          setState(() => _selectedIndex = 0);
        },
        onLogout: () {
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: AppColors.primaryBackground,
        selectedItemColor: AppColors.productPrice,
        unselectedItemColor: AppColors.sectionTitle,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Órdenes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Productos',
          ),
        ],
      ),
    );
  }
}