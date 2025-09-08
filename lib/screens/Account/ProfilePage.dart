import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

import '../My_Booking.dart';
import 'ProfileSetting.dart';
import 'Signin.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  File? _selectedImageFile;
  String _memberSince = 'N/A';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<String?> _getSignedProfileImageUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(key),
      ).result;
      return result.url.toString();
    } catch (e) {
      safePrint('Error getting signed profile URL: $e');
      return null;
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      final userId = authUser.userId;

      final request = GraphQLRequest<String>(
        document: '''
        query GetUser(\$id: ID!) {
          getUser(id: \$id) {
            id
            name
            email
            phone
            nickname
            profile
            createdAt
          }
        }
      ''',
        variables: {'id': userId},
      );

      final response = await Amplify.API.query(request: request).response;
      final rawData = response.data;

      if (rawData == null || jsonDecode(rawData)['getUser'] == null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignInScreen()),
          );
        }
        return;
      }

      final user = jsonDecode(rawData)['getUser'];
      String? profileKey = user['profile'];
      String? createdAtString = user['createdAt'];

      if (profileKey != null &&
          profileKey.isNotEmpty &&
          !profileKey.startsWith('http')) {
        final signedUrl = await _getSignedProfileImageUrl(profileKey);
        user['profile'] = signedUrl;
      }

      String formattedDate = 'N/A';
      if (createdAtString != null && createdAtString.isNotEmpty) {
        try {
          final dateTime = DateTime.parse(createdAtString);
          formattedDate = DateFormat('MMMM yyyy').format(dateTime);
        } catch (e) {
          safePrint('Error parsing createdAt date: $e');
        }
      }

      if (mounted) {
        setState(() {
          _userProfile = user;
          _memberSince = formattedDate;
          _isLoading = false;
        });
      }
    } on SignedOutException {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      }
    } catch (e) {
      safePrint('Error fetching profile: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (picked != null) {
        setState(() {
          _selectedImageFile = File(picked.path);
        });
      }
    } catch (e) {
      safePrint('Error picking image: $e');
    }
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade400, size: 20),
        const SizedBox(width: 12),
        Text(
          "$label:",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 8,
        shadowColor: Colors.blue.shade200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImageUrl = _selectedImageFile != null
        ? null
        : (_userProfile?['profile'] ?? '');

    return Scaffold(
      body: _isLoading
          ? Center(
        child: Image.asset(
          'assets/loading.gif',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        )
      )
          : _userProfile == null
          ? const Center(child: Text('User profile not found'))
          : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade50, Colors.purple.shade50],
            ),
          ),
          child: Center(
            child: Card(
              elevation: 16.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.blue.shade400,
                          child: _selectedImageFile != null
                              ? ClipOval(
                            child: Image.file(
                              _selectedImageFile!,
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                          )
                              : (profileImageUrl.isNotEmpty
                              ? CachedNetworkImage(
                            imageUrl: profileImageUrl,
                            imageBuilder:
                                (context, imageProvider) =>
                                Container(
                                  width: 128,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            placeholder: (context, url) =>
                                Image.asset(
                                  'assets/loading.gif', // Path to your GIF
                                  width: 100,          // Keep the same size as before
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              errorWidget:
                                (context, url, error) =>
                                Text(
                                  _userProfile?['name']?[0] ??
                                      'U',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                  ),
                                ),
                          )
                              : Text(
                            _userProfile?['name']?[0] ??
                                'U',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _userProfile?['name'] ?? 'No Name Set',
                      style: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userProfile?['nickname'] ?? 'Traveler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn("Trips Booked", "50"),
                        _buildStatColumn("Reviews Given", "30"),
                        _buildStatColumn("Avg. Rating", "4.5"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.calendar_today,
                      "Member Since",
                      _memberSince,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.email,
                      "Email",
                      _userProfile?['email'] ?? 'No Email Set',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.phone,
                      "Phone",
                      _userProfile?['phone'] ?? 'No Phone Set',
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildSocialButton(
                          Icons.book_online,
                          "All Bookings",
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const UserBookingScreen(),
                            ),
                          ),
                        ),
                        _buildSocialButton(
                          Icons.favorite_border,
                          "Saved Trips",
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const UserBookingScreen(),
                            ),
                          ),
                        ),
                        _buildSocialButton(
                          Icons.support_agent,
                          "Customer Support",
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const UserBookingScreen(),
                            ),
                          ),
                        ),
                        _buildSocialButton(
                          Icons.currency_exchange,
                          "Currency",
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const UserBookingScreen(),
                            ),
                          ),
                        ),
                        _buildSocialButton(
                          Icons.language,
                          "Language",
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const UserBookingScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileSetting()),
              );
            },
          ),
        ],
      ),
    );
  }
}