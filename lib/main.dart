import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:tour_agent_aws/models/ModelProvider.dart';
import 'package:tour_agent_aws/screens/Bottom_Nav_Bar.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final api = AmplifyAPI(
          options: APIPluginOptions(modelProvider: ModelProvider.instance));
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();

      await Amplify.addPlugins([api, auth, storage]);
      await Amplify.configure(amplifyconfig);

      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      safePrint('Amplify configuration error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour App with Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'Arial', // Apply Arial font as the default
      ),
      home: _amplifyConfigured
          ? const MainNavigation()
          : const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite, // Test icon
                      size: 50,
                      color: Colors.red,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Let's Travel...",
                      style: TextStyle(fontSize: 20),
                    ),
                    CupertinoActivityIndicator(
                      radius: 20.0,
                      color: CupertinoColors.activeBlue,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
