class Address {
  final int id;
  final String title;
  final String fullName;
  final String phone;
  final String city;
  final String district;
  final String neighborhood;
  final String addressLine1;
  final String? addressLine2;
  final String postalCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.title,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.district,
    required this.neighborhood,
    required this.addressLine1,
    this.addressLine2,
    required this.postalCode,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      addressLine1: json['address_line1'] as String? ?? '',
      addressLine2: json['address_line2'] as String?,
      postalCode: json['postal_code'] as String? ?? '',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'full_name': fullName,
      'phone': phone,
      'city': city,
      'district': district,
      'neighborhood': neighborhood,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'postal_code': postalCode,
      'is_default': isDefault,
    };
  }
}

class AddressListResponse {
  final bool success;
  final List<Address> data;

  AddressListResponse({required this.success, required this.data});

  factory AddressListResponse.fromJson(Map<String, dynamic> json) {
    return AddressListResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List? ?? [])
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CreateAddressRequest {
  final String title;
  final String fullName;
  final String phone;
  final String city;
  final String district;
  final String neighborhood;
  final String addressLine1;
  final String? addressLine2;
  final String postalCode;
  final bool isDefault;

  CreateAddressRequest({
    required this.title,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.district,
    required this.neighborhood,
    required this.addressLine1,
    this.addressLine2,
    required this.postalCode,
    required this.isDefault,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'full_name': fullName,
      'phone': phone,
      'city': city,
      'district': district,
      'neighborhood': neighborhood,
      'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      'postal_code': postalCode,
      'is_default': isDefault ? 1 : 0,
    };
  }
}

class CreateAddressResponse {
  final bool success;
  final String message;
  final Address address;

  CreateAddressResponse({
    required this.success,
    required this.message,
    required this.address,
  });

  factory CreateAddressResponse.fromJson(Map<String, dynamic> json) {
    return CreateAddressResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
    );
  }
}
