import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../../core/constants.dart';


class HeaderWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;

  const HeaderWidget({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool _isScrolled = false;
  String _activeSection = AppConstants.heroSection;

  static const List<_NavItem> _navItems = [
    _NavItem('Home', AppConstants.heroSection),
    _NavItem('About', AppConstants.aboutSection),
    _NavItem('Products', AppConstants.productsSection),
    _NavItem('Testimonials', AppConstants.testimonialsSection),
    _NavItem('Contact', AppConstants.contactSection),
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = widget.scrollController.offset > 50;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  void _scrollToSection(String key) {
    final ctx = widget.sectionKeys[key]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      setState(() => _activeSection = key);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isScrolled
            ? AppTheme.surface.withValues(alpha: 0.97)
            : Colors.transparent,
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: AppTheme.shadow,
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16, vertical: 16),
          child: Row(
            children: [
              // ── Logo ──────────────────────────────────────────────────────
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: _buildLogo(),
                ),
              ),
              const SizedBox(width: 8),

              // ── Nav Items (desktop) ───────────────────────────────────────
              if (isWide) ...[
                Row(
                  children: _navItems
                      .map((item) => _buildNavItem(item))
                      .toList(),
                ),
                const SizedBox(width: 24),
              ],

              // ── Admin CTA ─────────────────────────────────────────────────
              _buildAdminButton(context, isWide),

              // ── Mobile Menu ───────────────────────────────────────────────
              if (!isWide) ...[
                const SizedBox(width: 8),
                _buildMobileMenu(context),
              ],
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        Text(
          'MediCare',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _isScrolled ? AppTheme.primary : Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(_NavItem item) {
    final isActive = _activeSection == item.key;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => _scrollToSection(item.key),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: _isScrolled
                    ? (isActive ? AppTheme.primary : AppTheme.textSecondary)
                    : Colors.white,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isActive ? 20 : 0,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: _isScrolled ? AppTheme.primary : AppTheme.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(BuildContext context, bool isWide) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.of(context).pushNamed('/admin'),
      icon: const Icon(Icons.admin_panel_settings_outlined, size: 16),
      label: isWide ? const Text('Admin') : const SizedBox.shrink(),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isScrolled ? AppTheme.primary : Colors.white,
        foregroundColor: _isScrolled ? Colors.white : AppTheme.primary,
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 18 : 12,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMobileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.menu,
        color: _isScrolled ? AppTheme.textPrimary : Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => _navItems
          .map(
            (item) => PopupMenuItem<String>(
              value: item.key,
              child: Text(
                item.label,
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
            ),
          )
          .toList(),
      onSelected: _scrollToSection,
    );
  }
}

class _NavItem {
  final String label;
  final String key;
  const _NavItem(this.label, this.key);
}
