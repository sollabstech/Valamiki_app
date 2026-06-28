import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/address_model.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/gradient_button.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  String _type = 'home';
  bool _isDefault = false;
  bool _isLoading = false;
  final _addressRepo = AddressRepository();

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final uid = FirebaseService.instance.currentUserId ?? '';
      final address = AddressModel(
        id: '',
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine1: _line1Controller.text.trim(),
        addressLine2: _line2Controller.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        type: _type,
        isDefault: _isDefault,
      );
      await _addressRepo.addAddress(uid, address);
      AppHelpers.showSuccess('Address added successfully!');
      Get.back();
    } catch (_) {
      AppHelpers.showError('Failed to add address. Try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address type selector
              const Text(
                'Address Type',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _TypeChip(label: 'Home', value: 'home', icon: Icons.home_outlined, selected: _type, onTap: (v) => setState(() => _type = v)),
                  const SizedBox(width: 10),
                  _TypeChip(label: 'Work', value: 'work', icon: Icons.work_outline_rounded, selected: _type, onTap: (v) => setState(() => _type = v)),
                  const SizedBox(width: 10),
                  _TypeChip(label: 'Other', value: 'other', icon: Icons.location_on_outlined, selected: _type, onTap: (v) => setState(() => _type = v)),
                ],
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 20),

              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                prefixIcon: Icons.person_outline_rounded,
                validator: Validators.name,
              ).animate().fadeIn(delay: 150.ms),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _line1Controller,
                label: 'Address Line 1',
                hint: 'House/Flat No., Street',
                prefixIcon: Icons.home_work_outlined,
                validator: (v) => Validators.required(v, 'Address'),
              ).animate().fadeIn(delay: 250.ms),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _line2Controller,
                label: 'Address Line 2 (Optional)',
                hint: 'Landmark, Colony',
                prefixIcon: Icons.location_city_outlined,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _cityController,
                      label: 'City',
                      prefixIcon: Icons.location_city_outlined,
                      validator: (v) => Validators.required(v, 'City'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _stateController,
                      label: 'State',
                      prefixIcon: Icons.map_outlined,
                      validator: (v) => Validators.required(v, 'State'),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 350.ms),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _pincodeController,
                label: 'Pincode',
                prefixIcon: Icons.pin_outlined,
                keyboardType: TextInputType.number,
                validator: Validators.pincode,
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 16),

              // Default checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (v) => setState(() => _isDefault = v ?? false),
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  const Text(
                    'Set as default address',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 450.ms),

              const SizedBox(height: 28),

              GradientButton(
                label: 'Save Address',
                isLoading: _isLoading,
                onPressed: _saveAddress,
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String selected;
  final Function(String) onTap;

  const _TypeChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
