class NotificationResponse {
  final bool success;
  final List<NotificationItem> data;
  final NotificationMeta meta;

  NotificationResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: NotificationMeta.fromJson(json['meta'] as Map<String, dynamic>),
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

class NotificationDetailResponse {
  final bool success;
  final NotificationItem data;

  NotificationDetailResponse({required this.success, required this.data});

  factory NotificationDetailResponse.fromJson(Map<String, dynamic> json) {
    return NotificationDetailResponse(
      success: json['success'] as bool,
      data: NotificationItem.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson()};
  }
}

class NotificationItem {
  final int id;
  final String topic;
  final String title;
  final String body;
  final String? imageUrl;
  final dynamic data;
  final String status;
  final String? sentAt;
  final String createdAt;

  NotificationItem({
    required this.id,
    required this.topic,
    required this.title,
    required this.body,
    this.imageUrl,
    this.data,
    required this.status,
    this.sentAt,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int,
      topic: json['topic'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      imageUrl: json['image_url'] as String?,
      data: json['data'],
      status: json['status'] as String,
      sentAt: json['sent_at'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'data': data,
      'status': status,
      'sent_at': sentAt,
      'created_at': createdAt,
    };
  }
}

class NotificationMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  NotificationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
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
