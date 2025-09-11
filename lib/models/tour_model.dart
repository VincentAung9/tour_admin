import 'package:flutter/foundation.dart'; // For debugPrint, safePrint (via Amplify)

// TourModel to structure tour data
class TourModel {
  final String id;
  final String title;
  final String location;
  final String description;
  final String imageUrl;
  final String passengers;
  final String season;
  final String category;
  final double rating;
  final String createdBy;
  final String createdAt;
  final String? country;
  final List<String> tags;
  final List<Map<String, dynamic>>? plans;
  final List<Map<String, dynamic>>? days;
  final List<Map<String, dynamic>>? additionalInfo;
  final String? badge;

  TourModel({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.passengers,
    required this.season,
    required this.category,
    required this.rating,
    required this.createdBy,
    required this.createdAt,
    required this.tags,
    this.plans,
    this.days,
    this.additionalInfo,
    this.badge,
    this.country,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    debugPrint(
        'Attempting to parse Tour JSON: ${json['id']} - ${json['title']}');
    debugPrint(
        'Raw passengers value: ${json['passengers']} (Type: ${json['passengers']?.runtimeType})');
    debugPrint(
        'Raw rating value: ${json['rating']} (Type: ${json['rating']?.runtimeType})');
    debugPrint(
        'Raw badge value: ${json['badge']} (Type: ${json['badge']?.runtimeType})');
    debugPrint(
        'Raw plans value: ${json['plans']} (Type: ${json['plans']?.runtimeType})');

    final String title = json['title'] as String;
    final String location = json['location'] as String;
    final String description = json['description'] as String;
    final String imageUrl = json['imageUrl'] as String;
    final String passengers = json['passengers'] as String;
    final String season = json['season'] as String;
    final String category = json['category'] as String;
    final String createdBy = json['createdBy'] as String;
    final String createdAt = json['createdAt'] as String;
    final String? country = json['country'] as String?;

    double parsedRating;
    if (json['rating'] is double) {
      parsedRating = json['rating'] as double;
    } else if (json['rating'] is int) {
      parsedRating = (json['rating'] as int).toDouble();
    } else if (json['rating'] is String) {
      parsedRating = double.tryParse(json['rating'] as String) ?? 0.0;
    } else {
      parsedRating = 0.0;
    }

    final List<String> tags = (json['tags'] is List)
        ? List<String>.from(json['tags'].map((e) => e.toString()))
        : [];

    List<Map<String, dynamic>>? parsedPlans;
    if (json['plans'] is List) {
      parsedPlans = (json['plans'] as List<dynamic>).map((e) {
        // Ensure price is handled as String as per your schema
        return {
          'name': e['name'] as String,
          'price': e['price'] as String,
        };
      }).toList();
    }

    List<Map<String, dynamic>>? parsedDays;
    if (json['days'] is List) {
      parsedDays = (json['days'] as List<dynamic>).map((e) {
        return {
          'title': e['title'] as String,
          'subtitle': e['subtitle'] as String,
          'imageUrl': e['imageUrl'] as String,
        };
      }).toList();
    }

    List<Map<String, dynamic>>? parsedAdditionalInfo;
    if (json['additionalInfo'] is List) {
      parsedAdditionalInfo = (json['additionalInfo'] as List<dynamic>).map((e) {
        return {
          'title': e['title'] as String,
          'subtitle': e['subtitle'] as String,
        };
      }).toList();
    }

    return TourModel(
      id: json['id'] as String,
      title: title,
      location: location,
      description: description,
      imageUrl: imageUrl,
      passengers: passengers,
      season: season,
      category: category,
      rating: parsedRating,
      createdBy: createdBy,
      createdAt: createdAt,
      tags: tags,
      plans: parsedPlans,
      days: parsedDays,
      additionalInfo: parsedAdditionalInfo,
      badge: json['badge'] as String?,
      country: country,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'passengers': passengers,
      'season': season,
      'category': category,
      'rating': rating,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'tags': tags,
      'plans': plans,
      'days': days,
      'additionalInfo': additionalInfo,
      'badge': badge,
      'country': country,
    };
  }
}
