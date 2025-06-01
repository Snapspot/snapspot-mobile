class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
  );
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
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    province: json['province'] != null
        ? Province.fromJson(json['province'])
        : Province(id: '', name: ''),
  );
}

class Service {
  final String id;
  final String name;
  final String color;

  Service({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    color: json['color'] ?? '',
  );
}

class Agency {
  final String id;
  final String name;
  final String fullName;
  final double rating;
  final List<Service> services;

  Agency({
    required this.id,
    required this.name,
    required this.fullName,
    required this.rating,
    required this.services,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    fullName: json['fullName'] ?? '',
    rating: (json['rating'] ?? 0).toDouble(),
    services: (json['services'] as List?)
        ?.map((s) => Service.fromJson(s))
        .toList() ??
        [],
  );
}

class Place {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final District district;
  final List<Agency> agencies;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.district,
    required this.agencies,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    address: json['address'] ?? '',
    district: json['district'] != null
        ? District.fromJson(json['district'])
        : District(id: '', name: '', province: Province(id: '', name: '')),
    agencies: (json['agencies'] as List?)
        ?.map((a) => Agency.fromJson(a))
        .toList() ??
        [],
  );
}
