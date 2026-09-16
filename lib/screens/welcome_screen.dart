import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'onboarding/age_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),

              const Text(
                'Eat Better',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your personal nutrition mentor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 45),

              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Center(
                  child: Text(
                    '🥗',
                    style: TextStyle(fontSize: 90),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'Take a photo of your meal and let us '
                'help you understand what you are eating.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgeScreen(
                          profile: UserProfile(),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {},
                child: const Text('Choose from Gallery'),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}