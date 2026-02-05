class OrderResponse {
  final bool success;
  final List<OrderModel> data;
  final OrderMeta meta;

  OrderResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: OrderMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class OrderModel {
  final int id;
  final String status;
  final int itemsCount;
  final int totalTokenSpent;
  final String totalPrice;
  final String? notes;
  final String purchasedAt;
  final String createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.itemsCount,
    required this.totalTokenSpent,
    required this.totalPrice,
    this.notes,
    required this.purchasedAt,
    required this.createdAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      status: json['status'] as String,
      itemsCount: json['items_count'] as int,
      totalTokenSpent: json['total_token_spent'] as int,
      totalPrice: json['total_price'] as String,
      notes: json['notes'] as String?,
      purchasedAt: json['purchased_at'] as String,
      createdAt: json['created_at'] as String,
      items: json['items'] != null
          ? (json['items'] as List)
                .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'items_count': itemsCount,
      'total_token_spent': totalTokenSpent,
      'total_price': totalPrice,
      'notes': notes,
      'purchased_at': purchasedAt,
      'created_at': createdAt,
      'items': items.map((e) => e.toJson()).toList(),
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

class OrderMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  OrderMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory OrderMeta.fromJson(Map<String, dynamic> json) {
    return OrderMeta(
      currentPage: json['current_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      lastPage: json['last_page'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
    };
  }
}
