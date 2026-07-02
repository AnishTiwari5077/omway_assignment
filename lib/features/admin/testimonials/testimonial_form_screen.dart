import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../models/testimonial.dart';
import '../../../providers/testimonial_provider.dart';

class TestimonialFormScreen extends StatefulWidget {
  final Testimonial? existingTestimonial;

  const TestimonialFormScreen({super.key, this.existingTestimonial});

  @override
  State<TestimonialFormScreen> createState() => _TestimonialFormScreenState();
}

class _TestimonialFormScreenState extends State<TestimonialFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _roleCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _avatarCtrl;
  double _rating = 5.0;
  bool _saving = false;

  bool get _isEditing => widget.existingTestimonial != null;

  @override
  void initState() {
    super.initState();
    final t = widget.existingTestimonial;
    _nameCtrl = TextEditingController(text: t?.authorName ?? '');
    _roleCtrl = TextEditingController(text: t?.role ?? '');
    _contentCtrl = TextEditingController(text: t?.content ?? '');
    _avatarCtrl = TextEditingController(text: t?.avatarUrl ?? '');
    _rating = t?.rating ?? 5.0;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _contentCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final testimonial = Testimonial(
      id: widget.existingTestimonial?.id ?? '',
      authorName: _nameCtrl.text.trim(),
      role: _roleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      rating: _rating,
      avatarUrl: _avatarCtrl.text.trim(),
    );

    final provider = context.read<TestimonialProvider>();
    bool success;

    if (_isEditing) {
      success = await provider.updateTestimonial(
        widget.existingTestimonial!.id,
        testimonial,
      );
    } else {
      success = await provider.createTestimonial(testimonial);
    }

    setState(() => _saving = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Testimonial updated!' : 'Testimonial created!',
            ),
            backgroundColor: AppTheme.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save. Check backend connection.'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Testimonial' : 'Add Testimonial',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save_outlined, size: 18),
              label: Text(_saving ? 'Saving...' : 'Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author Info
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Author Name *',
                              hintText: 'Sarah Mitchell',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppTheme.primary,
                              ),
                            ),
                            validator: (v) =>
                                v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _roleCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Role / Title *',
                              hintText: 'Regular Customer',
                              prefixIcon: Icon(
                                Icons.work_outline,
                                color: AppTheme.primary,
                              ),
                            ),
                            validator: (v) =>
                                v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Rating
                    Text(
                      'Rating',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 32,
                      itemBuilder: (_, __) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (r) => setState(() => _rating = r),
                    ),
                    const SizedBox(height: 20),

                    // Content
                    TextFormField(
                      controller: _contentCtrl,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Testimonial Content *',
                        hintText: 'Share your experience...',
                        prefixIcon: Icon(
                          Icons.format_quote,
                          color: AppTheme.primary,
                        ),
                        alignLabelWithHint: true,
                      ),
                      validator: (v) =>
                          v!.length < 20 ? 'Too short (min 20 chars)' : null,
                    ),
                    const SizedBox(height: 20),

                    // Avatar
                    TextFormField(
                      controller: _avatarCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Avatar URL (optional)',
                        hintText: 'https://...',
                        prefixIcon: Icon(
                          Icons.image_outlined,
                          color: AppTheme.primary,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),

                    // Avatar preview
                    if (_avatarCtrl.text.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(_avatarCtrl.text),
                            onBackgroundImageError: (_, __) {},
                            backgroundColor: AppTheme.accentLight,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _nameCtrl.text.isNotEmpty
                                ? _nameCtrl.text
                                : 'Author Name',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _saving ? null : _save,
                          icon: const Icon(Icons.save_outlined, size: 18),
                          label: Text(
                            _isEditing
                                ? 'Update Testimonial'
                                : 'Create Testimonial',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
