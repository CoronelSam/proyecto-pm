import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
import '../../components/profile_info_card.dart';
import '../../utils/user_session.dart';
import '../../services/user_service.dart';
import '../../components/dialog_edit_name.dart';
import '../../components/dialog_edit_phone.dart';
import '../../components/dialog_edit_password.dart';
import '../../components/dialog_edit_email.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? userId;
  String? userName;
  String? userEmail;
  String? userPhone;

  bool inboxMessages = false;
  bool orderNotifications = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final session = UserSession();
    userId = session.userId;
    userName = session.userName ?? '';
    userEmail = session.userEmail ?? '';
    userPhone = session.userPhone ?? '';
  }

  Future<void> _handleEditName() async {
    final nuevoNombre = await showEditNameDialog(context, userName!);
    if (nuevoNombre != null && nuevoNombre.isNotEmpty && nuevoNombre != userName) {
      setState(() => _isLoading = true);
      final result = await UserService.updateUser(
        userId: userId!,
        email: userEmail!,
        name: nuevoNombre,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['statusCode'] == 200) {
        setState(() => userName = result['body']['name']);
        final session = UserSession();
        session.userName = userName;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nombre actualizado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['body']['error'] ?? 'Error al actualizar')),
        );
      }
    }
  }

  Future<void> _handleEditPhone() async {
    final nuevoTelefono = await showEditPhoneDialog(context, userPhone!);
    if (nuevoTelefono != null && nuevoTelefono.isNotEmpty && nuevoTelefono != userPhone) {
      setState(() => _isLoading = true);
      final result = await UserService.updateUser(
        userId: userId!,
        email: userEmail!,
        phone: nuevoTelefono,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['statusCode'] == 200) {
        setState(() => userPhone = result['body']['phone']);
        final session = UserSession();
        session.userPhone = userPhone;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teléfono actualizado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['body']['error'] ?? 'Error al actualizar')),
        );
      }
    }
  }

  Future<void> _handleEditPassword() async {
    final result = await showEditPasswordDialog(context);
    if (!mounted) return;
    if (result == null) return;
    final currentPassword = result['currentPassword'] ?? '';
    final newPassword = result['newPassword'] ?? '';

    if (currentPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes completar ambos campos')),
      );
      return;
    }
    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener mínimo 6 caracteres')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final loginResponse = await UserService.login(
      email: userEmail!,
      password: currentPassword,
    );
    if (!mounted) return;
    if (loginResponse['statusCode'] != 200) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña actual es incorrecta')),
      );
      return;
    }

    final updateResult = await UserService.updatePassword(
      userId: userId!,
      password: newPassword,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (updateResult['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updateResult['body']['error'] ?? 'Error al actualizar')),
      );
    }
  }

  Future<void> _handleEditEmail() async {
    final nuevoEmail = await showEditEmailDialog(context, userEmail!);
    if (!mounted) return;
    if (nuevoEmail != null && nuevoEmail.isNotEmpty && nuevoEmail != userEmail) {
      // Validación básica de email
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(nuevoEmail)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El correo debe ser válido')),
        );
        return;
      }
      setState(() => _isLoading = true);
      final result = await UserService.updateUser(
        userId: userId!,
        email: nuevoEmail,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['statusCode'] == 200) {
        setState(() => userEmail = result['body']['email']);
        final session = UserSession();
        session.userEmail = userEmail;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo actualizado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['body']['error'] ?? 'Error al actualizar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                //ProfileHeader(userName: userName!),
                const SizedBox(height: 15),
                Text("Perfil", style: AppTextStyle.sectionTitle),
                const SizedBox(height: 15),
                Text("Información personal", style: AppTextStyle.productPrice),
                const SizedBox(height: 10),
                ProfileInfoCard(
                  icon: Icons.person,
                  title: "Usuario",
                  subtitle: userName!,
                ),
                ProfileInfoCard(
                  icon: Icons.email,
                  title: "Correo electrónico",
                  subtitle: userEmail!,
                ),
                ProfileInfoCard(
                  icon: Icons.phone,
                  title: "Número de teléfono",
                  subtitle: userPhone!,
                ),
                const SizedBox(height: 25),
                Text("Preferencias de notificación", style: AppTextStyle.productPrice),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text("Mensajes en la bandeja de entrada"),
                  activeColor: AppColors.greeting,
                  value: inboxMessages,
                  onChanged: (value) {
                    setState(() {
                      inboxMessages = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Notificaciones de órdenes"),
                  activeColor: AppColors.greeting,
                  value: orderNotifications,
                  onChanged: (value) {
                    setState(() {
                      orderNotifications = value!;
                    });
                  },
                ),
                const SizedBox(height: 25),
                Text("Política y seguridad", style: AppTextStyle.productPrice),
                const SizedBox(height: 10),
                ProfileInfoCard(
                  icon: Icons.person_outline,
                  title: "Cambiar nombre de usuario",
                  subtitle: "",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _handleEditName,
                ),
                ProfileInfoCard(
                  icon: Icons.email_outlined,
                  title: "Cambiar correo electrónico",
                  subtitle: "",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _handleEditEmail,
                ),
                ProfileInfoCard(
                  icon: Icons.phone_android,
                  title: "Cambiar número de teléfono",
                  subtitle: "",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _handleEditPhone,
                ),
                ProfileInfoCard(
                  icon: Icons.lock,
                  title: "Cambiar contraseña",
                  subtitle: "",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _handleEditPassword,
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha((0.2 * 255).toInt()),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
