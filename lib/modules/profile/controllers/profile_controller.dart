import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final _authRepo = AuthRepository();
  final _addressRepo = AddressRepository();

  final user = Rxn<UserModel>();
  final addresses = <AddressModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Edit profile form
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      user.value = await _authRepo.getCurrentUser();
      if (user.value != null) {
        nameController.text = user.value!.name;
        phoneController.text = user.value!.phone;
        await loadAddresses();
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAddresses() async {
    final uid = FirebaseService.instance.currentUserId;
    if (uid != null) {
      addresses.value = await _addressRepo.getUserAddresses(uid);
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final uid = FirebaseService.instance.currentUserId;
      if (uid != null) {
        await _authRepo.updateProfile(uid, {
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
        });
        user.value = user.value?.copyWith(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
        );
        AppHelpers.showSuccess('Profile updated successfully!');
        Get.back();
      }
    } catch (_) {
      AppHelpers.showError('Failed to update profile. Try again.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> signOut() async {
    final confirm = await Get.defaultDialog<bool>(
      title: 'Sign Out',
      middleText: 'Are you sure you want to sign out?',
      textConfirm: 'Sign Out',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirm == true) {
      await _authRepo.signOut();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> deleteAddress(String addressId) async {
    final uid = FirebaseService.instance.currentUserId;
    if (uid != null) {
      await _addressRepo.deleteAddress(uid, addressId);
      await loadAddresses();
      AppHelpers.showSuccess('Address removed');
    }
  }

  Future<void> addAddress(AddressModel address) async {
    final uid = FirebaseService.instance.currentUserId;
    if (uid != null) {
      await _addressRepo.addAddress(uid, address);
      await loadAddresses();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
