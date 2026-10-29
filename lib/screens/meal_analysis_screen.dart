import '../services/nutrition_service.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/meal.dart';

class MealAnalysisScreen extends StatelessWidget {
  final XFile photo;

  const MealAnalysisScreen({
    super.key,
    required this.photo,
  });

  Future<void> _showAnalysisResult(BuildContext context) async {
    final meal = await Navigator.push<Meal>(
      context,
      MaterialPageRoute(
        builder: (context) => MealResultScreen(
          photo: photo,
        ),
      ),
    );

    if (!context.mounted || meal == null) {
      return;
    }

    Navigator.pop(context, meal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Meal'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your meal',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We’ll analyze this photo and estimate the nutrition.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(
                  File(photo.path),
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    _showAnalysisResult(context);
                  },
                  child: const Text(
                    'Analyze Meal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Choose Another Photo',
                    style: TextStyle(
                      fontSize: 17,
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


class MealResultScreen extends StatefulWidget {
  final XFile photo;

  const MealResultScreen({
    super.key,
    required this.photo,
  });

  @override
  State<MealResultScreen> createState() => _MealResultScreenState();
}

class _MealResultScreenState extends State<MealResultScreen> {
  late Future<Meal> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = NutritionService().analyzeMeal(File(widget.photo.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Result'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<Meal>(
          future: _mealFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'We couldn’t analyze your meal right now. '
                        'Please check that the Firebase emulator is running '
                        'and try again.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            _mealFuture =
                                NutritionService().analyzeMeal(File(widget.photo.path));
                          });
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final meal = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Your meal',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      File(widget.photo.path),
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Estimated meal',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text('TOTAL CALORIES'),
                            const SizedBox(height: 8),
                            Text(
                              '${meal.calories}',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('kcal'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _NutritionItem(
                              value: '${meal.protein} g',
                              label: 'Protein',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _NutritionItem(
                              value: '${meal.carbs} g',
                              label: 'Carbs',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _NutritionItem(
                              value: '${meal.fat} g',
                              label: 'Fat',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'These are sample nutrition values, '
                            'not an analysis of your photo.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context, meal);
                      },
                      child: const Text(
                        'Add to My Meals',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


class _NutritionItem extends StatelessWidget {
  final String value;
  final String label;

  const _NutritionItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

