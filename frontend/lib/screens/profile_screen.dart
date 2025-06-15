import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Datos simulados del usuario
  String userName = "Emily Cruz";
  final String userEmail = "emily@example.com";
  String userPhone = "+504 9876-5432";

  // Estado de las preferencias
  bool inboxMessages = true;
  bool orderNotifications = false;

  void _cambiarNombreUsuario() {
    showDialog(
      context: context,
      builder: (context) {
        String nuevoNombre = userName;
        return AlertDialog(
          title: const Text('Cambiar nombre de usuario'),
          content: TextField(
            decoration: const InputDecoration(hintText: "Nuevo nombre"),
            onChanged: (value) {
              nuevoNombre = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37),
              ),
              onPressed: () {
                setState(() {
                  userName = nuevoNombre;
                });
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _cambiarTelefono() {
    showDialog(
      context: context,
      builder: (context) {
        String nuevoTelefono = userPhone;
        return AlertDialog(
          title: const Text('Cambiar número de teléfono'),
          content: TextField(
            decoration: const InputDecoration(hintText: "Nuevo número"),
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              nuevoTelefono = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37),
              ),
              onPressed: () {
                setState(() {
                  userPhone = nuevoTelefono;
                });
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6F4E37),
        title: const Text('Cuenta', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF6F4E37),
                    child: const Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Perfil",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6F4E37),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Información personal",
              style: TextStyle(fontSize: 16, color: Color(0xFF795548)),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.person, color: Color(0xFF6F4E37)),
                title: const Text("Usuario"),
                subtitle: Text(userName),
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.email, color: Color(0xFF6F4E37)),
                title: const Text("Correo electrónico"),
                subtitle: Text(userEmail),
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Color(0xFF6F4E37)),
                title: const Text("Número de teléfono"),
                subtitle: Text(userPhone),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Preferencias de notificación",
              style: TextStyle(fontSize: 16, color: Color(0xFF795548)),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text("Mensajes en la bandeja de entrada"),
              activeColor: const Color(0xFF6F4E37),
              value: inboxMessages,
              onChanged: (value) {
                setState(() {
                  inboxMessages = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Notificaciones de órdenes"),
              activeColor: const Color(0xFF6F4E37),
              value: orderNotifications,
              onChanged: (value) {
                setState(() {
                  orderNotifications = value!;
                });
              },
            ),
            const SizedBox(height: 25),
            const Text(
              "Política y seguridad",
              style: TextStyle(fontSize: 16, color: Color(0xFF795548)),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.lock, color: Color(0xFF6F4E37)),
                title: const Text("Cambiar contraseña"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Función de cambio de contraseña no implementada")),
                  );
                },
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.person_outline, color: Color(0xFF6F4E37)),
                title: const Text("Cambiar nombre de usuario"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _cambiarNombreUsuario,
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.phone_android, color: Color(0xFF6F4E37)),
                title: const Text("Cambiar número de teléfono"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _cambiarTelefono,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
