import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'features/admin/admin_shell.dart';
import 'features/landing/landing_page.dart';
import 'providers/contact_provider.dart';
import 'providers/product_provider.dart';
import 'providers/testimonial_provider.dart';
import 'providers/auth_provider.dart';
import 'features/admin/login_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

void main() {
  runApp(const PharmacyApp());
}

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => TestimonialProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'MediCare Pharmacy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
          },
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        initialRoute: '/',
        routes: {
          '/': (_) => const LandingPage(),
          '/admin': (_) => const AuthGuard(),
        },
      ),
    );
  }
}

class AuthGuard extends StatelessWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return const AdminShell();
        }
        return const LoginScreen();
      },
    );
  }
}
