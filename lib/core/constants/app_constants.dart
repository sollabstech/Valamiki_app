class AppConstants {
  // App Info
  static const String appName = 'VALAMIKI';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Fast Delivery. Premium Quality.';

  // Shared Preferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserPhone = 'user_phone';
  static const String keyRememberMe = 'remember_me';
  static const String keyCartItems = 'cart_items';
  static const String keyThemeMode = 'theme_mode';

  // Firestore Collections
  static const String colUsers = 'users';
  static const String colProducts = 'products';
  static const String colCategories = 'categories';
  static const String colOrders = 'orders';
  static const String colBanners = 'banners';
  static const String colCart = 'cart';
  static const String colAddresses = 'addresses';

  // Order Statuses
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderShipped = 'shipped';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';

  // Payment Methods
  static const String paymentCOD = 'Cash on Delivery';
  static const String paymentRazorpay = 'Razorpay';

  // Delivery
  static const double freeDeliveryThreshold = 499.0;
  static const double deliveryCharge = 40.0;

  // Pagination
  static const int pageSize = 10;

  // Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 400);
  static const Duration animationSlow = Duration(milliseconds: 600);

  // Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImage = 'assets/images/placeholder.png';
}
