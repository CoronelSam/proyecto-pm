import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
import '../../components/category_navbar.dart'; // Asegúrate de importar el widget

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 0;

  final List<String> _tabs = [
    'Bebidas Calientes',
    'Bebidas Heladas',
    'Comida',
    'Postres',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        title: Text('Ordenar', style: AppTextStyle.title),
      ),
      body: Column(
        children: [
          CategoryNavbar(
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                _tabs[_selectedIndex],
                style: AppTextStyle.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}