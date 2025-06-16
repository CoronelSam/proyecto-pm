import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:frontend/services/cloudinary_service.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/text_style.dart';

class AdminAddProductScreen extends StatefulWidget {
  const AdminAddProductScreen({super.key});

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedType;
  File? _selectedImage;
  bool _available = true;

  final List<String> _types = [
    'bebidas calientes',
    'bebidas heladas',
    'comidas',
    'postres',
  ];

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && _selectedImage != null && _selectedType != null) {
      setState(() => _isLoading = true);

      final folder = 'sabores_de_mi_casa/${_selectedType!.replaceAll(' ', '_')}';
      final imageUrl = await CloudinaryService.uploadImageToBackend(_selectedImage!, folder);
      if (!mounted) return;
      if (imageUrl == null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir imagen')),
        );
        return;
      }

      final url = Uri.parse('http://localhost:3001/api/v1/products');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'price': _priceController.text,
          'description': _descriptionController.text,
          'image_url': imageUrl,
          'category': _selectedType,
          'available': _available,
        }),
      );

      setState(() => _isLoading = false);

      if (!mounted) return;
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto agregado')),
        );
        _formKey.currentState!.reset();
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedImage = null;
          _selectedType = null;
          _available = true;
        });
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${jsonDecode(response.body)['error'] ?? 'No se pudo agregar'}')),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyle.body.copyWith(color: AppColors.sectionTitle),
      filled: true,
      fillColor: AppColors.productCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryBackground),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.sectionTitle, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Agregar Producto', style: AppTextStyle.sectionTitle),
        backgroundColor: AppColors.primaryBackground,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: AppColors.sectionTitle),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Nuevo producto',
                style: AppTextStyle.title.copyWith(color: AppColors.sectionTitle),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type, style: AppTextStyle.body),
                )).toList(),
                onChanged: (value) => setState(() => _selectedType = value),
                decoration: _inputDecoration('Tipo de producto'),
                validator: (value) => value == null ? 'Seleccione un tipo' : null,
                dropdownColor: AppColors.productCard,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nombre del producto'),
                style: AppTextStyle.body,
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Descripción (Opcional)'),
                style: AppTextStyle.body,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: _inputDecoration('Precio'),
                style: AppTextStyle.body,
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _available,
                    activeColor: AppColors.productPrice,
                    onChanged: (value) {
                      setState(() {
                        _available = value ?? true;
                      });
                    },
                  ),
                  Text('Disponible', style: AppTextStyle.body),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBackground,
                  foregroundColor: AppColors.sectionTitle,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Seleccionar imagen', style: AppTextStyle.body),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_selectedImage!, height: 120),
                  ),
                ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.productPrice,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _saveProduct,
                        child: const Text('Guardar producto', style: AppTextStyle.sectionTitle),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}