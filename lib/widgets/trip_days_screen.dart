import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_text_styles.dart';

class TripDaysScreen extends StatelessWidget {
  final List<Map<String, dynamic>> days;

  const TripDaysScreen({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Itinerary'),
      ),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${index + 1}: ${day['title'] as String? ?? 'No title'}',
                    style: AppTextStyles.poppinsTitle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day['subtitle'] as String? ?? 'No description',
                    style: AppTextStyles.loraDescription,
                  ),
                  if (day['imageUrl'] is String && (day['imageUrl'] as String).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: day['imageUrl'] as String,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}