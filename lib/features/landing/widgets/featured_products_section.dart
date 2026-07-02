import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../providers/product_provider.dart';
import 'product_card.dart';
import 'section_label.dart';


class FeaturedProductsSection extends StatefulWidget {
  final GlobalKey sectionKey;

  const FeaturedProductsSection({super.key, required this.sectionKey});

  @override
  State<FeaturedProductsSection> createState() =>
      _FeaturedProductsSectionState();
}

class _FeaturedProductsSectionState extends State<FeaturedProductsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      key: widget.sectionKey,
      color: AppTheme.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section Header ───────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel(label: 'Featured Products')
                            .animate()
                            .fadeIn(delay: 100.ms)
                            .slideX(begin: -0.2),
                        const SizedBox(height: 12),
                        Text(
                          'Our Best Sellers',
                          style: Theme.of(context).textTheme.displaySmall,
                        )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideX(begin: -0.2),
                        const SizedBox(height: 8),
                        Text(
                          'Hand-picked top quality products loved by our customers',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ).animate().fadeIn(delay: 300.ms),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 52),

              // ── Products Grid ─────────────────────────────────────────────
              Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: CircularProgressIndicator(
                          color: AppTheme.primary,
                        ),
                      ),
                    );
                  }

                  if (provider.error != null) {
                    return _buildErrorState(provider);
                  }

                  final featured = provider.featuredProducts;
                  if (featured.isEmpty) {
                    return _buildEmptyState();
                  }

                  final crossAxis = isWide
                      ? (MediaQuery.of(context).size.width > 1100 ? 4 : 2)
                      : 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxis,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: featured.length,
                    itemBuilder: (_, i) => ProductCard(product: featured[i])
                        .animate()
                        .fadeIn(delay: (200 + i * 100).ms, duration: 500.ms)
                        .slideY(begin: 0.2, end: 0),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(ProductProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(
              Icons.wifi_off_outlined,
              size: 48,
              color: AppTheme.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load products.\nMake sure the backend server is running.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => provider.loadProducts(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Text('No featured products available.'),
      ),
    );
  }
}
