import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../services/order_service.dart';
import '../../utils/app_colors.dart';
import '../../components/admin_order_card.dart';
import '../../utils/order_utils.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  late Future<List<dynamic>> _ordersFuture;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrderService.fetchAllOrders();
    _selectedDate = DateTime.now();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.sectionTitle,
              onPrimary: Colors.white,
              onSurface: AppColors.sectionTitle,
              surface: AppColors.scaffoldBackground,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.scaffoldBackground),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateOrderStatus(int orderId, String newStatus) async {
    final url = Uri.parse('http://localhost:3001/api/v1/orders/$orderId/status');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: '{"status": "$newStatus"}',
    );
    if (!mounted) return;
    if (response.statusCode == 200) {
      setState(() {
        _ordersFuture = OrderService.fetchAllOrders();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el estado: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'es');
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sectionTitle,
        elevation: 0,
        title: const Text(
          'Órdenes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _pickDate(context),
            tooltip: 'Seleccionar fecha',
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  const Text(
                    'No hay órdenes registradas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          final orders = snapshot.data!;
          final selected = _selectedDate ?? DateTime.now();
          final filteredOrders = orders.where((order) {
            final createdAt = order['created_at'];
            if (createdAt == null) return false;
            final date = DateTime.tryParse(createdAt);
            if (date == null) return false;
            return date.year == selected.year && date.month == selected.month && date.day == selected.day;
          }).toList();

          if (filteredOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'No hay órdenes para el ${dateFormat.format(selected)}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.sectionTitle),
                    const SizedBox(width: 8),
                    Text(
                      'Órdenes para el ${dateFormat.format(selected)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.sectionTitle,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return AdminOrderCard(
                      order: order,
                      dateFormat: dateFormat,
                      getStatusText: getStatusText,
                      getStatusColor: getStatusColor,
                      onStatusChanged: (newStatus) {
                        _updateOrderStatus(order['id'], newStatus);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}