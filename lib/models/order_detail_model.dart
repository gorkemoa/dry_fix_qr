class OrderDetailResponse {
  final bool success;
  final OrderDetailModel order;
  final OrderAddressModel address;
  final List<OrderItemModel> items;

  OrderDetailResponse({
    required this.success,
    required this.order,
    required this.address,
    required this.items,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      success: json['success'] as bool,
      order: OrderDetailModel.fromJson(json['order'] as Map<String, dynamic>),
      address: OrderAddressModel.fromJson(
        json['address'] as Map<String, dynamic>,
      ),
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'order': order.toJson(),
      'address': address.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderDetailModel {
  final int id;
  final String status;
  final int totalTokenSpent;
  final String totalPrice;
  final int quantity;
  final String? notes;
  final String purchasedAt;
  final String createdAt;

  OrderDetailModel({
    required this.id,
    required this.status,
    required this.totalTokenSpent,
    required this.totalPrice,
    required this.quantity,
    this.notes,
    required this.purchasedAt,
    required this.createdAt,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'] as int,
      status: json['status'] as String,
      totalTokenSpent: json['total_token_spent'] as int,
      totalPrice: json['total_price'] as String,
      quantity: json['quantity'] as int? ?? json['items_count'] as int? ?? 0,
      notes: json['notes'] as String?,
      purchasedAt: json['purchased_at'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'total_token_spent': totalTokenSpent,
      'total_price': totalPrice,
      'notes': notes,
      'purchased_at': purchasedAt,
      'created_at': createdAt,
    };
  }
}

class OrderAddressModel {
  final String fullName;
  final String phone;
  final String country;
  final String city;
  final String district;
  final String addressLine1;
  final String? addressLine2;
  final String postalCode;
  final String? notes;

  OrderAddressModel({
    required this.fullName,
    required this.phone,
    required this.country,
    required this.city,
    required this.district,
    required this.addressLine1,
    this.addressLine2,
    required this.postalCode,
    this.notes,
  });

  factory OrderAddressModel.fromJson(Map<String, dynamic> json) {
    return OrderAddressModel(
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      addressLine1: json['address_line1'] as String,
      addressLine2: json['address_line2'] as String?,
      postalCode: json['postal_code'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'country': country,
      'city': city,
      'district': district,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'postal_code': postalCode,
      'notes': notes,
    };
  }
}

class OrderItemModel {
  final int id;
  final int productId;
  final int quantity;
  final int tokenPriceAtPurchase;
  final String priceAtPurchase;
  final OrderProductModel product;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.tokenPriceAtPurchase,
    required this.priceAtPurchase,
    required this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      tokenPriceAtPurchase: json['token_price_at_purchase'] as int,
      priceAtPurchase: json['price_at_purchase'] as String,
      product: OrderProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'token_price_at_purchase': tokenPriceAtPurchase,
      'price_at_purchase': priceAtPurchase,
      'product': product.toJson(),
    };
  }
}

class OrderProductModel {
  final int id;
  final String name;
  final String image;
  final int tokenPrice;
  final String price;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.tokenPrice,
    required this.price,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      tokenPrice: json['token_price'] as int,
      price: json['price'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'token_price': tokenPrice,
      'price': price,
    };
  }
}
