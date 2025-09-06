import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/tour_model.dart';
import '../screens/trip_days_screen.dart';

// TourListSection widget
class TourListSection extends StatelessWidget {
  final String title;
  final List<TourModel> tours;

  const TourListSection({super.key, required this.title, required this.tours});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tours.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => TourCard(tour: tours[index]),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}