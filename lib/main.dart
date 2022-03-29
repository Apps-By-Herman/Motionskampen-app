import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/misc/utilities.dart';
import 'package:moveness/providers/activity.dart';
import 'package:moveness/providers/challenge.dart';
import 'package:moveness/providers/me.dart';
import 'package:moveness/providers/search.dart';
import 'package:moveness/providers/team.dart';
import 'package:moveness/services/auth.dart';
import 'package:moveness/services/storage.dart';
import 'package:moveness/views/boarding.dart';
import 'package:moveness/views/login.dart';
import 'package:moveness/views/main.dart';
import 'package:provider/provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFlutterFire();
  setupLocator();
  final storage = locator<StorageService>();
  final firstTime = storage.readFirstTime();
  await locator.allReady();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ChallengeProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => MeProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => TeamProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => SearchProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ActivityProvider(),
    ),
  ], child: MyApp(await firstTime)));
}

// Define an async function to initialize FlutterFire
Future initializeFlutterFire() async {
  await Firebase.initializeApp();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}

class MyApp extends StatefulWidget {
  const MyApp(this.firstTime, {Key? key}) : super(key: key);

  final bool firstTime;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    final _auth = locator<AuthService>();

    _auth.onLogout(() {
      final meProvider = Provider.of<MeProvider>(context, listen: false);
      meProvider.clear();

      final activityProvider =
          Provider.of<ActivityProvider>(context, listen: false);
      activityProvider.clear();

      final challengeProvider =
          Provider.of<ChallengeProvider>(context, listen: false);
      challengeProvider.clear();

      final searchProvider =
          Provider.of<SearchProvider>(context, listen: false);
      searchProvider.clear();

      final teamProvider = Provider.of<TeamProvider>(context, listen: false);
      teamProvider.clear();
    });

    _auth.onLogin(() {
      Utilities.updateDeviceToken();
      final String defaultLocale = Platform.localeName; // Returns locale string in the form 'en_US'
      Utilities.updatePreferredLanguage(defaultLocale.substring(0, 2));
    });

    // Show error message if initialization failed
    if (_error) {
      return Scaffold(
        body: Text('Something went wrong with the FlutterFire init'),
      );
    }

    return MaterialApp(
      title: 'Motionskampen',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(),
      home: widget.firstTime
          ? BoardingView()
          : _auth.hasAccessToken()
              ? MainView()
              : LoginView(),
    );
  }
}
