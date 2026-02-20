class SupportMessageResponse {
  final bool success;
  final SupportMessagePaginationData data;

  SupportMessageResponse({required this.success, required this.data});

  factory SupportMessageResponse.fromJson(Map<String, dynamic> json) {
    return SupportMessageResponse(
      success: json['success'] == true,
      data: SupportMessagePaginationData.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson()};
  }
}

class SupportMessagePaginationData {
  final int currentPage;
  final List<SupportMessage> data;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  SupportMessagePaginationData({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory SupportMessagePaginationData.fromJson(Map<String, dynamic> json) {
    return SupportMessagePaginationData(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      data:
          (json['data'] as List?)
              ?.map((e) => SupportMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      firstPageUrl: json['first_page_url']?.toString(),
      from: (json['from'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      lastPageUrl: json['last_page_url']?.toString(),
      links:
          (json['links'] as List?)
              ?.map((e) => PaginationLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      nextPageUrl: json['next_page_url']?.toString(),
      path: json['path']?.toString() ?? '',
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
      prevPageUrl: json['prev_page_url']?.toString(),
      to: (json['to'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class SupportMessageDetailResponse {
  final bool success;
  final SupportMessage data;

  SupportMessageDetailResponse({required this.success, required this.data});

  factory SupportMessageDetailResponse.fromJson(Map<String, dynamic> json) {
    return SupportMessageDetailResponse(
      success: json['success'] == true,
      data: SupportMessage.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson()};
  }
}

class SupportMessage {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String createdAt;

  SupportMessage({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'created_at': createdAt,
    };
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  PaginationLink({this.url, required this.label, required this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url']?.toString(),
      label: json['label']?.toString() ?? '',
      active: json['active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label, 'active': active};
  }
}
