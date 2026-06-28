class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String type; // home, work, other
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.pincode,
    this.type = 'home',
    this.isDefault = false,
  });

  String get fullAddress {
    final parts = [addressLine1, if (addressLine2.isNotEmpty) addressLine2, city, state, pincode];
    return parts.join(', ');
  }

  factory AddressModel.fromMap(Map<String, dynamic> map, String id) {
    return AddressModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      type: map['type'] ?? 'home',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'type': type,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({bool? isDefault}) {
    return AddressModel(
      id: id,
      name: name,
      phone: phone,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      pincode: pincode,
      type: type,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
