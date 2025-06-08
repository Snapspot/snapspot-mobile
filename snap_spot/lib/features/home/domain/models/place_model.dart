// lib/features/home/domain/models/place_model.dart

class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
  );

  // For default empty instance
  static Province get empty => Province(id: '', name: '');
}

class District {
  final String id;
  final String name;
  final Province province;

  District({
    required this.id,
    required this.name,
    required this.province,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    province: json['province'] != null
        ? Province.fromJson(json['province'] as Map<String, dynamic>)
        : Province.empty,
  );

  // For default empty instance
  static District get empty => District(id: '', name: '', province: Province.empty);
}

class Service {
  final String id;
  final String name;
  final String color; // Lưu màu dưới dạng chuỗi Hex

  Service({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? 'N/A',
    color: json['color'] as String? ?? '808080', // Default grey
  );
}

class RatingModel {
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double stars;
  final String comment;
  final DateTime date;

  RatingModel({
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.stars,
    required this.comment,
    required this.date,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return RatingModel(
      userId: json['userId'] as String? ??
          user?['id'] as String? ??
          json['id'] as String? ?? // Fallback if userId is in 'id' field of rating itself
          'unknown_user_${DateTime.now().millisecondsSinceEpoch}', // Ensure unique unknown ID
      userName: json['userName'] as String? ?? user?['fullName'] as String? ?? 'Người dùng ẩn danh',
      userAvatarUrl: json['userAvatarUrl'] as String? ?? user?['avatarUrl'] as String?,
      stars: (json['stars'] as num?)?.toDouble() ?? (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String? ?? json['content'] as String? ?? 'Không có bình luận.',
      date: json['date'] != null && (json['date'] as String).isNotEmpty
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : json['createdAt'] != null && (json['createdAt'] as String).isNotEmpty
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class Agency {
  final String id;
  final String name;
  final String fullName;
  final double rating;
  final String? logoUrl;
  final String? description;
  final List<Service> services;
  final List<RatingModel> individualRatings;
  final String? phoneNumber;
  // final String? companyId; // Optional: if needed for other logic
  // final String? spotId;    // Optional
  // final bool? isApproved;  // Optional

  Agency({
    required this.id,
    required this.name,
    required this.fullName,
    required this.rating,
    this.logoUrl,
    this.description,
    required this.services,
    required this.individualRatings,
    this.phoneNumber,
    // this.companyId,
    // this.spotId,
    // this.isApproved,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? 'N/A',
    fullName: json['fullName'] as String? ?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    logoUrl: json['avatarUrl'] as String?,
    description: json['description'] as String?,
    services: (json['services'] as List<dynamic>?)
        ?.map((s) => Service.fromJson(s as Map<String, dynamic>))
        .toList() ??
        [],
    individualRatings: (json['individualRatings'] as List<dynamic>?) // Prioritize this key as per mock_data
        ?.map((r) => RatingModel.fromJson(r as Map<String, dynamic>))
        .toList() ??
        (json['ratings'] as List<dynamic>?) // Fallback
            ?.map((r) => RatingModel.fromJson(r as Map<String, dynamic>))
            .toList() ??
        [],
    phoneNumber: json['phoneNumber'] as String?,
    // companyId: json['companyId'] as String?,
    // spotId: json['spotId'] as String?,
    // isApproved: json['isApproved'] as bool?,
  );
}

class Place {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final District district;
  final double? latitude;
  final double? longitude;
  final List<Agency> agencies;

  // Fields for specific place types (like FPT)
  final String? view360Url;
  final List<Service>? mainServices;
  final List<RatingModel>? placeRatings; // Ratings for the Place itself

  final String? parentCompanyName;
  final String? parentCompanyHeadquarters;
  final String? parentCompanyImageUrl;
  final double? parentCompanyRating;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.agencies,
    this.view360Url,
    this.mainServices,
    this.placeRatings,
    this.parentCompanyName,
    this.parentCompanyHeadquarters,
    this.parentCompanyImageUrl,
    this.parentCompanyRating,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? 'N/A',
    description: json['description'] as String? ?? 'Không có mô tả.',
    imageUrl: json['imageUrl'] as String? ?? '', // Consider a default placeholder URL
    address: json['address'] as String? ?? 'N/A',
    district: json['district'] != null
        ? District.fromJson(json['district'] as Map<String, dynamic>)
        : District.empty,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    agencies: (json['agencies'] as List<dynamic>?)
        ?.map((a) => Agency.fromJson(a as Map<String, dynamic>))
        .toList() ??
        [],
    view360Url: json['view360Url'] as String?,
    mainServices: (json['mainServices'] as List<dynamic>?)
        ?.map((s) => Service.fromJson(s as Map<String, dynamic>))
        .toList(),
    placeRatings: (json['placeRatings'] as List<dynamic>?) // Prioritize this key
        ?.map((r) => RatingModel.fromJson(r as Map<String, dynamic>))
        .toList() ??
        (json['ratings'] as List<dynamic>?) // Fallback for general ratings key
            ?.map((r) => RatingModel.fromJson(r as Map<String, dynamic>))
            .toList() ??
        [],
    parentCompanyName: json['parentCompanyName'] as String?,
    parentCompanyHeadquarters: json['parentCompanyHeadquarters'] as String?,
    parentCompanyImageUrl: json['parentCompanyImageUrl'] as String?,
    parentCompanyRating: (json['parentCompanyRating'] as num?)?.toDouble(),
  );
}