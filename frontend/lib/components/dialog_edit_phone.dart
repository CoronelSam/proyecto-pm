import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

Future<String?> showEditPhoneDialog(BuildContext context, String currentPhone) {
  String nuevoTelefono = currentPhone;
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cambiar número de teléfono'),
        content: TextField(
          decoration: const InputDecoration(hintText: "Nuevo número"),
          keyboardType: TextInputType.phone,
          controller: TextEditingController(text: currentPhone),
          onChanged: (value) {
            nuevoTelefono = value;
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
              Navigator.pop(context, nuevoTelefono.trim());
            },
            child: const Text("Guardar"),
          ),
        ],
      );
    },
  );
}