import 'package:flutter/material.dart';
import 'package:frontend/screens/user/user_receipts_screen.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 95,
                    width: 95,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            leading: const Icon(Icons.receipt_long),
            title: const Text('Historial de Ordenes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UserReceiptsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                const Text(
                  'Síguenos en:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook, color: Colors.blue),
                      onPressed: () {
                        launchUrl(Uri.parse('https://www.facebook.com/share/1C9xzY81Pi/?mibextid=wwXIfr'));
                      },
                    ),
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return AppColors.instagramGradient.createShader(bounds);
                      },
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () {
                          launchUrl(Uri.parse('https://www.instagram.com/saboresdemicasa_'));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
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