import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../models/testimonial.dart';
import '../../../providers/testimonial_provider.dart';
import 'testimonial_form_screen.dart';

class TestimonialsListScreen extends StatefulWidget {
  const TestimonialsListScreen({super.key});

  @override
  State<TestimonialsListScreen> createState() => _TestimonialsListScreenState();
}

class _TestimonialsListScreenState extends State<TestimonialsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TestimonialProvider>().loadTestimonials();
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
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _openForm(context, null),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Testimonial'),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 20),

          // ── Grid ─────────────────────────────────────────────────────────
          Expanded(
            child: Consumer<TestimonialProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  );
                }

                final testimonials = provider.testimonials;

                if (testimonials.isEmpty) {
                  return _buildEmpty();
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final crossCount = constraints.maxWidth > 600 ? 2 : 1;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossCount,
                        childAspectRatio: 2.2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: testimonials.length,
                      itemBuilder: (_, i) => _TestimonialAdminCard(
                        testimonial: testimonials[i],
                        onEdit: () => _openForm(context, testimonials[i]),
                        onDelete: () =>
                            _confirmDelete(context, testimonials[i], provider),
                      )
                          .animate()
                          .fadeIn(
                            delay: (100 + i * 80).ms,
                            duration: 400.ms,
                          )
                          .slideY(begin: 0.1, end: 0),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.rate_review_outlined,
            size: 56,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No testimonials yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openForm(BuildContext context, Testimonial? t) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TestimonialFormScreen(existingTestimonial: t),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Testimonial t,
    TestimonialProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Testimonial',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Delete testimonial by ${t.authorName}?',
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

    if (confirmed == true && mounted) {
      await provider.deleteTestimonial(t.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Testimonial deleted'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    }
  }
}

class _TestimonialAdminCard extends StatelessWidget {
  final Testimonial testimonial;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TestimonialAdminCard({
    required this.testimonial,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.accentLight,
                backgroundImage:
                    testimonial.avatarUrl != null &&
                            testimonial.avatarUrl!.isNotEmpty
                        ? NetworkImage(testimonial.avatarUrl!)
                        : null,
                child: (testimonial.avatarUrl == null ||
                        testimonial.avatarUrl!.isEmpty)
                    ? Text(
                        testimonial.authorName[0],
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.authorName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      testimonial.role,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: testimonial.rating,
                itemBuilder: (_, __) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            testimonial.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(foregroundColor: AppTheme.info),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete'),
                style: TextButton.styleFrom(foregroundColor: AppTheme.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
