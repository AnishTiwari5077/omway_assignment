import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../models/contact_message.dart';
import '../../../providers/contact_provider.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactProvider>().loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // ── Toolbar ──────────────────────────────────────────────────────
          Row(
            children: [
              Consumer<ContactProvider>(
                builder: (_, p, __) => Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${p.unreadCount} unread',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilterChip(
                      label: const Text('Unread only'),
                      selected: _showUnreadOnly,
                      onSelected: (v) => setState(() => _showUnreadOnly = v),
                      selectedColor: AppTheme.accentLight,
                      checkmarkColor: AppTheme.primary,
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: _showUnreadOnly
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                        fontWeight: _showUnreadOnly
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Consumer<ContactProvider>(
                builder: (_, p, __) => TextButton.icon(
                  onPressed: p.isLoading ? null : () => p.loadContacts(),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 16),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: Consumer<ContactProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  );
                }

                var contacts = provider.contacts;
                if (_showUnreadOnly) {
                  contacts = contacts.where((c) => !c.isRead).toList();
                }

                if (contacts.isEmpty) {
                  return _buildEmpty();
                }

                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ContactCard(
                      message: contacts[i],
                      onMarkRead: () =>
                          provider.markAsRead(contacts[i].id),
                      onDelete: () =>
                          _confirmDelete(context, contacts[i], provider),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: (80 * i).ms, duration: 400.ms)
                      .slideX(begin: -0.05, end: 0),
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
          const Icon(Icons.inbox_outlined, size: 56, color: AppTheme.textMuted),
          const SizedBox(height: 16),
          Text(
            'No messages',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _showUnreadOnly ? 'All messages have been read!' : 'No contact submissions yet.',
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ContactMessage msg,
    ContactProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Message',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Delete message from ${msg.name}?',
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
      await provider.deleteContact(msg.id);
    }
  }
}

class _ContactCard extends StatelessWidget {
  final ContactMessage message;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const _ContactCard({
    required this.message,
    required this.onMarkRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !message.isRead;
    String formattedDate = '';
    if (message.createdAt != null) {
      try {
        final dt = DateTime.parse(message.createdAt!).toLocal();
        formattedDate = DateFormat('MMM d, y  h:mm a').format(dt);
      } catch (_) {}
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isUnread ? AppTheme.accentLight.withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? AppTheme.primary.withOpacity(0.2) : AppTheme.divider,
          width: isUnread ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ──────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor:
                    isUnread ? AppTheme.primary : AppTheme.surfaceVariant,
                child: Text(
                  message.name[0].toUpperCase(),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: isUnread ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          message.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'NEW',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 12,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              size: 12,
                              color: AppTheme.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              message.email,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        if (message.phone.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                size: 12,
                                color: AppTheme.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                message.phone,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (formattedDate.isNotEmpty)
                Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Message ──────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Actions ──────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isUnread)
                TextButton.icon(
                  onPressed: onMarkRead,
                  icon: const Icon(Icons.done_all, size: 16),
                  label: const Text('Mark as Read'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.success,
                  ),
                ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
