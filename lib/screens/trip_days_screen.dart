import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/tour_model.dart';
import '../screens/detail_page.dart';

class TourCard extends StatelessWidget {
  final TourModel tour;

  // NEW props for currency conversion
  final double? exchangeRate;        // SGD → target
  final String targetCurrency;       // e.g. "CNY"
  final bool showBothCurrencies;     // show both SGD + target

  const TourCard({
    super.key,
    required this.tour,
    this.exchangeRate,
    this.targetCurrency = 'SGD', // Changed default to SGD
    this.showBothCurrencies = false,
  });

  String _formatPrice({
    required double sgd,
    double? rate,
    required String target,
    required bool both,
  }) {
    final sgdText = 'SGD ${sgd.toStringAsFixed(2)}';
    if (both) {
      if (rate == null || rate == 0) return sgdText;
      final converted = sgd * rate;
      final tgtText = '$target ${converted.toStringAsFixed(2)}';
      return '$sgdText · $tgtText';
    } else {
      // Always show SGD when only one currency
      return sgdText;
    }
  }

  @override
  Widget build(BuildContext context) {
    // pick a base price (first plan as example)
    double sgdPrice = 0;
    if (tour.plans?.isNotEmpty ?? false) {
      final first = tour.plans!.first;
      final price = first['price'];
      if (price is num) {
        sgdPrice = price.toDouble();
      } else if (price is String) {
        sgdPrice = double.tryParse(price) ?? 0;
      }
    }

    final priceText = _formatPrice(
      sgd: sgdPrice,
      rate: exchangeRate,
      target: targetCurrency,
      both: showBothCurrencies,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TourDetailScreen(tour: tour),
          ),
        );
      },
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image with badge ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: tour.imageUrl,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          radius: 20.0,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, size: 60),
                  ),
                ),
                if (tour.badge != null && tour.badge!.isNotEmpty)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tour.badge!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // --- Info section ---
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tour.location,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tour.season,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (sgdPrice > 0)
                    showBothCurrencies
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SGD ${sgdPrice.toStringAsFixed(2)} / pax',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (exchangeRate != null && exchangeRate != 0)
                                Text(
                                  '$targetCurrency ${(sgdPrice * exchangeRate!).toStringAsFixed(2)} / pax',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                priceText,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                " / pax",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}
