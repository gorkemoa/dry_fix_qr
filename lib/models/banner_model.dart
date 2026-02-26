class BannerProductModel {
  final int id;
  final String name;
  final String image;
  final String price;
  final int tokenPrice;

  BannerProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.tokenPrice,
  });

  factory BannerProductModel.fromJson(Map<String, dynamic> json) {
    return BannerProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as String,
      tokenPrice: json['token_price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'token_price': tokenPrice,
    };
  }
}

class BannerModel {
  final int id;
  final String title;
  final String image;
  final int productId;
  final int sortOrder;
  final int clickCount;
  final String startsAt;
  final String endsAt;
  final BannerProductModel? product;

  BannerModel({
    required this.id,
    required this.title,
    required this.image,
    required this.productId,
    required this.sortOrder,
    required this.clickCount,
    required this.startsAt,
    required this.endsAt,
    this.product,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      productId: json['product_id'] as int,
      sortOrder: json['sort_order'] as int,
      clickCount: json['click_count'] as int,
      startsAt: json['starts_at'] as String,
      endsAt: json['ends_at'] as String,
      product: json['product'] != null
          ? BannerProductModel.fromJson(
              json['product'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'product_id': productId,
      'sort_order': sortOrder,
      'click_count': clickCount,
      'starts_at': startsAt,
      'ends_at': endsAt,
      'product': product?.toJson(),
    };
  }
}

class BannerResponse {
  final List<BannerModel> data;
  final bool success;

  BannerResponse({required this.data, required this.success});

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      data: (json['data'] as List)
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      success: json['success'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'success': success,
    };
  }
}
