class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    id: json['id'],
    name: json['name'],
  );
}

class District {
  final String id;
  final String name;
  final Province province;

  District({required this.id, required this.name, required this.province});

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json['id'],
    name: json['name'],
    province: Province.fromJson(json['province']),
  );
}

class Place {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final District district;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.district,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    district: District.fromJson(json['district']),
  );
}
