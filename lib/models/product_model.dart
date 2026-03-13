class ProductSingleResponse {
  final bool success;
  final ProductModel data;

  ProductSingleResponse({required this.success, required this.data});

  factory ProductSingleResponse.fromJson(Map<String, dynamic> json) {
    return ProductSingleResponse(
      success: json['success'] as bool,
      data: ProductModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class ProductResponse {
  final bool success;
  final List<ProductModel> data;
  final ProductMeta? meta;

  ProductResponse({required this.success, required this.data, this.meta});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null
          ? ProductMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}

class ProductCategory {
  final int id;
  final String name;
  final bool isActive;

  ProductCategory({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
    };
  }
}

class ProductModel {
  final int id;
  final int categoryId;
  final String name;
  final String? description;
  final String image;
  final String price;
  final int tokenPrice;
  final int stock;
  final bool isActive;
  final bool canBuy;
  final ProductCategory? category;
  final String createdAt;
  final String updatedAt;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.image,
    required this.price,
    required this.tokenPrice,
    required this.stock,
    required this.isActive,
    required this.canBuy,
    this.category,
    required this.createdAt,
    required this.updatedAt,
    List<String>? images,
  }) : images = images ?? [image];

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final mainImage = json['image'] as String;
    final jsonImages = json['images'] as List?;

    return ProductModel(
      id: json['id'] as int,
      categoryId: json['category_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: mainImage,
      price: json['price'] as String,
      tokenPrice: json['token_price'] as int,
      stock: json['stock'] as int,
      isActive: json['is_active'] as bool,
      canBuy: json['can_buy'] as bool,
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      images: jsonImages != null
          ? jsonImages.map((e) => e as String).toList()
          : [
              mainImage,
              mainImage,
              mainImage,
            ], // Mocking 3 images for UI testing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'token_price': tokenPrice,
      'stock': stock,
      'is_active': isActive,
      'can_buy': canBuy,
      'category': category?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'images': images,
    };
  }
}

class ProductMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  ProductMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory ProductMeta.fromJson(Map<String, dynamic> json) {
    return ProductMeta(
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
