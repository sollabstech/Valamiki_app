import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF4FC3F7);
  static const Color accent = Color(0xFF00C853);
  static const Color accentOrange = Color(0xFFFF6F00);

  // Background Colors
  static const Color background = Color(0xFFF8F9FF);
  static const Color backgroundDark = Color(0xFF0A0E21);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF1E2139);

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F4FF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF1A73E8);
  static const Color gradientEnd = Color(0xFF6C63FF);
  static const Color gradientStartLight = Color(0xFF4FC3F7);
  static const Color gradientEndLight = Color(0xFF1A73E8);

  // Status Colors
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF1A73E8);

  // Category Colors
  static const Color grocery = Color(0xFF4CAF50);
  static const Color stationery = Color(0xFF2196F3);
  static const Color snacks = Color(0xFFFF9800);
  static const Color household = Color(0xFF9C27B0);
  static const Color dailyEssentials = Color(0xFFE91E63);

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Border
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // Shadow
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDeep = Color(0x33000000);

  // Divider
  static const Color divider = Color(0xFFE5E7EB);

  // Discount Badge
  static const Color discountBadge = Color(0xFFFF3D00);
  static const Color newBadge = Color(0xFF00C853);

  // Bottom Nav
  static const Color bottomNavActive = Color(0xFF1A73E8);
  static const Color bottomNavInactive = Color(0xFF9CA3AF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A73E8), Color(0xFF6C63FF), Color(0xFF0D47A1)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A73E8), Color(0xFF4FC3F7)],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
  );

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6F00), Color(0xFFFFCA28)],
  );
}
