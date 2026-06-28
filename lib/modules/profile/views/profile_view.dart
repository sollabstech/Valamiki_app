import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';

class ProfileView extends StatelessWidget {
  final bool isTab;
  const ProfileView({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                right: 20,
                bottom: 28,
              ),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Obx(() => Row(
                    children: [
                      // Avatar
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.25),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            (controller.user.value?.name.isNotEmpty == true)
                                ? controller.user.value!.name[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.user.value?.name ?? 'User',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.user.value?.email ?? '',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.toNamed(AppRoutes.editProfile),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  )),
            ),
          ),

          // Menu items
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _MenuSection(
                  title: 'My Account',
                  items: [
                    _MenuItem(
                      icon: Icons.receipt_long_outlined,
                      label: 'My Orders',
                      subtitle: 'Track and manage orders',
                      onTap: () => Get.toNamed(AppRoutes.orders),
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      label: 'Saved Addresses',
                      subtitle: 'Manage delivery addresses',
                      onTap: () => Get.toNamed(AppRoutes.addresses),
                    ),
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profile',
                      subtitle: 'Update your information',
                      onTap: () => Get.toNamed(AppRoutes.editProfile),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _MenuSection(
                  title: 'More',
                  items: [
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      onTap: () => AppHelpers.showInfo('Support coming soon!'),
                    ),
                    _MenuItem(
                      icon: Icons.info_outline_rounded,
                      label: 'About VALAMIKI',
                      onTap: () => Get.defaultDialog(
                        title: 'VALAMIKI',
                        middleText: 'Version 1.0.0\nFast Delivery. Premium Quality.',
                      ),
                    ),
                    _MenuItem(
                      icon: Icons.logout_rounded,
                      label: 'Sign Out',
                      labelColor: AppColors.error,
                      iconColor: AppColors.error,
                      onTap: () => controller.signOut(),
                      showArrow: false,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'VALAMIKI v1.0.0',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: items
                .asMap()
                .entries
                .map((entry) => Column(
                      children: [
                        entry.value,
                        if (entry.key < items.length - 1)
                          const Divider(
                            height: 1,
                            indent: 60,
                            endIndent: 16,
                          ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0, delay: 200.ms);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.labelColor,
    this.iconColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: labelColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: showArrow
          ? const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20)
          : null,
      onTap: onTap,
    );
  }
}


