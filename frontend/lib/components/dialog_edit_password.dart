import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

Future<Map<String, String>?> showEditPasswordDialog(BuildContext context) {
  String currentPassword = '';
  String newPassword = '';
  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(hintText: "Contraseña actual"),
              onChanged: (value) {
                currentPassword = value;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(hintText: "Nueva contraseña"),
              onChanged: (value) {
                newPassword = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greeting,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, {
                'currentPassword': currentPassword,
                'newPassword': newPassword,
              });
            },
            child: const Text("Guardar"),
          ),
        ],
      );
    },
  );
}