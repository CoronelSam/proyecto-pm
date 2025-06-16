import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/text_style.dart';

class AdminDrawer extends StatelessWidget {
  final VoidCallback onAddProduct;
  final VoidCallback onViewOrders;
  final VoidCallback onLogout;

  const AdminDrawer({
    super.key,
    required this.onAddProduct,
    required this.onViewOrders,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Panel de Administrador',
                  style: AppTextStyle.sectionTitle,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_box, color: AppColors.productPrice),
            title: const Text('Agregar Producto', style: AppTextStyle.body),
            onTap: () {
              Navigator.pop(context);
              onAddProduct();
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt, color: AppColors.productPrice),
            title: const Text('Ver Pedidos', style: AppTextStyle.body),
            onTap: () {
              Navigator.pop(context);
              onViewOrders();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Cerrar sesión', style: AppTextStyle.body),
            onTap: () {
              Navigator.pop(context);
              onLogout();
            },
          ),
        ],
      ),
    );
  }
}