
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'models/user_profile.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final savedProfile = prefs.getString('user_profile');

  UserProfile? initialProfile;

  if (savedProfile != null) {
    try {
      final profileData =
          jsonDecode(savedProfile) as Map<String, dynamic>;

      initialProfile = UserProfile.fromJson(profileData);
    } catch (_) {
      initialProfile = null;
    }
  }

  runApp(EatBetterApp(initialProfile: initialProfile));
}

class EatBetterApp extends StatelessWidget {
  final UserProfile? initialProfile;

  const EatBetterApp({
    super.key,
    required this.initialProfile,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eat Better',
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
      ],
      home: initialProfile != null
          ? HomeScreen(profile: initialProfile!)
          : const WelcomeScreen(),
    );
  }
}
