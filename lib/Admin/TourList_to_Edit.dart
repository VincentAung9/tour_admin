import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tour_agent_aws/Admin/tour_form_screen.dart';
import 'package:tour_agent_aws/models/Tour.dart';
import '../models/tour_model.dart'; // Import Tour
import 'Tour_Edit.dart'; // Import tour_api.dart for API calls

class TourListScreen extends StatefulWidget {
  const TourListScreen({super.key});

  @override
  State<TourListScreen> createState() => _TourListScreenState();
}

class _TourListScreenState extends State<TourListScreen> {
  List<Tour> _tours = []; // Changed to Tour
  List<Tour> _filteredTours = []; // For search functionality
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTours();
  }

  Future<void> _fetchTours() async {
    final session = await Amplify.Auth.fetchAuthSession();
    final bool isSignedIn = session.isSignedIn;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final request = GraphQLRequest<String>(
        document: '''
          query ListTours {
            listTours {
              items {
                id
                title
                location
                description
                imageUrl
                passengers
                country
                season
                rating
                category
                tags
                plans {
                  name
                  price
                }
                days {
                  title
                  subtitle
                  imageUrl
                }
                additionalInfo {
                  title
                  subtitle
                }
                createdBy
                createdAt
                updatedAt
              }
            }
          }
        ''',
        decodePath: 'listTours',
        authorizationMode: isSignedIn
            ? APIAuthorizationType.userPools
            : APIAuthorizationType.iam,
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty) {
        print('Amplify API Errors: ${response.errors}');
        print('Amplify API Data (on error): ${response.data}');
        throw Exception(
            'Failed to fetch tours: ${response.errors.first.message}');
      }

      final data = response.data;
      if (data != null) {
        final dataMap = jsonDecode(data) as Map<String, dynamic>;
        final toursData = dataMap['listTours']?['items'] as List<dynamic>?;

        if (toursData != null) {
          final List<Tour> loadedTours = [];
          for (var item in toursData) {
            try {
              loadedTours.add(Tour.fromJson(item as Map<String, dynamic>));
            } catch (e, stacktrace) {}
          }

          setState(() {
            _tours = loadedTours;
            _filteredTours = loadedTours; // Initialize filtered tours
            _isLoading = false;
          });
        } else {
          setState(() {
            _tours = [];
            _filteredTours = []; // Initialize filtered tours
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _tours = [];
          _filteredTours = []; // Initialize filtered tours
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching tours: $e';
        _isLoading = false;
      });
    }
  }

  void _filterTours(String query) {
    setState(() {
      _filteredTours = _tours
          .where(
              (tour) => tour.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToEditScreen(Tour tourData) {
    // Changed to Tour
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TourEditScreen(tourData: tourData.toJson()), // Convert to Map
      ),
    ).then((_) {
// Refresh the tour list after editing
      _fetchTours();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterTours,
              decoration: InputDecoration(
                hintText: 'Search by trip name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTours,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchTours,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _filteredTours.isEmpty
                  ? const Center(child: Text('No tours available'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two columns
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7, // Adjust as needed
                      ),
                      itemCount: _filteredTours.length,
                      itemBuilder: (context, index) {
                        final tour = _filteredTours[index];
                        return GestureDetector(
                          onTap: () => _navigateToEditScreen(tour),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: tour.imageUrl != null &&
                                          tour.imageUrl!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: tour.imageUrl!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                                  child: Icon(
                                                      Icons.broken_image,
                                                      size: 40)),
                                        )
                                      : const Center(
                                          child: Icon(Icons.image, size: 50)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tour.title ?? 'No Title',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        tour.location ?? 'No Location',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      if (tour.rating != null)
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors.amber, size: 16),
                                            const SizedBox(width: 4),
                                            Text(tour.rating!
                                                .toStringAsFixed(1)),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 300.ms);
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TourFormScreen(),
            ),
          ).then((_) {
// Refresh the tour list after creating a new tour
            _fetchTours();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
