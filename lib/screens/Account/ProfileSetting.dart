import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import '../Bottom_Nav_Bar.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  bool _isUploading = false;
  late AnimationController _animationController;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nicknameController;
  late TextEditingController _profileController;

  File? _selectedImageFile;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nicknameController = TextEditingController();
    _profileController = TextEditingController();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nicknameController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      final userId = authUser.userId;

      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      String? cognitoEmail;
      String? cognitoName;
      String? cognitoPhone;
      String? cognitoNickname;
      String? profile;

      for (var attribute in userAttributes) {
        if (attribute.userAttributeKey == AuthUserAttributeKey.email) {
          cognitoEmail = attribute.value;
        } else if (attribute.userAttributeKey == AuthUserAttributeKey.name) {
          cognitoName = attribute.value;
        } else if (attribute.userAttributeKey ==
            AuthUserAttributeKey.phoneNumber) {
          cognitoPhone = attribute.value;
        } else if (attribute.userAttributeKey ==
            AuthUserAttributeKey.nickname) {
          cognitoNickname = attribute.value;
        } else if (attribute.userAttributeKey == AuthUserAttributeKey.profile) {
          profile = attribute.value;
        }
      }

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
            }
          }
        ''',
        variables: {'id': userId},
      );

      final response = await Amplify.API.query(request: request).response;
      final rawData = response.data;

      if (rawData == null || jsonDecode(rawData)['getUser'] == null) {
        await _createUserProfileIfNeeded(
          userId,
          cognitoEmail: cognitoEmail,
          cognitoName: cognitoName,
          cognitoPhone: cognitoPhone,
          cognitoNickname: cognitoNickname,
        );
        return _fetchUserProfile();
      }

      final userData = jsonDecode(rawData)['getUser'];

      setState(() {
        _userProfile = userData;
        _nameController.text = userData['name'] ?? cognitoName ?? '';
        _emailController.text = userData['email'] ?? cognitoEmail ?? '';
        _phoneController.text = userData['phone'] ?? cognitoPhone ?? '';
        _nicknameController.text =
            userData['nickname'] ?? cognitoNickname ?? '';
        _profileController.text = userData['profile'] ?? '';
        _isLoading = false;
        _animationController.forward();
      });
    } catch (e) {
      safePrint('Error fetching profile: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createUserProfileIfNeeded(
    String userId, {
    String? cognitoEmail,
    String? cognitoName,
    String? cognitoPhone,
    String? cognitoNickname,
  }) async {
    try {
      final mutation = '''
        mutation CreateUser(\$input: CreateUserInput!) {
          createUser(input: \$input) {
            id
            name
            email
            phone
            nickname
            profile
          }
        }
      ''';

      final variables = {
        'input': {
          'id': userId,
          'name': cognitoName ?? '',
          'email': cognitoEmail ?? '',
          'phone': cognitoPhone ?? '',
          'nickname': cognitoNickname ?? '',
          'profile': '',
        }
      };

      await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: mutation,
              variables: variables,
            ),
          )
          .response;
    } catch (e) {
      safePrint('Error creating user profile in DynamoDB: $e');
    }
  }

  Future<void> _updateUserProfile() async {
    if (_userProfile == null) return;

    setState(() => _isLoading = true);

    try {
      String? updatedProfileUrl = _userProfile!['profile'];

      if (_selectedImageFile != null) {
        setState(() => _isUploading = true);
        updatedProfileUrl = await _uploadProfileImage(_selectedImageFile!);
        setState(() => _isUploading = false);
      }

      final mutation = '''
        mutation UpdateUser(\$input: UpdateUserInput!) {
          updateUser(input: \$input) {
            id
            name
            email
            phone
            nickname
            profile
          }
        }
      ''';

      final variables = {
        'input': {
          'id': _userProfile!['id'],
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'nickname': _nicknameController.text.trim(),
          'profile': updatedProfileUrl ?? _profileController.text.trim(),
        }
      };

      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: mutation,
              variables: variables,
            ),
          )
          .response;

      final updatedData = jsonDecode(response.data!)['updateUser'];

      setState(() {
        _userProfile = updatedData;
        _isLoading = false;
        _selectedImageFile = null;
        _profileController.text = updatedData['profile'] ?? '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      safePrint('Error updating profile: $e');
      setState(() {
        _isLoading = false;
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile update failed: $e')),
      );
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      final email = _emailController.text.trim();
      final key =
          'public/profile_images/$email-${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = StoragePath.fromString(key);

      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(imageFile.path),
        path: path,
      ).result;

      final urlResult = await Amplify.Storage.getUrl(path: path).result;
      return urlResult.url.toString();
    } catch (e) {
      safePrint('❌ Image upload failed: $e');
      return null;
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
          _userProfile = {
            ...?_userProfile,
            'profile': _selectedImageFile!.path,
          };
        });
      }
    } catch (e) {
      safePrint('Error picking image: $e');
    }
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: readOnly,
          fillColor: readOnly ? Colors.grey[100] : null,
          suffixIcon:
              readOnly ? const Icon(Icons.lock_outline, size: 18) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImageUrl =
        _selectedImageFile != null ? null : (_userProfile?['profile'] ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await Amplify.Auth.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigation()),
                    (Route<dynamic> route) => false,
                  );
                }
              } catch (e) {
                safePrint('Error signing out: $e');
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : _userProfile == null
              ? const Center(child: Text('User profile not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade300,
                                child: _isUploading
                                    ? const CupertinoActivityIndicator(
                                        radius: 20)
                                    : (_selectedImageFile != null
                                        ? ClipOval(
                                            child: Image.file(
                                                _selectedImageFile!,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover))
                                        : (profileImageUrl != null &&
                                                profileImageUrl.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: profileImageUrl,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CupertinoActivityIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.person,
                                                            size: 50,
                                                            color: Colors.grey),
                                              )
                                            : const Icon(Icons.person,
                                                size: 50, color: Colors.grey))),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.blue,
                                    child: Icon(Icons.edit,
                                        size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    _nameController.text.isNotEmpty
                                        ? _nameController.text
                                        : 'No Name Set',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(_emailController.text,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(
                                    _phoneController.text.isNotEmpty
                                        ? _phoneController.text
                                        : 'No Phone Set',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildEditableField('Name', _nameController),
                      _buildEditableField('Email', _emailController,
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress),
                      _buildEditableField('Phone', _phoneController,
                          keyboardType: TextInputType.phone),
                      _buildEditableField('Bio', _nicknameController,
                          maxLines: 3),
                      _buildEditableField('Profile URL', _profileController),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading || _isUploading
                              ? null
                              : _updateUserProfile,
                          child: _isLoading || _isUploading
                              ? const CupertinoActivityIndicator(
                                  color: Colors.white)
                              : const Text('Update Profile',
                                  style: TextStyle(fontSize: 18)),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
