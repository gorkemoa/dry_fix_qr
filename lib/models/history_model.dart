class HistoryResponse {
  final bool success;
  final List<HistoryItem> data;
  final HistoryMeta meta;

  HistoryResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((e) => HistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: HistoryMeta.fromJson(json['meta'] as Map<String, dynamic>),
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

class HistoryItem {
  final int id;
  final String direction;
  final int tokenAmount;
  final String reason;
  final String note;
  final QrModel? qr;
  final int? orderId;
  final String createdAt;

  HistoryItem({
    required this.id,
    required this.direction,
    required this.tokenAmount,
    required this.reason,
    required this.note,
    this.qr,
    this.orderId,
    required this.createdAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as int,
      direction: json['direction'] as String,
      tokenAmount: json['token_amount'] as int,
      reason: json['reason'] as String,
      note: json['note'] as String,
      qr: json['qr'] != null
          ? QrModel.fromJson(json['qr'] as Map<String, dynamic>)
          : null,
      orderId: json['order_id'] as int?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'direction': direction,
      'token_amount': tokenAmount,
      'reason': reason,
      'note': note,
      'qr': qr?.toJson(),
      'order_id': orderId,
      'created_at': createdAt,
    };
  }
}

class QrModel {
  final int id;
  final String code;
  final int productId;
  final ProductModel product;

  QrModel({
    required this.id,
    required this.code,
    required this.productId,
    required this.product,
  });

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
      id: json['id'] as int,
      code: json['code'] as String,
      productId: json['product_id'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'product_id': productId,
      'product': product.toJson(),
    };
  }
}

class ProductModel {
  final int id;
  final String name;
  final String image;

  ProductModel({required this.id, required this.name, required this.image});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}

class HistoryMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  HistoryMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory HistoryMeta.fromJson(Map<String, dynamic> json) {
    return HistoryMeta(
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
