class District {
  final int id;
  final String name;
  final int cityId;

  District({required this.id, required this.name, required this.cityId});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'] as int,
      name: json['name'] as String,
      cityId: json['city_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'city_id': cityId};
  }
}

class DistrictListResponse {
  final bool success;
  final List<District> data;

  DistrictListResponse({required this.success, required this.data});

  factory DistrictListResponse.fromJson(Map<String, dynamic> json) {
    return DistrictListResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => District.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
