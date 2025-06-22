import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
import '../../utils/order_utils.dart';

class TrackerOrderScreen extends StatefulWidget {
  final int orderId;

  const TrackerOrderScreen({super.key, required this.orderId});

  @override
  State<TrackerOrderScreen> createState() => _TrackerOrderScreenState();
}

class _TrackerOrderScreenState extends State<TrackerOrderScreen> {
  late io.Socket socket;
  String orderStatus = 'pendiente';
  final Logger _logger = Logger('TrackerOrderScreen');

  final List<String> statusKeys = [
    'pendiente',
    'en preparacion',
    'listo',
  ];

  @override
  void initState() {
    super.initState();
    _fetchOrderStatus();
    _connectSocket();
  }

  Future<void> _fetchOrderStatus() async {
    final url = Uri.parse('http://localhost:3001/api/v1/orders/${widget.orderId}/status');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (kDebugMode) {
        _logger.info('Respuesta de la orden: $data');
      }
      setState(() {
        orderStatus = data['status'] ?? 'pendiente';
      });
    }
  }

  void _connectSocket() {
    socket = io.io(
      'http://localhost:3001',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();

    socket.onConnect((_) {
      socket.emit('joinOrderRoom', widget.orderId);
    });

    socket.on('orderStatusChanged', (data) {
      if (mounted && data['orderId'] == widget.orderId) {
        setState(() {
          orderStatus = data['status'];
        });
      }
    });

    socket.onDisconnect((_) => _logger.warning('Socket desconectado'));
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  int getCurrentStep() {
    return statusKeys.indexWhere((key) => key == orderStatus);
  }

  @override
  Widget build(BuildContext context) {
    int currentStep = getCurrentStep();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sectionTitle,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.coffee, size: 60, color: AppColors.sectionTitle),
                const SizedBox(height: 16),
                Text(
                  'Estado de tu orden #${widget.orderId}:',
                  style: AppTextStyle.title.copyWith(color: AppColors.sectionTitle),
                ),
                const SizedBox(height: 8),
                Text(
                  getStatusText(orderStatus),
                  style: AppTextStyle.body.copyWith(
                    color: getStatusColor(orderStatus),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Column(
                  children: List.generate(statusKeys.length, (index) {
                    final key = statusKeys[index];
                    final label = getStatusText(key);
                    final color = getStatusColor(key);
                    final isActive = index == currentStep;
                    final isCompleted = index < currentStep;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Punto de estado
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isActive
                                ? color
                                : isCompleted
                                    ? color.withAlpha(128)
                                    : Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? color
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: (isCompleted || isActive)
                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                              : null,
                        ),
                        if (index < statusKeys.length - 1)
                          Container(
                            width: 4,
                            height: 40,
                            color: isCompleted
                                ? color.withAlpha(128)
                                : Colors.grey[300],
                          ),
                        const SizedBox(width: 16),
                        // Mensaje de estado
                        Expanded(
                          child: Text(
                            label,
                            style: AppTextStyle.body.copyWith(
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive
                                  ? color
                                  : isCompleted
                                      ? color.withAlpha(178)
                                      : Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}