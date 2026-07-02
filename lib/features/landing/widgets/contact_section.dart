import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../models/contact_message.dart';
import '../../../providers/contact_provider.dart';
import 'section_label.dart';


class ContactSection extends StatefulWidget {
  final GlobalKey sectionKey;

  const ContactSection({super.key, required this.sectionKey});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitted = false;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final contact = ContactMessage(
      id: '',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      message: _messageController.text.trim(),
      isRead: false,
    );

    final success =
        await context.read<ContactProvider>().submitContact(contact);

    setState(() {
      _submitting = false;
      _submitted = success;
    });

    if (success) {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to send message. Is the backend running?',
            ),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      key: widget.sectionKey,
      color: AppTheme.surfaceVariant,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _buildInfo(context)),
                    const SizedBox(width: 80),
                    Expanded(flex: 6, child: _buildForm()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfo(context),
                    const SizedBox(height: 48),
                    _buildForm(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: 'Contact Us')
            .animate()
            .fadeIn(delay: 100.ms)
            .slideX(begin: -0.2),
        const SizedBox(height: 16),
        Text(
          "We'd Love\nTo Hear From You",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 16),
        Text(
          'Have a question about a product, need prescription advice, or want to place a bulk order? Reach out to us and our team will get back to you shortly.',
          style: Theme.of(context).textTheme.bodyLarge,
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 36),
        ...[
          _buildContactItem(Icons.location_on_outlined, 'Address',
              '123 Health Street, Medical District, Mumbai - 400001'),
          _buildContactItem(Icons.phone_outlined, 'Phone', '+91 98765 43210'),
          _buildContactItem(
              Icons.email_outlined, 'Email', 'hello@medicare.in'),
          _buildContactItem(Icons.access_time_outlined, 'Hours',
              'Mon–Sat: 8am–10pm\nSun: 10am–6pm'),
        ]
            .map((w) => Padding(padding: const EdgeInsets.only(bottom: 16), child: w)),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.accentLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1);
  }

  Widget _buildForm() {
    if (_submitted) {
      return _buildSuccessState()
          .animate()
          .fadeIn(duration: 600.ms)
          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
    }

    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send us a message',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'John Doe',
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'you@example.com',
                    icon: Icons.email_outlined,
                    validator: (v) => v!.contains('@')
                        ? null
                        : 'Please enter a valid email',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildField(
                    controller: _phoneController,
                    label: 'Phone (optional)',
                    hint: '+91 98765 43210',
                    icon: Icons.phone_outlined,
                    validator: (_) => null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _messageController,
              label: 'Message',
              hint: 'How can we help you?',
              icon: Icons.message_outlined,
              maxLines: 5,
              validator: (v) =>
                  v!.length < 10 ? 'Message too short' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send_outlined, size: 18),
                label: Text(_submitting ? 'Sending...' : 'Send Message'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primary, size: 18),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppTheme.success,
              size: 44,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Message Sent!',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Thank you for reaching out. We'll get back to you within 24 hours.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          OutlinedButton(
            onPressed: () => setState(() => _submitted = false),
            child: const Text('Send Another Message'),
          ),
        ],
      ),
    );
  }
}
