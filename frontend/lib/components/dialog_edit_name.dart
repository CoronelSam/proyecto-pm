import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

Future<String?> showEditNameDialog(BuildContext context, String currentName) {
  String nuevoNombre = currentName;
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cambiar nombre de usuario'),
        content: TextField(
          decoration: const InputDecoration(hintText: "Nuevo nombre"),
          controller: TextEditingController(text: currentName),
          onChanged: (value) {
            nuevoNombre = value;
          },
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
              Navigator.pop(context, nuevoNombre.trim());
            },
            child: const Text("Guardar"),
          ),
        ],
      );
    },
  );
}