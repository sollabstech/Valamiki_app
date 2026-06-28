import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/gradient_button.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Obx(() => Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              controller.user.value?.name.isNotEmpty == true
                                  ? controller.user.value!.name[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

              const SizedBox(height: 32),

              CustomTextField(
                controller: controller.nameController,
                label: 'Full Name',
                prefixIcon: Icons.person_outline_rounded,
                validator: Validators.name,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0, delay: 200.ms),

              const SizedBox(height: 16),

              // Email (readonly)
              Obx(() => CustomTextField(
                    controller: TextEditingController(text: controller.user.value?.email ?? ''),
                    label: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                    enabled: false,
                  )).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 16),

              CustomTextField(
                controller: controller.phoneController,
                label: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => v != null && v.isNotEmpty ? Validators.phone(v) : null,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0, delay: 400.ms),

              const SizedBox(height: 32),

              Obx(() => GradientButton(
                    label: 'Save Changes',
                    isLoading: controller.isSaving.value,
                    onPressed: controller.updateProfile,
                  )).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
