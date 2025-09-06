import 'dart:io';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:tour_agent_aws/models/UserRole.dart';
import 'dart:developer' as dev;
import '../../models/User.dart';

class AuthManager {
  String message = '';

  Future<String?> uploadProfileImage(File imageFile, String email) async {
    try {
      final fileName = '$email-${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = StoragePath.fromString('public/profile_images/$fileName');

      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(imageFile.path),
        path: path,
        onProgress: (progress) {
          final percent =
              (progress.transferredBytes / progress.totalBytes * 100)
                  .toStringAsFixed(1);
          safePrint('Uploading: $percent%');
        },
      ).result;

      const bucket = 'tourtestimagevideo0199c87-dev'; // your S3 bucket
      const region = 'us-east-1'; // your AWS region
      final url =
          'https://$bucket.s3.$region.amazonaws.com/public/profile_images/$fileName';

      dev.log("🔥 Manual URL: $url");
      dev.log("🔥 Return URL: ${result.uploadedItem.path}");
      return url;
    } catch (e) {
      safePrint('❌ Upload failed: $e');
      return null;
    }
  }

  Future<String?> createNewUser({
    required String name,
    required String phone,
    required String bio,
    required String email,
    required String password,
    required File imageFile,
  }) async {
    try {
      final imageUrl = await uploadProfileImage(imageFile, email);
      if (imageUrl == null) return null;

      final attributes = {
        AuthUserAttributeKey.email: email,
        AuthUserAttributeKey.phoneNumber: phone,
        AuthUserAttributeKey.name: name,
        AuthUserAttributeKey.nickname: bio,
        AuthUserAttributeKey.profile: imageUrl,
      };

      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: attributes),
      );

      if (result.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
        return imageUrl;
      }

      message = "Please confirm your account before using the app.";
      return null;
    } on AuthException catch (e) {
      message = e.message;
      return null;
    }
  }

  Future<bool> completeUserProfile({
    required String name,
    required String phone,
    required String bio,
    required String imageUrl,
  }) async {
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      final userId = currentUser.userId;

      final attributes = await Amplify.Auth.fetchUserAttributes();
      final email = attributes
          .firstWhere((a) => a.userAttributeKey == AuthUserAttributeKey.email)
          .value;

      /* final input = {
        'id': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'nickname': bio,
        'profile': imageUrl,
        'role': 'USER',
      };

      safePrint('📤 Sending to createUser: $input');

      final request = GraphQLRequest<String>(
        document: '''
    mutation CreateUser(\$input: CreateUserInput!) {
      createUser(input: \$input) {
        id
        name
        email
      }
    }
  ''',
        variables: {'input': input},
      );
 */
      final request = ModelMutations.create(User(
          name: name,
          email: email,
          phone: phone,
          nickname: bio,
          profile: imageUrl,
          role: UserRole.USER));

      final response = await Amplify.API.mutate(request: request).response;

      safePrint('📥 GraphQL response: ${response.data}');
      if (response.errors.isNotEmpty) {
        safePrint('❌ GraphQL errors: ${response.errors}');
        return false;
      }
      if (!(response.data == null)) {
        dev.log("🔥CreatedUser: ${response.data}");
        return true;
      }

      safePrint('✅ User saved to DynamoDB');
      return false;
    } catch (e) {
      safePrint('❌ Error creating user in DynamoDB: $e');
      return false;
    }
  }
}
