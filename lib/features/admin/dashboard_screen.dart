import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/product_provider.dart';
import '../../providers/testimonial_provider.dart';
import '../../providers/contact_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
      context.read<TestimonialProvider>().loadTestimonials();
      context.read<ContactProvider>().loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Welcome Card ─────────────────────────────────────────────────
          _buildWelcomeCard()
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: -0.1),
          const SizedBox(height: 28),

          // ── Stat Cards Row ───────────────────────────────────────────────
          _buildStatCards()
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 28),

          // ── Recent Contacts ──────────────────────────────────────────────
          _buildRecentContacts()
              .animate()
              .fadeIn(delay: 400.ms, duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Admin! 👋',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your pharmacy products, testimonials, and customer messages from here.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.local_pharmacy,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int crossCount;
        final double aspectRatio;
        
        if (width > 1000) {
          crossCount = 4;
          aspectRatio = 1.6;
        } else if (width > 768) {
          crossCount = 4;
          aspectRatio = 1.1; // Tablets: 4 columns but taller cards
        } else if (width > 500) {
          crossCount = 2;
          aspectRatio = 1.6;
        } else {
          crossCount = 2;
          aspectRatio = 1.15;
        }

        return Consumer3<ProductProvider, TestimonialProvider, ContactProvider>(
          builder: (_, products, testimonials, contacts, __) {
            final cards = [
              _StatData(
                label: 'Total Products',
                value: '${products.products.length}',
                subLabel: '${products.featuredProducts.length} featured',
                icon: Icons.inventory_2_outlined,
                color: AppTheme.primary,
              ),
              _StatData(
                label: 'Testimonials',
                value: '${testimonials.testimonials.length}',
                subLabel: 'Customer reviews',
                icon: Icons.rate_review_outlined,
                color: const Color(0xFF8B5CF6),
              ),
              _StatData(
                label: 'Total Messages',
                value: '${contacts.contacts.length}',
                subLabel: '${contacts.unreadCount} unread',
                icon: Icons.mail_outline,
                color: AppTheme.info,
              ),
              _StatData(
                label: 'Unread Messages',
                value: '${contacts.unreadCount}',
                subLabel: 'Need attention',
                icon: Icons.mark_email_unread_outlined,
                color: contacts.unreadCount > 0
                    ? AppTheme.error
                    : AppTheme.success,
              ),
            ];

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: cards.length,
              itemBuilder: (_, i) => _StatCard(data: cards[i]),
            );
          },
        );
      },
    );
  }

  Widget _buildRecentContacts() {
    return Consumer<ContactProvider>(
      builder: (_, provider, __) {
        final recent = provider.contacts.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Messages',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            if (recent.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.inbox_outlined,
                        size: 40,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No messages yet',
                        style: GoogleFonts.inter(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recent.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppTheme.divider),
                  itemBuilder: (_, i) {
                    final msg = recent[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: msg.isRead
                            ? AppTheme.surfaceVariant
                            : AppTheme.accentLight,
                        child: Text(
                          msg.name[0].toUpperCase(),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: msg.isRead
                                ? AppTheme.textMuted
                                : AppTheme.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        msg.name,
                        style: GoogleFonts.inter(
                          fontWeight: msg.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        msg.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      trailing: !msg.isRead
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primary,
                              ),
                            )
                          : null,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StatData {
  final String label;
  final String value;
  final String subLabel;
  final IconData icon;
  final Color color;

  const _StatData({
    required this.label,
    required this.value,
    required this.subLabel,
    required this.icon,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final _StatData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data.icon, color: data.color, size: 20),
              ),
            ],
          ),
          const Spacer(),
          Text(
            data.value,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: data.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            data.subLabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
