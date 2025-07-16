
import 'package:snap_spot/features/home/domain/models/feedback_model.dart';

import 'service_model.dart';

class AgencyModel {
  final String id;
  final String name;
  final String address;
  final String fullname;
  final String description;
  final String phoneNumber;
  final String avatarUrl;
  final double rating;
  final String companyName;
  final List<ServiceModel> services;
  final List<FeedbackModel> feedbacks;


  AgencyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.fullname,
    required this.description,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.rating,
    required this.companyName,
    required this.services,
    required this.feedbacks,

  });

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      fullname: json['fullname'] ?? '',
      description: json['description'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      companyName: json['companyName'] ?? '',
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      feedbacks: (json['feedbackIds'] as List<dynamic>?)
          ?.map((e) => FeedbackModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}
