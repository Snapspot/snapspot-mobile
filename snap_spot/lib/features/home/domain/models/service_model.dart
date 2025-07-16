class ServiceModel {
  final String id;
  final String name;
  final String color;

  ServiceModel({
    required this.id,
    required this.name,
    required this.color,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}
