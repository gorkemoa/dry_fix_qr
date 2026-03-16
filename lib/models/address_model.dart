class Address {
  final int id;
  final String addressType;
  final String? billingType;
  final String title;
  final String fullName;
  final String phone;
  final String? country;
  final String city;
  final String district;
  final String neighborhood;
  final String addressLine1;
  final String? postalCode;
  final String? billingIdentityNumber;
  final String? billingCompanyTitle;
  final String? billingTaxOffice;
  final String? billingTaxNumber;
  final String? billingInvoiceEmail;
  final bool isDefault;

  Address({
    required this.id,
    required this.addressType,
    this.billingType,
    required this.title,
    required this.fullName,
    required this.phone,
    this.country,
    required this.city,
    required this.district,
    required this.neighborhood,
    required this.addressLine1,
    this.postalCode,
    this.billingIdentityNumber,
    this.billingCompanyTitle,
    this.billingTaxOffice,
    this.billingTaxNumber,
    this.billingInvoiceEmail,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      addressType: json['address_type'] as String? ?? 'shipping',
      billingType: json['billing_type'] as String?,
      title: json['title'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      country: json['country'] as String?,
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      addressLine1: json['address_line1'] as String? ?? '',
      postalCode: json['postal_code'] as String?,
      billingIdentityNumber: json['billing_identity_number'] as String?,
      billingCompanyTitle: json['billing_company_title'] as String?,
      billingTaxOffice: json['billing_tax_office'] as String?,
      billingTaxNumber: json['billing_tax_number'] as String?,
      billingInvoiceEmail: json['billing_invoice_email'] as String?,
      isDefault: json['is_default'] == true || json['is_default'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address_type': addressType,
      'billing_type': billingType,
      'title': title,
      'full_name': fullName,
      'phone': phone,
      'country': country,
      'city': city,
      'district': district,
      'neighborhood': neighborhood,
      'address_line1': addressLine1,
      'postal_code': postalCode,
      'billing_identity_number': billingIdentityNumber,
      'billing_company_title': billingCompanyTitle,
      'billing_tax_office': billingTaxOffice,
      'billing_tax_number': billingTaxNumber,
      'billing_invoice_email': billingInvoiceEmail,
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
  final String addressType;
  final String? billingType;
  final String title;
  final String? fullName;
  final String? phone;
  final String? city;
  final String? district;
  final String? neighborhood;
  final String? addressLine1;
  final String? postalCode;
  final String? billingIdentityNumber;
  final String? billingCompanyTitle;
  final String? billingTaxOffice;
  final String? billingTaxNumber;
  final String? billingInvoiceEmail;
  final bool isDefault;

  CreateAddressRequest({
    required this.addressType,
    this.billingType,
    required this.title,
    this.fullName,
    this.phone,
    this.city,
    this.district,
    this.neighborhood,
    this.addressLine1,
    this.postalCode,
    this.billingIdentityNumber,
    this.billingCompanyTitle,
    this.billingTaxOffice,
    this.billingTaxNumber,
    this.billingInvoiceEmail,
    required this.isDefault,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'address_type': addressType,
      'title': title,
      'is_default': isDefault ? 1 : 0,
    };
    if (billingType != null) map['billing_type'] = billingType;
    if (fullName != null && fullName!.isNotEmpty) map['full_name'] = fullName;
    if (phone != null && phone!.isNotEmpty) map['phone'] = phone;
    if (city != null && city!.isNotEmpty) map['city'] = city;
    if (district != null && district!.isNotEmpty) map['district'] = district;
    if (neighborhood != null && neighborhood!.isNotEmpty) map['neighborhood'] = neighborhood;
    if (addressLine1 != null && addressLine1!.isNotEmpty) map['address_line1'] = addressLine1;
    if (postalCode != null && postalCode!.isNotEmpty) map['postal_code'] = postalCode;
    if (billingIdentityNumber != null && billingIdentityNumber!.isNotEmpty) map['billing_identity_number'] = billingIdentityNumber;
    if (billingCompanyTitle != null && billingCompanyTitle!.isNotEmpty) map['billing_company_title'] = billingCompanyTitle;
    if (billingTaxOffice != null && billingTaxOffice!.isNotEmpty) map['billing_tax_office'] = billingTaxOffice;
    if (billingTaxNumber != null && billingTaxNumber!.isNotEmpty) map['billing_tax_number'] = billingTaxNumber;
    if (billingInvoiceEmail != null && billingInvoiceEmail!.isNotEmpty) map['billing_invoice_email'] = billingInvoiceEmail;
    return map;
  }
}

class AddressResponse {
  final bool success;
  final String? message;
  final Address data;

  AddressResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    final addressData = json['data'] ?? json;
    return AddressResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      data: Address.fromJson(addressData as Map<String, dynamic>),
    );
  }
}
