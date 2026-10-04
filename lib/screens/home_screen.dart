import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/meal.dart';
import '../models/user_profile.dart';
import '../services/nutrition_calculator.dart';
import 'meal_analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile profile;

  const HomeScreen({
    super.key,
    required this.profile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<Meal> _meals = [];

  int calculateTotalCalories(List<Meal> meals) {
    int total = 0;

    for (final meal in meals) {
      total += meal.calories;
    }

    return total;
  }

  void _addMeal(Meal meal) {
    setState(() {
      _meals.add(meal);
    });
  }

  Future<void> _takePhoto() async {
    debugPrint('Camera button pressed');

    final photo = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (photo == null || !mounted) {
      return;
    }

    final meal = await Navigator.push<Meal>(
      context,
      MaterialPageRoute(
        builder: (context) => MealAnalysisScreen(
          photo: photo,
        ),
      ),
    );

    if (meal != null) {
      _addMeal(meal);
    }
  }

  Future<void> _chooseFromGallery() async {
    debugPrint('Gallery button pressed');

    final result = await FilePicker.pickFiles(
      type: FileType.image,
    );

    debugPrint('File picker finished');

    if (result.isEmpty || result.first.path == null || !mounted) {
      return;
    }

    final photo = XFile(result.first.path!);

    debugPrint('Selected file: ${photo.path}');

    final meal = await Navigator.push<Meal>(
      context,
      MaterialPageRoute(
        builder: (context) => MealAnalysisScreen(
          photo: photo,
        ),
      ),
    );

    if (meal != null) {
      _addMeal(meal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final calories =
        NutritionCalculator.calculateCalorieTarget(widget.profile);

    final consumedCalories = calculateTotalCalories(_meals);
    final remainingCalories = calories - consumedCalories;

    final protein =
        NutritionCalculator.calculateProtein(widget.profile);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eat Better'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Good to see you!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Let’s keep track of what you eat today.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today’s nutrition target',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                      Text(
                        '${calories.round()} kcal',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${consumedCalories.round()} kcal consumed',
                      ),

                      Text(
                        '${remainingCalories.round()} kcal remaining',
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '${protein.round()} g protein',
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Add a meal',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _chooseFromGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Today’s meals',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (_meals.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'No meals logged yet.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              else
                ..._meals.map(
                  (meal) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            meal.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                       SizedBox(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '${meal.calories} kcal',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '${meal.protein.round()} g protein',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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