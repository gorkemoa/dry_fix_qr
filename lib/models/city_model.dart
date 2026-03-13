class City {
  final int id;
  final String name;
  final int plate;

  City({required this.id, required this.name, required this.plate});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] as String? ?? '',
      plate: int.tryParse(json['plate']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'plate': plate};
  }
}

class CityListResponse {
  final bool success;
  final List<City> data;

  CityListResponse({required this.success, required this.data});

  factory CityListResponse.fromJson(Map<String, dynamic> json) {
    return CityListResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List? ?? [])
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
