import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/services/cloudinary_service.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/text_style.dart';

class AdminEditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const AdminEditProductScreen({super.key, required this.product});

  @override
  State<AdminEditProductScreen> createState() => _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends State<AdminEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _smallSizePriceController;
  late TextEditingController _largeSizePriceController;
  String? _selectedType;
  File? _selectedImage;
  bool _available = true;
  String? _imageUrl;
  String? _publicId;
  bool _isLoading = false;
  bool _hasSizes = false;

  final List<String> _types = [
    'bebidas calientes',
    'bebidas heladas',
    'comidas',
    'postres',
  ];

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product['name']);
    _priceController = TextEditingController(
      text: product['price'] != null ? product['price'].toString() : ''
    );
    _descriptionController = TextEditingController(text: product['description'] ?? '');
    _selectedType = product['category'];
    _available = product['available'] == true;
    _imageUrl = product['image_url'];
    _hasSizes = product['sizes'] != null;
    _smallSizePriceController = TextEditingController(
      text: product['sizes'] != null && product['sizes']['pequeño'] != null
          ? product['sizes']['pequeño'].toString()
          : ''
    );
    _largeSizePriceController = TextEditingController(
      text: product['sizes'] != null && product['sizes']['grande'] != null
          ? product['sizes']['grande'].toString()
          : ''
    );
    // extrae el public_id completo de Cloudinary
    if (_imageUrl != null && _imageUrl!.contains('/')) {
      final uri = Uri.parse(_imageUrl!);
      final path = uri.path;
      final publicIdWithExt = path.substring(1);
      final publicId = publicIdWithExt.replaceAll(RegExp(r'\.(jpg|jpeg|png|gif|webp)$'), '');
      _publicId = publicId;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _deleteOldImage() async {
    if (_publicId == null) return;
    final url = Uri.parse('http://localhost:3001/api/v1/cloudinary/delete');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'public_id': _publicId}),
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && _selectedType != null) {
      setState(() => _isLoading = true);

      String? imageUrl = _imageUrl;

      if (_selectedImage != null) {
        await _deleteOldImage();
        final folder = 'sabores_de_mi_casa/${_selectedType!.replaceAll(' ', '_')}';
        imageUrl = await CloudinaryService.uploadImageToBackend(_selectedImage!, folder);
        if (!mounted) return;
        if (imageUrl == null) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al subir imagen')),
          );
          return;
        }
      }

      Map<String, dynamic>? sizes;
      if (_hasSizes) {
        sizes = {};
        if (_smallSizePriceController.text.isNotEmpty) {
          sizes['pequeño'] = double.tryParse(_smallSizePriceController.text);
        }
        if (_largeSizePriceController.text.isNotEmpty) {
          sizes['grande'] = double.tryParse(_largeSizePriceController.text);
        }
      }

      final body = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'image_url': imageUrl,
        'category': _selectedType,
        'available': _available,
        'sizes': _hasSizes ? sizes : null,
      };
      if (!_hasSizes) {
        body['price'] = _priceController.text;
      }

      final url = Uri.parse('http://localhost:3001/api/v1/products/${widget.product['id']}');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      setState(() => _isLoading = false);

      if (!mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado')),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${jsonDecode(response.body)['error'] ?? 'No se pudo actualizar'}')),
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
        title: const Text('Editar Producto', style: AppTextStyle.sectionTitle),
        backgroundColor: AppColors.primaryBackground,
        iconTheme: const IconThemeData(color: AppColors.sectionTitle),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                decoration: _inputDecoration('Descripción (opcional)'),
                style: AppTextStyle.body,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                activeColor: AppColors.productPrice,
                inactiveThumbColor: AppColors.sectionTitle,
                title: Text('¿Editar tamaños?', style: AppTextStyle.body),
                value: _hasSizes,
                onChanged: (val) {
                  setState(() => _hasSizes = val);
                },
              ),
              if (_hasSizes) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _smallSizePriceController,
                  decoration: _inputDecoration('Precio Pequeño'),
                  style: AppTextStyle.body,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_hasSizes && (value == null || value.isEmpty)) {
                      return 'Ingrese el precio para tamaño pequeño';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _largeSizePriceController,
                  decoration: _inputDecoration('Precio Grande'),
                  style: AppTextStyle.body,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_hasSizes && (value == null || value.isEmpty)) {
                      return 'Ingrese el precio para tamaño grande';
                    }
                    return null;
                  },
                ),
              ] else ...[
                TextFormField(
                  controller: _priceController,
                  decoration: _inputDecoration('Precio'),
                  style: AppTextStyle.body,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
              ],
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
                label: const Text('Cambiar imagen', style: AppTextStyle.body),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_selectedImage!, height: 120),
                  ),
                )
              else if (_imageUrl != null && _imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_imageUrl!, height: 120),
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
                        child: const Text('Guardar cambios',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}