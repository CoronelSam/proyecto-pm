import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

Future<String?> showEditEmailDialog(BuildContext context, String currentEmail) {
  String nuevoEmail = currentEmail;
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cambiar correo electrónico'),
        content: TextField(
          decoration: const InputDecoration(hintText: "Nuevo correo"),
          controller: TextEditingController(text: currentEmail),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            nuevoEmail = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greeting,
              foregroundColor: Colors.black
            ),
            onPressed: () {
              Navigator.pop(context, nuevoEmail.trim());
            },
            child: const Text(
              "Guardar"
            ),
          ),
        ],
      );
    },
  );
}