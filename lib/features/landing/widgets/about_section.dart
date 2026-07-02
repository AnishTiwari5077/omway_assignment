import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import 'section_label.dart';


class AboutSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const AboutSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      key: sectionKey,
      color: AppTheme.surfaceVariant,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: _buildVisual()),
                    const SizedBox(width: 80),
                    Expanded(flex: 6, child: _buildContent(context)),
                  ],
                )
              : Column(
                  children: [
                    _buildContent(context),
                    const SizedBox(height: 60),
                    _buildVisual(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(label: 'About Us')
            .animate()
            .fadeIn(delay: 100.ms)
            .slideX(begin: -0.2),
        const SizedBox(height: 16),
        Text(
          'Delivering Health,\nBuilding Trust',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
        const SizedBox(height: 20),
        Text(
          'MediCare Pharmacy has been serving communities for over 15 years with a commitment to quality, affordability, and care. We partner with certified manufacturers to bring you genuine medicines and health supplements.',
          style: Theme.of(context).textTheme.bodyLarge,
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 16),
        Text(
          'Our licensed pharmacists are available 24/7 to answer questions, review prescriptions, and provide personalized health guidance so you can make informed decisions.',
          style: Theme.of(context).textTheme.bodyLarge,
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 36),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _buildFeature(Icons.verified_outlined, 'Certified Products'),
            _buildFeature(Icons.local_shipping_outlined, 'Fast Delivery'),
            _buildFeature(Icons.support_agent_outlined, '24/7 Support'),
            _buildFeature(Icons.lock_outlined, 'Secure Payments'),
          ],
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.primary, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisual() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('15+', 'Years of Experience', Icons.timeline, AppTheme.primary)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('500+', 'Products Available', Icons.inventory_2_outlined, AppTheme.primaryLight)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('50K+', 'Happy Customers', Icons.people_outline, AppTheme.accent)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('24/7', 'Pharmacist Support', Icons.headset_mic_outlined, AppTheme.warning)),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 700.ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

