import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../app_debouncer.dart';
import '../models/UserRole.dart';
import '../models/tour_model.dart';
import '../widgets/Search.dart';
import '../widgets/tour_list_section.dart';
import 'Account/ProfilePage.dart';
import 'Account/Signin.dart';
import '../../models/User.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:shimmer/shimmer.dart';

const categories = [
  {'key': 'categories.date', 'icon': Icons.date_range},
  {'key': 'categories.nature', 'icon': Icons.forest},
  {'key': 'categories.adventure', 'icon': Icons.hiking},
  {'key': 'categories.culinary', 'icon': Icons.restaurant},
  {'key': 'categories.wellness', 'icon': Icons.spa},
  {'key': 'categories.family', 'icon': Icons.family_restroom},
  {'key': 'categories.sustainable', 'icon': Icons.eco},
  {'key': 'categories.female_solo', 'icon': Icons.person},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _baseCurrency = 'SGD'; // Always SGD
  String _targetCurrency = 'CNY'; // Always CNY
  double? _exchangeRate;
  bool _isFetchingRate = false;
  bool _showBothCurrencies =
      false; // Toggle between showing SGD only or both SGD and CNY

  List<TourModel> _tours = [];
  bool _isLoadingTours = true;
  // Initialize to first category's key
  String? _selectedCategory = categories[0]['key'] as String?;
  String? profileImageUrl;
  bool _isLoadingProfile = true;
  bool _isAuthenticated = false;
  StreamSubscription<AuthUser>? _authSubscription;
  String? searchValue;

  @override
  void initState() {
    super.initState();
    debugPrint('HomeScreen initState called.');
    _checkAuthAndFetchUser();
    _fetchTours();
    _fetchExchangeRate();
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
          setState(() {
            profileImageUrl = userData['profile'] as String?;
            _isAuthenticated = true;
            _isLoadingProfile = false;
          });
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

  Future<void> _fetchExchangeRate() async {
    setState(() {
      _isFetchingRate = true;
    });
    try {
      final url = Uri.parse(
        'https://v6.exchangerate-api.com/v6/9581790b050a4d5e97f5e077/latest/$_baseCurrency',
      );
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(url);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody);

        if (data['result'] == 'success') {
          double rate =
              (data['conversion_rates'][_targetCurrency] ?? 0).toDouble();
          if (mounted) {
            setState(() {
              _exchangeRate = rate;
            });
          }
        } else {
          safePrint('Exchange API error: ${data['error-type']}');
        }
      } else {
        safePrint('Failed to fetch exchange rate: ${response.statusCode}');
      }
    } catch (e) {
      safePrint('Error fetching exchange rate: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingRate = false;
        });
      }
    }
  }

  Future<void> _fetchTours() async {
    final session = await Amplify.Auth.fetchAuthSession();
    final bool isSignedIn = session.isSignedIn;

    debugPrint('Fetching tours...');
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

    try {
      final request = GraphQLRequest<String>(
        document: query,
        authorizationMode: isSignedIn
            ? APIAuthorizationType.userPools
            : APIAuthorizationType.iam,
      );
      final response = await Amplify.API.query(request: request).response;

      debugPrint('Tours GraphQL raw response: ${response.data}');

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
      safePrint('API error fetching tours: ${e.message}');
      setState(() => _isLoadingTours = false);
    } catch (e) {
      safePrint('Unexpected error fetching tours: $e');
      setState(() => _isLoadingTours = false);
    }
  }

  void _navigateToProfileOrAuth() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              _isAuthenticated ? const ProfilePage() : const SignInScreen(),
        ));
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

  List<Widget> _buildTourSections(String? categoryKey, String? searchText) {
    // Map categoryKey to display name for sectionMap
    String? displayCategory;
    switch (categoryKey) {
      case 'categories.date':
        displayCategory = 'Date';
        break;
      case 'categories.nature':
        displayCategory = 'Nature';
        break;
      case 'categories.adventure':
        displayCategory = 'Adventure';
        break;
      case 'categories.culinary':
        displayCategory = 'Culinary';
        break;
      case 'categories.wellness':
        displayCategory = 'Wellness';
        break;
      case 'categories.family':
        displayCategory = 'Family';
        break;
      case 'categories.sustainable':
        displayCategory = 'Sustainable';
        break;
      case 'categories.female_solo':
        displayCategory = 'Female Solo';
        break;
      default:
        displayCategory = null;
    }

    debugPrint(
        'Building tour sections for category: $categoryKey. Total tours loaded: ${_tours.length}');

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
    if (displayCategory == null) {
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

    final sections = sectionMap[displayCategory] ?? [];
    List<Widget> tourSectionsWidgets = [];
    bool haveToursForSelectedCategory = false;

    for (var section in sections) {
      final String sectionTitle = section['title'] ?? 'Untitled Section';
      final String? sectionTag = section['tag'];

      var filteredTours = _tours.where((tour) {
        final bool categoryMatches = tour.category == displayCategory;
        final bool tagsContainSectionTag = tour.tags.contains(sectionTag);

        if (categoryMatches) {
          haveToursForSelectedCategory = true;
        }

        debugPrint(
            '  Tour "${tour.title}" (Category: ${tour.category}, Tags: ${tour.tags}) vs Section "$sectionTitle" (Selected Cat: $displayCategory, Section Tag: $sectionTag): Category Match=$categoryMatches, Tag Match=$tagsContainSectionTag');

        return categoryMatches && tagsContainSectionTag;
      }).toList();
      if (!(searchText == null) && searchText.isNotEmpty == true) {
        debugPrint(
            '------🔥 Filter Filtered Tours: $searchText: ${filteredTours.length}');
        filteredTours = filteredTours
            .where((to) =>
                to.title.toLowerCase().startsWith(searchText.toLowerCase()))
            .toList();
      }

      if (filteredTours.isNotEmpty) {
        debugPrint(
            '  Found ${filteredTours.length} tours for section "$sectionTitle". Adding section.');
        tourSectionsWidgets.add(TourListSection(
          title: sectionTitle,
          tours: filteredTours,
          exchangeRate: _exchangeRate,
          targetCurrency: _targetCurrency,
          showBothCurrencies: _showBothCurrencies,
        ));
      } else {
        debugPrint(
            '  No tours found for section "$sectionTitle". Skipping section.');
      }
    }

    if (tourSectionsWidgets.isEmpty && haveToursForSelectedCategory) {
      final List<TourModel> allToursInSelectedCategory =
          _tours.where((tour) => tour.category == displayCategory).toList();
      if (allToursInSelectedCategory.isNotEmpty) {
        debugPrint(
            'No specific sections matched, but found ${allToursInSelectedCategory.length} tours for category "$displayCategory". Displaying under "All [Category] Tours".');
        tourSectionsWidgets.add(
          TourListSection(
            title: 'All $displayCategory Tours',
            tours: allToursInSelectedCategory,
            exchangeRate: _exchangeRate,
            targetCurrency: _targetCurrency,
            showBothCurrencies: _showBothCurrencies,
          ),
        );
      }
    }

    if (tourSectionsWidgets.isEmpty) {
      debugPrint(
          'No tour sections to display for category: $categoryKey. _tours.isEmpty: ${_tours.isEmpty}, haveToursForSelectedCategory: $haveToursForSelectedCategory');
      return [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No trips found for "${displayCategory ?? 'selected category'}"',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        )
      ];
    }

    return tourSectionsWidgets;
  }

  Widget _buildShimmerAppBarTitle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 120,
        height: 20,
        color: Colors.white,
      ),
    );
  }

  Widget _buildShimmerSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCategoryList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 60,
                    height: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerSectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 160,
          height: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildShimmerTourCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 60,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerSearchBar(),
          _buildShimmerCategoryList(),
          _buildShimmerSectionTitle(),
          // Show 2 shimmer tour cards as example
          _buildShimmerTourCard(),
          _buildShimmerTourCard(),
        ],
      ),
    );
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
        title: _isLoadingTours
            ? _buildShimmerAppBarTitle()
            : Text(
                'appbar_title'.tr(),
                style: const TextStyle(
                  letterSpacing: 1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.currency_exchange,
              color: _showBothCurrencies ? Colors.blue : Colors.grey,
            ),
            tooltip: 'Toggle Currency Display',
            onPressed: () {
              setState(() {
                _showBothCurrencies = !_showBothCurrencies;
                if (_exchangeRate == null && _showBothCurrencies) {
                  _fetchExchangeRate();
                }
              });
            },
          ),
          IconButton(
            icon: _buildProfileAvatar(),
            onPressed: _navigateToProfileOrAuth,
          ),
        ],
      ),
      body: _isLoadingTours
          ? _buildShimmerBody()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterSearchBar(
                    onChangeSearch: (value) {
                      if (mounted) {
                        setState(() {
                          searchValue = value;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final String? categoryKey = cat['key'] as String?;
                        final bool isSelected =
                            _selectedCategory == categoryKey;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedCategory = categoryKey;
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
                                  (cat['key'] as String).tr(),
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
                  ..._buildTourSections(_selectedCategory, searchValue),
                ],
              ),
            ),
    );
  }
}
