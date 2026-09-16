import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/nutrition_calculator.dart';
import '../nutrition_results_screen.dart';

class GoalScreen extends StatefulWidget {
  final UserProfile profile;

  const GoalScreen({
    super.key,
    required this.profile,
  });

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String? selectedGoal;

  final List<Map<String, String>> goals = [
    {
      'value': 'lose',
      'title': 'Lose weight',
      'description': 'Reduce body weight gradually',
    },
    {
      'value': 'maintain',
      'title': 'Maintain weight',
      'description': 'Keep your current weight',
    },
    {
      'value': 'gain',
      'title': 'Gain weight',
      'description': 'Increase body weight gradually',
    },
    {
      'value': 'muscle',
      'title': 'Build muscle',
      'description': 'Support muscle growth and strength',
    },
    {
      'value': 'health',
      'title': 'Improve overall health',
      'description': 'Focus on balanced nutrition and wellbeing',
    },
  ];

  void _continue() {
    if (selectedGoal == null) {
      return;
    }

    widget.profile.goal = selectedGoal;

    final bmi = NutritionCalculator.calculateBmi(widget.profile);
    final bmr = NutritionCalculator.calculateBmr(widget.profile);
    final tdee = NutritionCalculator.calculateTdee(widget.profile);
    final calories =
        NutritionCalculator.calculateCalorieTarget(widget.profile);
    final protein = NutritionCalculator.calculateProtein(widget.profile);
    final fat = NutritionCalculator.calculateFat(widget.profile);
    final carbs =
        NutritionCalculator.calculateCarbohydrates(widget.profile);

    print('--- Eat Better Nutrition Results ---');
    print('BMI: ${bmi.toStringAsFixed(1)}');
    print('BMR: ${bmr.round()} kcal');
    print('TDEE: ${tdee.round()} kcal');
    print('Daily calories: ${calories.round()} kcal');
    print('Protein: ${protein.round()} g');
    print('Fat: ${fat.round()} g');
    print('Carbs: ${carbs.round()} g');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutritionResultsScreen(
          profile: widget.profile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What is your goal?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Choose the goal that best describes what you want to achieve.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: goals.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final value = goal['value']!;
                    final title = goal['title']!;
                    final description = goal['description']!;

                    final selected = selectedGoal == value;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedGoal = value;
                        });
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                            width: selected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selected)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: selectedGoal == null ? null : _continue,
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