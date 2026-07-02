class AppConstants {
  // ─── API Base URL ─────────────────────────────────────────────────────────────
  // 🌐 Production (Render deployment)
  static const String baseUrl = 'https://omway-assignment.onrender.com/api';
  // 🏠 Local development (uncomment when running locally)
  // static const String baseUrl = 'http://localhost:3000/api';

  // ─── API Endpoints ────────────────────────────────────────────────────────────
  static const String productsEndpoint = '/products';
  static const String testimonialsEndpoint = '/testimonials';
  static const String contactsEndpoint = '/contacts';
  static const String statsEndpoint = '/stats';

  // ─── App Info ─────────────────────────────────────────────────────────────────
  static const String appName = 'MediCare Pharmacy';
  static const String appTagline = 'Your Trusted Health Partner';
  static const String appDescription =
      'Quality medicines, supplements, and healthcare products delivered to your door.';

  // ─── Routes ───────────────────────────────────────────────────────────────────
  static const String landingRoute = '/';
  static const String adminRoute = '/admin';
  static const String adminProductsRoute = '/admin/products';
  static const String adminProductFormRoute = '/admin/products/form';
  static const String adminTestimonialsRoute = '/admin/testimonials';
  static const String adminTestimonialFormRoute = '/admin/testimonials/form';
  static const String adminContactsRoute = '/admin/contacts';

  // ─── Section Keys (for scroll navigation) ────────────────────────────────────
  static const String heroSection = 'hero';
  static const String aboutSection = 'about';
  static const String productsSection = 'products';
  static const String testimonialsSection = 'testimonials';
  static const String contactSection = 'contact';

  // ─── Product Categories ───────────────────────────────────────────────────────
  static const List<String> productCategories = [
    'Pain Relief',
    'Vitamins',
    'Supplements',
    'First Aid',
    'Cough & Cold',
    'Skin Care',
    'Digestive Health',
    'Baby Care',
    'Eye Care',
    'Dental Care',
  ];
}
