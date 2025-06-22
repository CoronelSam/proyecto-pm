import 'package:flutter/material.dart';

String getStatusText(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
    case 'pendiente':
      return 'Pendiente';
    case 'en preparacion':
    case 'en preparación':
      return 'En preparación';
    case 'listo':
      return 'Listo';
    default:
      return 'Desconocido';
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
    case 'pendiente':
      return Colors.orange;
    case 'en preparacion':
    case 'en preparación':
      return Colors.blue;
    case 'listo':
      return Colors.green;
    default:
      return Colors.grey;
  }
}