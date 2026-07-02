import 'package:flutter/material.dart';
import '../../core/constants.dart';
import 'widgets/header_widget.dart';
import 'widgets/hero_section.dart';
import 'widgets/about_section.dart';
import 'widgets/featured_products_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/footer_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _sectionKeys = {
    AppConstants.heroSection: GlobalKey(),
    AppConstants.aboutSection: GlobalKey(),
    AppConstants.productsSection: GlobalKey(),
    AppConstants.testimonialsSection: GlobalKey(),
    AppConstants.contactSection: GlobalKey(),
  };

  void _scrollToSection(String key) {
    final ctx = _sectionKeys[key]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Main scrollable content ──────────────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero (includes the header's space)
                HeroSection(
                  sectionKey: _sectionKeys[AppConstants.heroSection]!,
                  onShopNow: () =>
                      _scrollToSection(AppConstants.productsSection),
                  onContact: () =>
                      _scrollToSection(AppConstants.contactSection),
                ),
                AboutSection(
                  sectionKey: _sectionKeys[AppConstants.aboutSection]!,
                ),
                FeaturedProductsSection(
                  sectionKey: _sectionKeys[AppConstants.productsSection]!,
                ),
                TestimonialsSection(
                  sectionKey: _sectionKeys[AppConstants.testimonialsSection]!,
                ),
                ContactSection(
                  sectionKey: _sectionKeys[AppConstants.contactSection]!,
                ),
                FooterWidget(
                  onNavigate: (path) {
                    if (path == '/admin') {
                      Navigator.of(context).pushNamed('/admin');
                    } else if (_sectionKeys.containsKey(path)) {
                      _scrollToSection(path);
                    } else if (path == '/') {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // ── Sticky Header (overlay) ──────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HeaderWidget(
              scrollController: _scrollController,
              sectionKeys: _sectionKeys,
            ),
          ),
        ],
      ),
    );
  }
}
