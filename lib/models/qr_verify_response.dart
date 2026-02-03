class QrVerifyResponse {
  final bool success;
  final String result;
  final String message;
  final int? earned;
  final int? balance;
  final QrVerifyDetail? qr;
  final ProductVerifyDetail? product;

  QrVerifyResponse({
    required this.success,
    required this.result,
    required this.message,
    this.earned,
    this.balance,
    this.qr,
    this.product,
  });

  factory QrVerifyResponse.fromJson(Map<String, dynamic> json) {
    return QrVerifyResponse(
      success: json['success'] as bool,
      result: json['result'] as String? ?? '',
      message: json['message'] as String? ?? '',
      earned: json['earned'] as int?,
      balance: json['balance'] as int?,
      qr: json['qr'] != null ? QrVerifyDetail.fromJson(json['qr']) : null,
      product: json['product'] != null
          ? ProductVerifyDetail.fromJson(json['product'])
          : null,
    );
  }
}

class QrVerifyDetail {
  final int id;
  final String code;
  final int tokenValue;
  final String status;
  final int productId;
  final int? usedByUserId;
  final String? usedAt;
  final String? expiresAt;

  QrVerifyDetail({
    required this.id,
    required this.code,
    required this.tokenValue,
    required this.status,
    required this.productId,
    this.usedByUserId,
    this.usedAt,
    this.expiresAt,
  });

  factory QrVerifyDetail.fromJson(Map<String, dynamic> json) {
    return QrVerifyDetail(
      id: json['id'] as int,
      code: json['code'] as String,
      tokenValue: json['token_value'] as int,
      status: json['status'] as String,
      productId: json['product_id'] as int,
      usedByUserId: json['used_by_user_id'] as int?,
      usedAt: json['used_at'] as String?,
      expiresAt: json['expires_at'] as String?,
    );
  }
}

class ProductVerifyDetail {
  final int id;
  final String name;
  final String image;
  final String price;
  final int tokenPrice;
  final int stock;
  final bool isActive;

  ProductVerifyDetail({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.tokenPrice,
    required this.stock,
    required this.isActive,
  });

  factory ProductVerifyDetail.fromJson(Map<String, dynamic> json) {
    return ProductVerifyDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as String,
      tokenPrice: json['token_price'] as int,
      stock: json['stock'] as int,
      isActive: json['is_active'] as bool,
    );
  }
}
