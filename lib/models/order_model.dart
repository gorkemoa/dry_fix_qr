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

  OrderModel({
    required this.id,
    required this.status,
    required this.itemsCount,
    required this.totalTokenSpent,
    required this.totalPrice,
    this.notes,
    required this.purchasedAt,
    required this.createdAt,
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
