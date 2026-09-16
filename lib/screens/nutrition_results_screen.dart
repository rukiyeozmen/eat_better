import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/nutrition_calculator.dart';
import 'home_screen.dart';

class NutritionResultsScreen extends StatelessWidget {
  final UserProfile profile;

  const NutritionResultsScreen({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final bmi = NutritionCalculator.calculateBmi(profile);
    final bmr = NutritionCalculator.calculateBmr(profile);
    final tdee = NutritionCalculator.calculateTdee(profile);
    final calories =
        NutritionCalculator.calculateCalorieTarget(profile);
    final protein = NutritionCalculator.calculateProtein(profile);
    final fat = NutritionCalculator.calculateFat(profile);
    final carbs =
        NutritionCalculator.calculateCarbohydrates(profile);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your nutrition plan',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Here are your personalized daily targets.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              // Daily calories
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Daily calorie target',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${calories.round()} kcal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Macronutrients
              Row(
                children: [
                  Expanded(
                    child: _NutritionCard(
                      title: 'Protein',
                      value: '${protein.round()} g',
                      icon: Icons.fitness_center,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: _NutritionCard(
                      title: 'Fat',
                      value: '${fat.round()} g',
                      icon: Icons.water_drop_outlined,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: _NutritionCard(
                      title: 'Carbs',
                      value: '${carbs.round()} g',
                      icon: Icons.grain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Your numbers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'BMI',
                      value: bmi.toStringAsFixed(1),
                    ),

                    const Divider(height: 24),

                    _InfoRow(
                      label: 'BMR',
                      value: '${bmr.round()} kcal',
                    ),

                    const Divider(height: 24),

                    _InfoRow(
                      label: 'Daily energy needs',
                      value: '${tdee.round()} kcal',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          profile: profile,
                        ),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _NutritionCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 4),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}