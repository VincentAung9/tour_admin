import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/tour_model.dart'; // Import TourModel
import '../widgets/app_text_styles.dart'; // Import AppTextStyles
import '../widgets/photo_gallery_screen.dart'; // Import PhotoGalleryScreen
import '../widgets/trip_days_screen.dart';
import 'Account/Create_Account.dart';
import 'Account/Signin.dart';
import 'checkout.dart'; // Import TripDaysScreen

void showDateOptions(BuildContext context, TourModel tour) {
  final List<Map<String, dynamic>> plans = tour.plans ?? [];

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    elevation: 8,
    builder: (context) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a Plan',
              style: AppTextStyles.poppinsTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...plans.asMap().entries.map((entry) {
              final index = entry.key;
              final plan = entry.value;
              final int availability =
                  int.tryParse(plan['availability']?.toString() ?? '0') ?? 0;
              final availabilityColor =
              availability > 5
                  ? Colors.green
                  : availability > 0
                  ? Colors.orange
                  : Colors.red;

              return Column(
                children: [
                  _buildDateOption(
                    context: context,
                    tour: tour,
                    date: plan['name'] ?? 'Plan ${index + 1}',
                    price: 'SGD ${plan['price'] ?? '0'}',
                    availability: plan['availability'] ?? 'Spots available',
                    availabilityColor: availabilityColor,
                  ),
                  if (index < plans.length - 1) const Divider(height: 24),
                ],
              );
            }),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAccountView())), // Navigating to CreateAccountView
                child: Text(
                  'Request new plan',
                  style: AppTextStyles.poppinsDescription.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildDateOption({
  required BuildContext context,
  required TourModel tour,
  required String date,
  required String price,
  required String availability,
  required Color availabilityColor,
}) {
  return Row(
    children: [
      Expanded(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            date,
            style: AppTextStyles.poppinsDescription.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              availability,
              style: AppTextStyles.poppinsDescription.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: availabilityColor,
              ),
            ),
          ),
        ),
      ),
      Column(
        children: [
          Text(
            price,
            style: AppTextStyles.poppinsDescription.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              try {
                final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;

                if (session.isSignedIn) {
                  // User is logged in, proceed to checkout
                  final selectedPlan = {
                    'price': double.tryParse(price.replaceAll('SGD ', '')) ?? 0.0,
                    'date': date,
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(
                        tour: tour,
                        selectedPlan: selectedPlan,
                      ),
                    ),
                  );
                } else {
                  // User is not logged in, redirect to sign-in page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please sign in to continue')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                  );
                }
              } catch (e) {
                // Handle any errors (e.g., network issues, Amplify configuration errors)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('An error occurred. Please try again.')),
                );
                // Optionally redirect to sign-in page even on error, as it might be due to auth issues
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Choose',
              style: AppTextStyles.poppinsDescription.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// Helper function to build "What's included" sections
Widget buildSection({
  required IconData icon,
  required String title,
  required String description,
}) {
  return Expanded(
    child: Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTextStyles.poppinsDescription.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          description,
          style: AppTextStyles.loraDescription.copyWith(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// Helper function to build Itinerary Items
Widget buildItineraryItem(String title, String subtitle) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.poppinsDescription.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTextStyles.loraDescription),
      ],
    ),
  );
}

// Helper function to build "Why choose us" rows
Widget buildReasonRow(IconData icon, String title, String description) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 24, color: Colors.green[700]),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.poppinsDescription.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(description, style: AppTextStyles.loraDescription),
          ],
        ),
      ),
    ],
  );
}

// The main detail screen, now correctly using TourModel
class TourDetailScreen extends StatelessWidget {
  final TourModel tour; // Receives the TourModel directly

  const TourDetailScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    // Access properties directly using dot notation.
    // tour.plans, tour.days, tour.additionalInfo are already List<Map<String, dynamic>>
    final plans = tour.plans ?? [];
    final days = tour.days ?? [];
    final additionalInfo = tour.additionalInfo ?? [];

