import 'package:flutter/material.dart';
import 'package:frontend/utils/user_session.dart';
import 'package:frontend/components/admin_drawer.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/text_style.dart';
import 'admin_add_product_screen.dart';
import 'admin_orders_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
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
        title: const Text(
          'Panel de Administrador',
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
          );
        },
        onLogout: () {
          // Lógica de logout
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add_box, color: AppColors.productPrice),
              label: const Text(
                'Agregar Producto',
                style: AppTextStyle.body,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBackground,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminAddProductScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.list_alt, color: AppColors.productPrice),
              label: const Text(
                'Ver Pedidos Realizados',
                style: AppTextStyle.body,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBackground,
                foregroundColor: AppColors.productPrice,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}