import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

class HeroSection extends StatelessWidget {
  final GlobalKey sectionKey;
  final VoidCallback onShopNow;
  final VoidCallback onContact;

  const HeroSection({
    super.key,
    required this.sectionKey,
    required this.onShopNow,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 768;

    return Container(
      key: sectionKey,
      constraints: BoxConstraints(minHeight: size.height),
      decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
      child: Stack(
        children: [
          // ── Decorative circles ────────────────────────────────────────────
          Positioned(
            right: -80,
            top: 80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            left: -60,
            bottom: 60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            right: 120,
            bottom: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // ── Main Content ──────────────────────────────────────────────────
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 64 : 24,
                  120,
                  isWide ? 64 : 24,
                  80,
                ),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 6, child: _buildTextContent(context)),
                          const SizedBox(width: 60),
                          Expanded(flex: 4, child: _buildHeroVisual()),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTextContent(context),
                          const SizedBox(height: 48),
                          _buildHeroVisual(),
                        ],
                      ),
              ),
            ),
          ),

          // ── Scroll indicator ──────────────────────────────────────────────
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Scroll to explore',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white54,
                    size: 24,
                  ),
                ],
              )
                  .animate(onPlay: (c) => c.repeat())
                  .fadeIn(duration: 800.ms)
                  .then()
                  .fadeOut(duration: 800.ms, delay: 600.ms),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, color: Colors.white, size: 14),
              const SizedBox(width: 6),
              Text(
                'Trusted by 50,000+ customers',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 24),

        // Main Headline
        Text(
          'Your Trusted\nHealth Partner',
          style: GoogleFonts.inter(
            fontSize: MediaQuery.of(context).size.width > 768 ? 62 : 42,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -2,
            height: 1.1,
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 700.ms)
            .slideX(begin: -0.3, end: 0),

        const SizedBox(height: 20),

        // Subtitle
        Text(
          'Premium quality medicines, supplements, and healthcare products delivered right to your doorstep. Experience healthcare the modern way.',
          style: GoogleFonts.inter(
            fontSize: 17,
            color: Colors.white.withOpacity(0.85),
            height: 1.65,
            fontWeight: FontWeight.w400,
          ),
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 600.ms)
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 40),

        // CTA Buttons
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: onShopNow,
              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
              label: const Text('Shop Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                textStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onContact,
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('Contact Us'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white60, width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 800.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 56),

        // Stats Row
        _buildStatsRow()
            .animate()
            .fadeIn(delay: 1000.ms, duration: 700.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      ('15+', 'Years of Trust'),
      ('500+', 'Products'),
      ('50K+', 'Customers'),
      ('24/7', 'Support'),
    ];

    return Wrap(
      spacing: 32,
      runSpacing: 20,
      children: stats.map((s) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.$1,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              s.$2,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHeroVisual() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Floating product cards
          _buildFloatingCard(
            Icons.medication_outlined,
            'Pain Relief',
            '₹25 – ₹450',
            AppTheme.accent,
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 16),
          _buildFloatingCard(
            Icons.favorite_outline,
            'Health Supplements',
            '₹120 – ₹500',
            Colors.pinkAccent,
          ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 16),
          _buildFloatingCard(
            Icons.local_shipping_outlined,
            'Free Delivery',
            'On orders above ₹499',
            Colors.amberAccent,
          ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3, end: 0),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 500.ms, duration: 700.ms)
        .slideX(begin: 0.3, end: 0);
  }

  Widget _buildFloatingCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
