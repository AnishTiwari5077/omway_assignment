import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

/// Reusable section label chip used across landing page sections.
class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
