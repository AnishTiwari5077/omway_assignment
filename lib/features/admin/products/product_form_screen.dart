import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../models/product.dart';
import '../../../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? existingProduct;

  const ProductFormScreen({super.key, this.existingProduct});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _imageCtrl;
  late final TextEditingController _stockCtrl;
  String _category = AppConstants.productCategories.first;
  bool _isFeatured = false;
  bool _saving = false;

  bool get _isEditing => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _priceCtrl =
        TextEditingController(text: p != null ? p.price.toString() : '');
    _imageCtrl = TextEditingController(text: p?.imageUrl ?? '');
    _stockCtrl =
        TextEditingController(text: p != null ? p.stock.toString() : '');
    _category = p?.category ?? AppConstants.productCategories.first;
    _isFeatured = p?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final product = Product(
      id: widget.existingProduct?.id ?? '',
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
      category: _category,
      imageUrl: _imageCtrl.text.trim(),
      isFeatured: _isFeatured,
      stock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
    );

    final provider = context.read<ProductProvider>();
    bool success;

    if (_isEditing) {
      success = await provider.updateProduct(widget.existingProduct!.id, product);
    } else {
      success = await provider.createProduct(product);
    }

    setState(() => _saving = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Product updated!' : 'Product created!'),
            backgroundColor: AppTheme.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save. Check backend connection.'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Product' : 'Add New Product',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save_outlined, size: 18),
              label: Text(_saving ? 'Saving...' : 'Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('Basic Information', [
                    _buildField(
                      controller: _nameCtrl,
                      label: 'Product Name *',
                      hint: 'e.g., Paracetamol 500mg',
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _descCtrl,
                      label: 'Description *',
                      hint: 'Describe the product...',
                      maxLines: 4,
                      validator: (v) =>
                          v!.length < 10 ? 'Too short (min 10 chars)' : null,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('Pricing & Inventory', [
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: _priceCtrl,
                            label: 'Price (₹) *',
                            hint: '0.00',
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v!.isEmpty) return 'Required';
                              if (double.tryParse(v) == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField(
                            controller: _stockCtrl,
                            label: 'Stock Quantity *',
                            hint: '0',
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v!.isEmpty) return 'Required';
                              if (int.tryParse(v) == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('Category & Visibility', [
                    DropdownButtonFormField<String>(
                      value: _category,
                      items: AppConstants.productCategories
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _category = v!),
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                        prefixIcon: Icon(
                          Icons.category_outlined,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Featured Product',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                'Show on homepage featured section',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: _isFeatured,
                            onChanged: (v) => setState(() => _isFeatured = v),
                            activeThumbColor: AppTheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('Product Image', [
                    _buildField(
                      controller: _imageCtrl,
                      label: 'Image URL *',
                      hint: 'https://...',
                      validator: (v) =>
                          v!.isEmpty ? 'Required' : null,
                    ),
                    if (_imageCtrl.text.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _imageCtrl.text,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            color: AppTheme.surfaceVariant,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: const Icon(Icons.save_outlined, size: 18),
                        label: Text(
                          _isEditing ? 'Update Product' : 'Create Product',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}
