import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:tour_agent_aws/screens/Bottom_Nav_Bar.dart';
import 'amplifyconfiguration.dart';
import 'package:easy_localization/easy_localization.dart';

import 'models/ModelProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('zh')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
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
        options: APIPluginOptions(modelProvider: ModelProvider.instance),
      );
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();

      await Amplify.addPlugins([api, auth, storage]);
      await Amplify.configure(amplifyconfig);

      if (mounted) {
        setState(() {
          _amplifyConfigured = true;
        });
      }
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
        fontFamily: 'Arial',
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: _amplifyConfigured
          ? const MainNavigation()
          : const LoadingScreen(),
    );
  }
}


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, size: 50, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              'welcome'.tr(),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            const CupertinoActivityIndicator(radius: 20.0, color: CupertinoColors.activeBlue),
          ],
        ),
      ),
    );
  }
}
