import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../models/UserRole.dart';
import '../models/tour_model.dart';
import '../widgets/Search.dart';
import '../widgets/tour_list_section.dart';
import 'Account/ProfilePage.dart';
import 'Account/Signin.dart';
// Add User model import if user profile creation is still needed
import '../../models/User.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

const categories = [
  {'name': 'Date', 'icon': Icons.date_range},
  {'name': 'Nature', 'icon': Icons.forest},
  {'name': 'Adventure', 'icon': Icons.hiking},
  {'name': 'Culinary', 'icon': Icons.restaurant},
  {'name': 'Wellness', 'icon': Icons.spa},
  {'name': 'Family', 'icon': Icons.family_restroom},
  {'name': 'Sustainable', 'icon': Icons.eco},
  {'name': 'Female Solo', 'icon': Icons.person},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TourModel> _tours = [];
  bool _isLoadingTours = true;
  String? _selectedCategory = 'Date';
  String? profileImageUrl;
  bool _isLoadingProfile = true;
  bool _isAuthenticated = false;
  StreamSubscription<AuthUser>? _authSubscription;

  @override
  void initState() {
    super.initState();
    debugPrint('HomeScreen initState called.');
    _checkAuthAndFetchUser().then((_) {
      _fetchTours();
    });
  }

  Future<void> _checkAuthAndFetchUser() async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      if (authUser != null) {
        debugPrint('✅ Authenticated as: ${authUser.userId}');
        await _checkAndCreateUserProfileIfNeeded(authUser.userId);
        _fetchUserData(authUser.userId);
      } else {
        setState(() {
          _isAuthenticated = false;
          profileImageUrl = null;
          _isLoadingProfile = false;
        });
      }
    } on AuthException catch (e) {
      safePrint('❌ Auth error: ${e.message}');
      setState(() {
        _isAuthenticated = false;
        profileImageUrl = null;
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _checkAndCreateUserProfileIfNeeded(String userId) async {
    try {
      final userQuery = '''
        query GetUser(\$id: ID!) {
          getUser(id: \$id) {
            id
          }
        }
      ''';

      final response = await Amplify.API
          .query(
            request: GraphQLRequest<String>(
              document: userQuery,
              variables: {'id': userId},
            ),
          )
          .response;

      final exists = response.data != null &&
          jsonDecode(response.data!)['getUser'] != null;

      if (!exists) {
        final attributes = await Amplify.Auth.fetchUserAttributes();
        final email = attributes
            .firstWhere((a) => a.userAttributeKey == AuthUserAttributeKey.email)
            .value;

        final newUser = User(
          id: userId,
          name: '',
          email: email,
          phone: '',
          nickname: '',
          profile: '',
          role: UserRole.USER,
        );

        final mutation = '''
          mutation CreateUser(\$input: CreateUserInput!) {
            createUser(input: \$input) {
              id
            }
          }
        ''';

        await Amplify.API
            .mutate(
              request: GraphQLRequest<String>(
                document: mutation,
                variables: {'input': newUser.toJson()},
              ),
            )
            .response;

        debugPrint("User profile created for ID: $userId");
      }
    } catch (e) {
      safePrint('Error checking/creating user profile: $e');
    }
  }

  Future<void> _fetchUserData(String userId) async {
    debugPrint('Fetching user data for userId: $userId');
    setState(() => _isLoadingProfile = true);
    try {
      final userQuery = '''
      query GetUser(\$id: ID!) {
        getUser(id: \$id) {
          id
          profile
        }
      }
    ''';
      final request = GraphQLRequest<String>(
        document: userQuery,
        variables: {'id': userId},
      );
      final response = await Amplify.API.query(request: request).response;

      debugPrint('User Data GraphQL raw response: ${response.data}');

      if (response.data != null) {
        final data = jsonDecode(response.data!) as Map<String, dynamic>;
        final userData = data['getUser'] as Map<String, dynamic>?;
        if (userData != null) {
          if (mounted) {
            setState(() {
              profileImageUrl = userData['profile'] as String?;
              _isAuthenticated = true;
              _isLoadingProfile = false;
            });
          }
          debugPrint('✅ Profile picture URL: $profileImageUrl');
        } else {
          debugPrint('User data not found in response.');
          setState(() {
            _isAuthenticated = true;
            _isLoadingProfile = false;
          });
        }
      } else {
        debugPrint('User Data GraphQL response.data was null.');
        setState(() {
          _isAuthenticated = true;
          _isLoadingProfile = false;
        });
      }
    } on AuthException catch (e) {
      safePrint('Auth error fetching user data: ${e.message}');
      setState(() {
        _isAuthenticated = false;
        _isLoadingProfile = false;
      });
    } on ApiException catch (e) {
      safePrint('API error fetching user data: ${e.message}');
      setState(() => _isLoadingProfile = false);
    } catch (e) {
      safePrint('Unexpected error fetching user data: $e');
      setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _fetchTours() async {
    final session = await Amplify.Auth.fetchAuthSession();
    final bool isSignedIn = session.isSignedIn;

    log('🔥-------Fetching tours...');
    const query = '''
      query ListTours {
        listTours {
          items {
            id
            title
            location
            description
            imageUrl
            passengers
            season
            category
            rating
            createdBy
            createdAt
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
            badge
          }
        }
      }
    ''';
    debugPrint("🔥 Is Authenticated: ${isSignedIn}");
    try {
      final request = GraphQLRequest<String>(
        document: query,
        authorizationMode: isSignedIn
            ? APIAuthorizationType.userPools // signed-in users
            : APIAuthorizationType.iam,
      );

      final response = await Amplify.API.query(request: request).response;

      log('🔥-------Tours GraphQL raw response: ${response}');

      final data = response.data;
      if (data != null) {
        final dataMap = jsonDecode(data) as Map<String, dynamic>;
        final toursData = dataMap['listTours']?['items'] as List<dynamic>?;

        if (toursData != null) {
          final List<TourModel> loadedTours = [];
          for (var item in toursData) {
            try {
              loadedTours.add(TourModel.fromJson(item as Map<String, dynamic>));
            } catch (e, stacktrace) {
              safePrint(
                  'ERROR: Failed to parse individual tour item: $item. Error: $e\nStacktrace: $stacktrace');
            }
          }

          setState(() {
            _tours = loadedTours;
            _isLoadingTours = false;
            debugPrint('Successfully loaded ${_tours.length} tours.');
          });
        } else {
          setState(() {
            _tours = [];
            _isLoadingTours = false;
            debugPrint(
                'Tours data "items" array was null or empty in GraphQL response.');
          });
        }
      } else {
        setState(() {
          _tours = [];
          _isLoadingTours = false;
          debugPrint('Tours GraphQL response.data was null.');
        });
      }
    } on ApiException catch (e) {
      log('🔥-------API error fetching tours: ${e.message}');
      setState(() => _isLoadingTours = false);
    } catch (e) {
      log('🔥-------Unexpected error fetching tours: $e');
      setState(() => _isLoadingTours = false);
    }
  }

  void _navigateToProfileOrAuth() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            _isAuthenticated ? const ProfilePage() : const SignInScreen(),
      ),
    );
    if (result == true) {
      final authUser = await Amplify.Auth.getCurrentUser();
      if (authUser != null) {
        await _checkAndCreateUserProfileIfNeeded(authUser.userId);
        _fetchUserData(authUser.userId);
      }
    }
  }

  Widget _buildProfileAvatar() {
    if (_isLoadingProfile) {
      return const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: CupertinoActivityIndicator(radius: 12),
      );
    }

    if (!_isAuthenticated ||
        profileImageUrl == null ||
        profileImageUrl!.isEmpty) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person, size: 25, color: Colors.grey),
      );
    }

    // Check if profileImageUrl is a full URL
    if (profileImageUrl!.startsWith('https://')) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey.shade300,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: profileImageUrl!,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const CupertinoActivityIndicator(radius: 10),
            errorWidget: (context, url, error) {
              debugPrint('❌ Failed to load profile image: $error');
              return const Icon(Icons.person, size: 22, color: Colors.grey);
            },
          ),
        ),
      );
    }

    // Treat as S3 key and generate pre-signed URL
    return FutureBuilder<StorageGetUrlResult>(
      future:
          Amplify.Storage.getUrl(path: StoragePath.fromString(profileImageUrl!))
              .result,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            child: CupertinoActivityIndicator(radius: 10),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          debugPrint('❌ Failed to get signed URL: ${snapshot.error}');
          return const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 22, color: Colors.white),
          );
        }

        final imageUrl = snapshot.data!.url.toString();
        return CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade300,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const CupertinoActivityIndicator(radius: 10),
              errorWidget: (context, url, error) {
                debugPrint('❌ Failed to load profile image: $error');
                return const Icon(Icons.person, size: 25, color: Colors.grey);
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildTourSections(String? category) {
    debugPrint(
        'Building tour sections for category: $category. Total tours loaded: ${_tours.length}');

    if (_tours.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No tours loaded. Please check your backend data and network connection.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
      ];
    }
    if (category == null) {
      return [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Please select a category to view tours.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
      ];
    }

    final sectionMap = {
      'Date': [
        {'title': 'Launching Soon', 'tag': 'Launching_Soon'},
        {'title': 'New Releases', 'tag': 'New_Releases'},
        {'title': 'Trending Today', 'tag': 'Trending_Today'},
        {'title': 'Selling Fast', 'tag': 'Selling_Fast'},
        {'title': 'Best Sellers', 'tag': 'Best_Sellers'},
      ],
      'Nature': [
        {'title': 'Scenic Trails', 'tag': 'Scenic_Trails'},
        {'title': 'Wildlife Encounters', 'tag': 'Wildlife_Encounters'},
        {'title': 'Lakes & Forests', 'tag': 'Lakes_Forests'},
        {'title': 'Eco Retreats', 'tag': 'Eco_Retreats'},
      ],
      'Adventure': [
        {'title': 'Thrill Seekers', 'tag': 'Thrill_Seekers'},
        {'title': 'Extreme Sports', 'tag': 'Extreme_Sports'},
        {'title': 'Mountain Escapes', 'tag': 'Mountain_Escapes'},
        {'title': 'Hiking & Climbing', 'tag': 'Hiking_Climbing'},
      ],
      'Culinary': [
        {'title': 'Food Trails', 'tag': 'Food_Trails'},
        {'title': 'Street Food Gems', 'tag': 'Street_Food'},
        {'title': 'Chef’s Specials', 'tag': 'Chef_Specials'},
        {'title': 'Local Delicacies', 'tag': 'Local_Delicacies'},
      ],
      'Wellness': [
        {'title': 'Spa Escapes', 'tag': 'Spa_Escapes'},
        {'title': 'Mindful Retreats', 'tag': 'Mindful_Retreats'},
        {'title': 'Yoga Journeys', 'tag': 'Yoga_Journeys'},
        {'title': 'Detox & Healing', 'tag': 'Detox_Healing'},
      ],
      'Family': [
        {'title': 'Fun for Kids', 'tag': 'Fun_for_Kids'},
        {'title': 'Family Packages', 'tag': 'Family_Packages'},
        {'title': 'Educational Trips', 'tag': 'Educational_Trips'},
        {'title': 'Theme Parks & More', 'tag': 'Theme_Parks'},
      ],
      'Sustainable': [
        {'title': 'Eco-Friendly Stays', 'tag': 'Eco_Friendly_Stays'},
        {'title': 'Green Adventures', 'tag': 'Green_Adventures'},
        {'title': 'Sustainable Travel', 'tag': 'Sustainable_Travel'},
        {'title': 'Community Tours', 'tag': 'Community_Tours'},
      ],
      'Female Solo': [
        {'title': 'Women-Only Retreats', 'tag': 'Women_Only_Retreats'},
        {'title': 'Empowering Journeys', 'tag': 'Empowering_Journeys'},
        {'title': 'Safe Solo Stays', 'tag': 'Safe_Solo_Stays'},
        {'title': 'Inspiring Stories', 'tag': 'Inspiring_Stories'},
      ],
    };

    final sections = sectionMap[category] ?? [];
    List<Widget> tourSectionsWidgets = [];
    bool hasToursForSelectedCategory = false;

    for (var section in sections) {
      final String sectionTitle =
          (section['title'] as String?) ?? 'Untitled Section';
      final String? sectionTag = section['tag'] as String?;

      final filteredTours = _tours.where((tour) {
        final bool categoryMatches = tour.category == category;
        final bool tagsContainSectionTag = tour.tags.contains(sectionTag);

        if (categoryMatches) {
          hasToursForSelectedCategory = true;
        }

        debugPrint(
            '  Tour "${tour.title}" (Category: ${tour.category}, Tags: ${tour.tags}) vs Section "$sectionTitle" (Selected Cat: $category, Section Tag: $sectionTag): Category Match=$categoryMatches, Tag Match=$tagsContainSectionTag');

        return categoryMatches && tagsContainSectionTag;
      }).toList();

      if (filteredTours.isNotEmpty) {
        debugPrint(
            '  Found ${filteredTours.length} tours for section "$sectionTitle". Adding section.');
        tourSectionsWidgets.add(TourListSection(
          title: sectionTitle,
          tours: filteredTours,
        ));
      } else {
        debugPrint(
            '  No tours found for section "$sectionTitle". Skipping section.');
      }
    }

    if (tourSectionsWidgets.isEmpty && hasToursForSelectedCategory) {
      final List<TourModel> allToursInSelectedCategory =
          _tours.where((tour) => tour.category == category).toList();
      if (allToursInSelectedCategory.isNotEmpty) {
        debugPrint(
            'No specific sections matched, but found ${allToursInSelectedCategory.length} tours for category "$category". Displaying under "All [Category] Tours".');
        tourSectionsWidgets.add(
          TourListSection(
            title: 'All $category Tours',
            tours: allToursInSelectedCategory,
          ),
        );
      }
    }

    if (tourSectionsWidgets.isEmpty) {
      debugPrint(
          'No tour sections to display for category: $category. _tours.isEmpty: ${_tours.isEmpty}, hasToursForSelectedCategory: $hasToursForSelectedCategory');
      return [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No trips found for "${category ?? 'selected category'}" matching any specific sections. Please ensure your tour data has matching categories and tags in Amplify.',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
      ];
    }

    return tourSectionsWidgets;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRAVEL',
          style: TextStyle(
              letterSpacing: 1, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: _buildProfileAvatar(),
            onPressed: _navigateToProfileOrAuth,
          ),
        ],
      ),
      body: _isLoadingTours
          ? const Center(
              child: CupertinoActivityIndicator(
                  radius: 20.0, color: CupertinoColors.activeBlue))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FilterSearchBar(),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final String? categoryName = cat['name'] as String?;
                        final bool isSelected =
                            _selectedCategory == categoryName;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedCategory = categoryName;
                            debugPrint('Category selected: $_selectedCategory');
                          }),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: isSelected
                                      ? Colors.blue
                                      : Colors.grey[200],
                                  child: Icon(
                                    cat['icon'] as IconData,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  (categoryName?.split('&').first.trim()) ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ..._buildTourSections(_selectedCategory),
                ],
              ),
            ),
    );
  }
}
