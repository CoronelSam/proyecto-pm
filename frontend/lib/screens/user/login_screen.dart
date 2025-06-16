import 'package:flutter/material.dart';
import 'package:frontend/screens/user/register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/user_session.dart';
import '../../utils/text_style.dart';
import '../../utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse('http://localhost:3001/api/v1/users/login');
      final body = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      };

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          final resp = jsonDecode(response.body);
          // Guarda los datos del usuario en la sesión
          final user = resp['user'];
          UserSession()
            ..userId = user['id']
            ..userName = user['name']
            ..userEmail = user['email']
            ..userPhone = user['phone']
            ..userRole = user['role'];

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inicio de sesión exitoso')),
          );
          if (user['role'] == 'admin') {
            Navigator.of(context).pushReplacementNamed('/adminHome');
          } else {
            Navigator.of(context).pushReplacementNamed('/userHome');
          }
        } else {
          final resp = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(resp['error'] ?? 'Error al iniciar sesión')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de conexión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Iniciar sesión', style: AppTextStyle.title),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Bienvenido de nuevo',
                style: AppTextStyle.greeting,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: AppTextStyle.body,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: AppColors.primaryBackground,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El correo es requerido';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'El correo debe ser válido';
                  }
                  if (value.length > 255) {
                    return 'El correo no debe superar los 255 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: AppTextStyle.body,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: AppColors.primaryBackground,
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es requerida';
                  }
                  if (value.length < 6 || value.length > 255) {
                    return 'La contraseña debe tener mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sectionTitle,
                        foregroundColor: Colors.white,
                        textStyle: AppTextStyle.banner,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _login,
                      child: const Text('Iniciar sesión'),
                    ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿No tienes una cuenta?', style: AppTextStyle.body),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Regístrate', style: TextStyle(
                      color: Colors.blueAccent, 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}