    final ScrollController _scrollController =
    ScrollController(); // Need to manage this if screen is StatelessWidget

    // Note: For a StatelessWidget, a ScrollController should ideally be provided
    // from a parent StatefulWidget or managed differently if its state needs to persist.
    // For simplicity in this example, it's defined here, but be aware for complex cases.

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController, // Assign the controller
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: tour.imageUrl, // Use tour.imageUrl
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => const Center(
                        child: CupertinoActivityIndicator(
                          radius: 20.0,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      errorWidget:
                          (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Back',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          // TODO: Implement share functionality
                        },
                        tooltip: 'Share',
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // This IconButton uses Semantics for accessibility, but its icon and onPressed are conflicting.
                  // If it's meant to be a back button, it's redundant with the one in Stack.
                  // If it's for something else (e.g., volume control as icon suggests), clarify.
                  Semantics(
                    label: 'Mute/Unmute',
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.volume_off),
                      onPressed: () {
                        /* Add actual functionality if not for back */
                      },
                    ),
                  ).animate().fadeIn(duration: 600.ms),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PhotoGalleryScreen(
                            tourImageUrl:
                            tour.imageUrl, // Pass tour.imageUrl
                            days: days, // Pass the parsed days list
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Show all photos',
                      style: AppTextStyles.poppinsDescription,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                tour.title, // Use tour.title
                style: AppTextStyles.poppinsTitle,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0.0),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.black, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    tour.location, // Use tour.location
                    style: AppTextStyles.loraDescription,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tour.rating.toStringAsFixed(1), // Use tour.rating
                    style: AppTextStyles.poppinsDescription.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tour.description, // Use tour.description
                      style: AppTextStyles.loraDescription,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
              const SizedBox(height: 10),

