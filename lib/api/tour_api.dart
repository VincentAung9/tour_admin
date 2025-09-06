// File: tour_api.dart

import 'package:amplify_flutter/amplify_flutter.dart';

Future<void> createTour(Map<String, dynamic> tourData) async {
  try {
    final request = GraphQLRequest(
      document: '''
        mutation CreateTour(\$input: CreateTourInput!) {
          createTour(input: \$input) {
            id
            title
          }
        }
      '''
      ,
      variables: {
        'input': {
          'title': tourData['title'],
          'location': tourData['location'],
          'description': tourData['description'],
          'imageUrl': tourData['imageUrl'],
          'passengers': tourData['passengers'],
          'season': tourData['season'],
          'rating': tourData['rating'] ?? 0.0,
          'category': tourData['category'],
          'tags': tourData['tags'],
          'plans': tourData['plans'],
          'days': tourData['days'],
          'additionalInfo': tourData['additionalInfo'],
          'createdBy': tourData['createdBy'],
          'createdAt': tourData['createdAt'],
        }
      },
    );

    final response = await Amplify.API.mutate(request: request).response;

    if (response.errors.isNotEmpty) {
      throw Exception(response.errors.first.message);
    }

    safePrint('Tour created: \${response.data}');
  } catch (e) {
    safePrint('Create Tour Error: \$e');
    rethrow;
  }
}
