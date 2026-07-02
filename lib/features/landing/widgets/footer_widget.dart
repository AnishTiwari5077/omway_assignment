import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

import '../../../core/constants.dart';

class FooterWidget extends StatelessWidget {
  final void Function(String) onNavigate;

  const FooterWidget({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      color: AppTheme.textPrimary,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 60,
      ),
      child: Column(
        children: [
          // ── Main Footer Content ────────────────────────────────────────
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildBrand()),
                    const SizedBox(width: 40),
                    Expanded(flex: 2, child: _buildLinks('Quick Links', _quickLinks)),
                    const SizedBox(width: 40),
                    Expanded(flex: 2, child: _buildLinks('Categories', _categories)),
                    const SizedBox(width: 40),
                    Expanded(flex: 3, child: _buildNewsletter()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBrand(),
                    const SizedBox(height: 40),
                    _buildLinks('Quick Links', _quickLinks),
                    const SizedBox(height: 32),
                    _buildLinks('Categories', _categories),
                    const SizedBox(height: 32),
                    _buildNewsletter(),
                  ],
                ),

          const SizedBox(height: 48),
          const Divider(color: Colors.white12),
          const SizedBox(height: 24),

          // ── Bottom Bar ─────────────────────────────────────────────────
          isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '© 2024 MediCare Pharmacy. All rights reserved.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white38,
                      ),
                    ),
                    Row(
                      children: ['Privacy Policy', 'Terms of Service', 'Cookie Policy']
                          .map(
                            (t) => Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Text(
                                t,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white38,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Text(
                      '© 2024 MediCare Pharmacy. All rights reserved.',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.white38),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.local_pharmacy,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'MediCare',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Your trusted health partner, delivering genuine medicines and supplements with care, speed, and expertise.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white54,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildSocialIcon(Icons.language, 'Web'),
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.facebook_outlined, 'FB'),
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.camera_alt_outlined, 'IG'),
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.tiktok, 'TK'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white54, size: 18),
    );
  }

  Widget _buildLinks(String title, List<Map<String, String>> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (link) => InkWell(
            onTap: () {
              if (link['path'] != null) {
                onNavigate(link['path']!);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 4, right: 20),
              child: Text(
                link['label']!,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white54),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsletter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stay Updated',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Subscribe to get health tips, special offers, and new product alerts.',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white54, height: 1.5),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Your email',
                  hintStyle: GoogleFonts.inter(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ),
          ],
        ),
      ],
    );
  }

  static const List<Map<String, String>> _quickLinks = [
    {'label': 'Home', 'path': '/'},
    {'label': 'About Us', 'path': AppConstants.aboutSection},
    {'label': 'Products', 'path': AppConstants.productsSection},
    {'label': 'Testimonials', 'path': AppConstants.testimonialsSection},
    {'label': 'Contact', 'path': AppConstants.contactSection},
    {'label': 'Admin Panel', 'path': '/admin'},
  ];

  static const List<Map<String, String>> _categories = [
    {'label': 'Pain Relief', 'path': AppConstants.productsSection},
    {'label': 'Vitamins', 'path': AppConstants.productsSection},
    {'label': 'Supplements', 'path': AppConstants.productsSection},
    {'label': 'First Aid', 'path': AppConstants.productsSection},
    {'label': 'Cough & Cold', 'path': AppConstants.productsSection},
    {'label': 'Skin Care', 'path': AppConstants.productsSection},
  ];
}
