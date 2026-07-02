import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/contact_provider.dart';
import '../../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'products/products_list_screen.dart';
import 'testimonials/testimonials_list_screen.dart';
import 'contacts/contacts_list_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  final List<_AdminNavItem> _navItems = [
    _AdminNavItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
    ),
    _AdminNavItem(
      label: 'Products',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
    ),
    _AdminNavItem(
      label: 'Testimonials',
      icon: Icons.rate_review_outlined,
      activeIcon: Icons.rate_review,
    ),
    _AdminNavItem(
      label: 'Messages',
      icon: Icons.mail_outline,
      activeIcon: Icons.mail,
      showBadge: true,
    ),
  ];

  final List<Widget> _screens = const [
    DashboardScreen(),
    ProductsListScreen(),
    TestimonialsListScreen(),
    ContactsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          // ── Sidebar (desktop) ────────────────────────────────────────────
          if (isWide) _buildSidebar(context),

          // ── Main Content ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context, isWide),
                Expanded(
                  child: _screens[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
      // ── Bottom Nav (mobile) ──────────────────────────────────────────────
      bottomNavigationBar: isWide ? null : _buildBottomNav(context),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        gradient: AppTheme.adminGradient,
      ),
      child: Column(
        children: [
          // Logo area
          Container(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_pharmacy,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MediCare',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Admin Panel',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Nav items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: _navItems
                    .asMap()
                    .entries
                    .map((e) => _buildSidebarItem(context, e.key, e.value))
                    .toList(),
              ),
            ),
          ),

          // Back to site
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/'),
              icon: const Icon(Icons.arrow_back, size: 16, color: Colors.white70),
              label: Text(
                'Back to Site',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    int index,
    _AdminNavItem item,
  ) {
    final isActive = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: () => setState(() => _selectedIndex = index),
          leading: Icon(
            isActive ? item.activeIcon : item.icon,
            color: isActive ? Colors.white : Colors.white60,
            size: 20,
          ),
          title: Text(
            item.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? Colors.white : Colors.white70,
            ),
          ),
          trailing: item.showBadge
              ? Consumer<ContactProvider>(
                  builder: (_, p, __) {
                    final count = p.unreadCount;
                    if (count == 0) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '$count',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isWide) {
    final titles = ['Dashboard', 'Products', 'Testimonials', 'Messages'];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isWide ? 20 : 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.divider),
        ),
      ),
      child: Row(
        children: [
          if (!isWide) ...[
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            titles[_selectedIndex],
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.accentLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: AppTheme.primary,
                  child: Icon(Icons.person, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  'Admin',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.error),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primary,
      unselectedItemColor: AppTheme.textMuted,
      selectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
      items: _navItems
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              activeIcon: Icon(item.activeIcon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}

class _AdminNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool showBadge;

  const _AdminNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.showBadge = false,
  });
}
