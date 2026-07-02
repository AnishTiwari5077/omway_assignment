import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../models/testimonial.dart';
import '../../../providers/testimonial_provider.dart';


class TestimonialsSection extends StatefulWidget {
  final GlobalKey sectionKey;

  const TestimonialsSection({super.key, required this.sectionKey});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TestimonialProvider>().loadTestimonials();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      key: widget.sectionKey,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D7377), Color(0xFF0A5C60)],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 100,
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _buildHeader(context).animate().fadeIn(delay: 100.ms).slideY(begin: -0.2),
          const SizedBox(height: 60),

          // ── Testimonials ─────────────────────────────────────────────────
          Consumer<TestimonialProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              if (provider.testimonials.isEmpty) {
                return const SizedBox(height: 100);
              }

              return Column(
                children: [
                  isWide
                      ? _buildDesktopGrid(provider.testimonials)
                      : _buildMobileCarousel(provider.testimonials),
                  if (!isWide) ...[
                    const SizedBox(height: 20),
                    _buildDots(provider.testimonials.length),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'TESTIMONIALS',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'What Our Customers Say',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Join thousands of happy customers who trust MediCare for their health needs',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white.withOpacity(0.75),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopGrid(List<Testimonial> testimonials) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: testimonials
              .asMap()
              .entries
              .map(
                (e) => SizedBox(
                  width: 270,
                  height: 380,
                  child: _TestimonialCard(testimonial: e.value)
                      .animate()
                      .fadeIn(delay: (200 + e.key * 150).ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildMobileCarousel(List<Testimonial> testimonials) {
    return SizedBox(
      height: 340,
      child: PageView.builder(
        controller: _pageController,
        itemCount: testimonials.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _TestimonialCard(testimonial: testimonials[i]),
        ),
      ),
    );
  }

  Widget _buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: i == _currentPage ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: i == _currentPage
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;

  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote icon
          Icon(
            Icons.format_quote,
            color: AppTheme.accent,
            size: 36,
          ),
          const SizedBox(height: 12),

          // Rating
          RatingBarIndicator(
            rating: testimonial.rating,
            itemBuilder: (_, __) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 18,
          ),
          const SizedBox(height: 14),

          // Content
          Expanded(
            child: Text(
              testimonial.content,
              overflow: TextOverflow.ellipsis,
              maxLines: 15,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                height: 1.65,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),


          // Author
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.accentLight,
                backgroundImage: testimonial.avatarUrl != null &&
                        testimonial.avatarUrl!.isNotEmpty
                    ? NetworkImage(testimonial.avatarUrl!)
                    : null,
                child:
                    testimonial.avatarUrl == null || testimonial.avatarUrl!.isEmpty
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      testimonial.role,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
