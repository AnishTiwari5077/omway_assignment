import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    final success = await context.read<AuthProvider>().login(
          _usernameCtrl.text.trim(),
          _passwordCtrl.text.trim(),
        );

    if (!success && mounted) {
      final error = context.read<AuthProvider>().error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.heroGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.local_pharmacy,
                          size: 48,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Admin Portal',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to manage your pharmacy',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _usernameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? 'Please enter username' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? 'Please enter password' : null,
                        ),
                        const SizedBox(height: 32),
                        Consumer<AuthProvider>(
                          builder: (_, auth, __) => ElevatedButton(
                            onPressed: auth.isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: auth.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Sign In'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                          child: const Text('Back to Website'),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