              Text(
                tour.tags.isNotEmpty ? '#${tour.tags.join(' #')}' : '#NoTags',
                style: AppTextStyles.poppinsDescription.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
              const SizedBox(height: 20),
              if (days.isNotEmpty) // Only show Itinerary Preview if days exist
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Itinerary Preview',
                      style: AppTextStyles.poppinsTitle.copyWith(
                        fontSize: 20,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0.0),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          final day = days[index];
                          return GestureDetector(
                            onTap:
                                () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TripDaysScreen(
                                  days: days,
                                ), // Pass the full days list
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        day['imageUrl'] as String? ?? '',
                                        height: 120,
                                        width: 160,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => const Center(
                                          child: CupertinoActivityIndicator(
                                            radius: 20.0,
                                            color:
                                            CupertinoColors.activeBlue,
                                          ),
                                        ),
                                        errorWidget:
                                            (context, url, error) =>
                                        const Icon(Icons.error),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'Day ${index + 1}',
                                          style: AppTextStyles
                                              .poppinsDescription
                                              .copyWith(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    day['title'] as String? ?? 'No title',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Text(
                'Why we love this trip',
                style: AppTextStyles.poppinsTitle.copyWith(fontSize: 20),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0.0),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Awe-inspiring Starry Skies',
                          style: AppTextStyles.poppinsDescription.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'See a lifetime worth of stars!',
                          style: AppTextStyles.loraDescription.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star_border, color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ride Camels',
                          style: AppTextStyles.poppinsDescription.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Experience the magic of camel riding!',
                          style: AppTextStyles.loraDescription.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star_border, color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sandboarding',
                          style: AppTextStyles.poppinsDescription.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Feel the thrill of sandboarding!',
                          style: AppTextStyles.loraDescription.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // This seems to be a duplicate description in the UI. Keep or remove as needed.
              Text(
                tour.description,
                style: AppTextStyles.loraDescription,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0.0),
              const SizedBox(height: 20),
              Text(
                'What\'s included',
                style: AppTextStyles.poppinsTitle.copyWith(fontSize: 20),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0.0),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSection(
                    icon: Icons.restaurant,
                    title: 'food',
                    description: 'Meals included as per itinerary',
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.2, end: 0.0),
                  buildSection(
                    icon: Icons.directions_car,
                    title: 'transport',
                    description: 'Private transfers included',
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideX(begin: 0.2, end: 0.0),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSection(
                    icon: Icons.backpack,
                    title: 'equipment',
                    description: 'Hiking and camping gear provided',
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.2, end: 0.0),
                  buildSection(
                    icon: Icons.hotel,
                    title: 'lodging',
                    description: 'Accommodation as per itinerary',
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideX(begin: 0.2, end: 0.0),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSection(
                    icon: Icons.person,
                    title: 'instructor',
                    description: 'English-speaking guide',
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.2, end: 0.0),
                  buildSection(
                    icon: Icons.flight,
                    title: 'flight',
                    description: 'Flights not included',
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideX(begin: 0.2, end: 0.0),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'MORE DETAILS',
                style: AppTextStyles.poppinsDescription.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  letterSpacing: 0.8,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ITINERARY',
                    style: AppTextStyles.poppinsTitle.copyWith(
                      fontSize: 20,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0.0),
                  Semantics(
                    label: 'Share',
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // TODO: Implement share functionality
                      },
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                ],
              ),
              const SizedBox(height: 10),
              if (days
                  .isNotEmpty) // Ensure this section only shows if days are available
                ...days.asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  return buildItineraryItem(
                    'Day ${index + 1}: ${day['title'] as String? ?? 'No title'}',
                    day['subtitle'] as String? ?? 'No description',
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(
                    begin: 0.2,
                    end: 0.0,
                    delay: (200 * (index + 1)).ms,
                  );
                }),
              const SizedBox(height: 20),
              Text(
                'Additional Information',
                style: AppTextStyles.poppinsTitle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 10),
              if (additionalInfo
                  .isNotEmpty) // Ensure this section only shows if additionalInfo is available
                ...additionalInfo.asMap().entries.map((entry) {
                  final index = entry.key;
                  final info = entry.value;
                  return ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    initiallyExpanded:
                    index ==
                        0, // Changed to 0 to expand the first by default
                    title: Text(
                      info['title'] as String? ?? 'Info ${index + 1}',
                      style: AppTextStyles.poppinsDescription.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.add),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          info['subtitle'] as String? ?? 'No details available',
                          style: AppTextStyles.loraDescription,
                        ),
                      ),
                    ],
                  );
                }),
              if (additionalInfo.isEmpty)
                const ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'No Additional Info',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(Icons.add),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text('No additional information provided.'),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              Text(
                'Why choose to travel with us?',
                style: AppTextStyles.poppinsTitle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildReasonRow(
                    Icons.hiking,
                    'Guides our community trust',
                    'We work closely with our local partners.',
                  ),
                  const SizedBox(height: 16),
                  buildReasonRow(
                    Icons.groups,
                    'Can’t do alone adventures',
                    'Adventures best experienced with a group.',
                  ),
                  const SizedBox(height: 16),
                  buildReasonRow(
                    Icons.flag,
                    'Just show up and enjoy',
                    'We handle the logistics for you.',
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Have questions?',
                style: AppTextStyles.poppinsTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Contact us on Telegram and we will do our best to help you out ✌️',
                style: AppTextStyles.loraDescription,
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Launch Telegram contact logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Telegram Contact'),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Text(
                        'Back to top ⤴️',
                        style: AppTextStyles.poppinsDescription.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plans.isNotEmpty && plans[0]['price'] != null
                            ? 'From SGD ${plans[0]['price']}/pax'
                            : 'No pricing available',
                        style: AppTextStyles.poppinsTitle.copyWith(
                          fontSize: 16,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.2, end: 0.0),
                      Text(
                        '${plans.length} ${plans.length == 1 ? 'date' : 'dates'} available',
                        style: AppTextStyles.poppinsDescription.copyWith(
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => showDateOptions(context, tour),
                    icon: const Icon(Icons.date_range),
                    label: const Text('Show Dates'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: AppTextStyles.poppinsDescription.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ).animate().slideY(begin: 0.3, end: 0.0, duration: 600.ms),
      ),
    );
  }
}
