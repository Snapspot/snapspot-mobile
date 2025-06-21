// lib/features/home/domain/models/spot_model.dart

class SpotModel {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String districtId;
  final String districtName;
  final String provinceName;
  final String imageUrl;
  final String address;

  SpotModel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.districtId,
    required this.districtName,
    required this.provinceName,
    required this.imageUrl,
    required this.address
  });

  factory SpotModel.fromJson(Map<String, dynamic> json) {
    return SpotModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'N/A',
      description: json['description'] as String? ?? 'Không có mô tả.',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      districtId: json['districtId'] as String? ?? '',
      districtName: json['districtName'] as String? ?? '',
      provinceName: json['provinceName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }
}