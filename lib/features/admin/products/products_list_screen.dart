import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../models/product.dart';
import '../../../providers/product_provider.dart';
import 'product_form_screen.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Toolbar ──────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _openForm(context, null),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Product'),
              ),
            ],
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 20),

          // ── Table ────────────────────────────────────────────────────────
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (_, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  );
                }

                final products = provider.products
                    .where(
                      (p) => p.name.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ),
                    )
                    .toList();

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SingleChildScrollView(
                      child: products.isEmpty
                          ? _buildEmpty()
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 800,
                                      maxWidth: constraints.maxWidth > 800
                                          ? constraints.maxWidth
                                          : 800,
                                    ),
                                    child: Column(
                                      children: [
                                        _buildTableHeader(),
                                        ...products
                                            .asMap()
                                            .entries
                                            .map(
                                              (e) => _buildRow(
                                                context,
                                                e.value,
                                                provider,
                                                e.key,
                                              ),
                                            ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceVariant,
        border: Border(bottom: BorderSide(color: AppTheme.divider)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 56),
          Expanded(
            flex: 3,
            child: _headerText('Product Name'),
          ),
          Expanded(flex: 2, child: _headerText('Category')),
          Expanded(flex: 1, child: _headerText('Price')),
          Expanded(flex: 1, child: _headerText('Stock')),
          Expanded(flex: 1, child: _headerText('Featured')),
          const SizedBox(width: 100),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppTheme.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    Product product,
    ProductProvider provider,
    int index,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: const Border(bottom: BorderSide(color: AppTheme.divider)),
        color: index.isOdd ? AppTheme.surface : Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppTheme.accentLight,
                  child: const Icon(
                    Icons.medication_outlined,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name
          Expanded(
            flex: 3,
            child: Text(
              product.name,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          // Category
          Expanded(
            flex: 2,
            child: Chip(
              label: Text(product.category),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
          // Price
          Expanded(
            flex: 1,
            child: Text(
              '₹${product.price.toStringAsFixed(0)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          // Stock
          Expanded(
            flex: 1,
            child: Text(
              '${product.stock}',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: product.stock > 0 ? AppTheme.success : AppTheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Featured
          Expanded(
            flex: 1,
            child: Icon(
              product.isFeatured
                  ? Icons.star
                  : Icons.star_border,
              color: product.isFeatured ? AppTheme.warning : AppTheme.textMuted,
              size: 20,
            ),
          ),
          // Actions
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _openForm(context, product),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppTheme.info,
                    size: 20,
                  ),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, product, provider),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.error,
                    size: 20,
                  ),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 56,
              color: AppTheme.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, Product? product) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(existingProduct: product),
      ),
    );
    if (result == true && context.mounted) {
      context.read<ProductProvider>().loadProducts();
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Product product,
    ProductProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Product',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete "${product.name}"? This cannot be undone.',
          style: GoogleFonts.inter(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await provider.deleteProduct(product.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} deleted'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    }
  }
}
