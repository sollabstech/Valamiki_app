import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final pages = [
    OnboardingPage(
      title: 'Order Grocery Fast',
      subtitle: 'Get fresh groceries delivered to your door in minutes. Quality you can trust, speed you will love.',
      emoji: '🛒',
      gradient: [const Color(0xFF1A73E8), const Color(0xFF4FC3F7)],
    ),
    OnboardingPage(
      title: 'Get Stationery Delivered',
      subtitle: 'Notebooks, pens, art supplies and more — delivered right to your home or office.',
      emoji: '✏️',
      gradient: [const Color(0xFF6C63FF), const Color(0xFF9B8FFF)],
    ),
    OnboardingPage(
      title: 'Easy Shopping Experience',
      subtitle: 'Simple checkout, real-time tracking, and premium customer support. Shopping made effortless.',
      emoji: '🚀',
      gradient: [const Color(0xFF00C853), const Color(0xFF69F0AE)],
    ),
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() => completeOnboarding();

  Future<void> completeOnboarding() async {
    await StorageService.instance.setFirstLaunchComplete();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradient;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
  });
}
