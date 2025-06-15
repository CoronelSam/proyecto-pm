import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onSelectPage;
  final VoidCallback onLogout;
  final String userName;
  final String userEmail;

  const AppDrawer({
    super.key,
    required this.onSelectPage,
    required this.onLogout,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(userEmail, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Ver perfil'),
            onTap: () {
              Navigator.pop(context);
              onSelectPage(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Menú'),
            onTap: () {
              Navigator.pop(context);
              onSelectPage(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial de transacciones'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
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