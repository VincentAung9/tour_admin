import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// Assuming TourModel is accessible, either through a shared model file or directly from home_screen if bundled
// For this example, TourModel is in lib/models/tour_model.dart
// import '../models/tour_model.dart'; // No longer needed here if we only pass imageUrls, but good practice for full structure

class PhotoGalleryScreen extends StatelessWidget {
  final String tourImageUrl;
  final List<Map<String, dynamic>>? days;

  const PhotoGalleryScreen({super.key, required this.tourImageUrl, this.days});

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [tourImageUrl];
    days?.forEach((day) {
      // Safely access imageUrl, ensuring it's a String before adding
      if (day['imageUrl'] is String && (day['imageUrl'] as String).isNotEmpty) {
        imageUrls.add(day['imageUrl'] as String);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
      ),
      body: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              imageUrl: imageUrls[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 60),
            ),
          );
        },
      ),
    );
  }
}