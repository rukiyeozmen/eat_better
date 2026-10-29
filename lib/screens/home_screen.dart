
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';
import '../models/user_profile.dart';
import '../services/nutrition_calculator.dart';
import 'meal_analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile profile;

  const HomeScreen({super.key, required this.profile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<Meal> _meals = [];

  bool _isLoadingMeals = true;

  static const String _mealsKey = 'saved_meals';

  int get consumedCalories =>
      _meals.fold(0, (total, meal) => total + meal.calories);

  double get consumedProtein =>
      _meals.fold(0.0, (total, meal) => total + meal.protein);

  double get consumedCarbs =>
      _meals.fold(0.0, (total, meal) => total + meal.carbs);

  double get consumedFat =>
      _meals.fold(0.0, (total, meal) => total + meal.fat);

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMeals = prefs.getString(_mealsKey);

      if (savedMeals != null) {
        final decoded = jsonDecode(savedMeals) as List<dynamic>;
        final loadedMeals = decoded.map((item) {
          return Meal.fromJson(
            Map<String, dynamic>.from(item as Map),
          );
        }).toList();

        if (!mounted) return;

        setState(() {
          _meals
            ..clear()
            ..addAll(loadedMeals);
        });
      }
    } catch (error) {
      debugPrint('Could not load saved meals: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMeals = false;
        });
      }
    }
  }

  Future<void> _saveMeals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedMeals = jsonEncode(
        _meals.map((meal) => meal.toJson()).toList(),
      );

      await prefs.setString(_mealsKey, encodedMeals);
    } catch (error) {
      debugPrint('Could not save meals: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save your meals. Please try again.'),
        ),
      );
    }
  }

  Future<void> _takePhoto() async {
    if (Platform.isMacOS) {
      await _chooseFromGallery();
      return;
    }

    final photo = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (!mounted || photo == null) return;

    await _openMealAnalysis(photo);
  }

  
    Future<void> _chooseFromGallery() async {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
      );

      if (!mounted || result.isEmpty) return;

      final path = result.first.path;
      if (path == null) return;

      await _openMealAnalysis(XFile(path));
    }


  Future<void> _openMealAnalysis(XFile photo) async {
    final meal = await Navigator.push<Meal>(
      context,
      MaterialPageRoute(
        builder: (context) => MealAnalysisScreen(photo: photo),
      ),
    );

    if (!mounted || meal == null) return;

    await _addMeal(meal);
  }

  Future<void> _addMeal(Meal meal) async {
    setState(() {
      _meals.add(meal);
    });

    await _saveMeals();
  }

  @override
  Widget build(BuildContext context) {
    final dailyCalories = NutritionCalculator.calculateCalorieTarget(
      widget.profile,
    );
    final dailyProtein = NutritionCalculator.calculateProtein(
      widget.profile,
    );

    final remainingCalories = dailyCalories - consumedCalories;
    final remainingProtein = dailyProtein - consumedProtein;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eat Better'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoadingMeals
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Your daily nutrition',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Calories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$consumedCalories / '
                            '${dailyCalories.round()} kcal',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: dailyCalories > 0
                                ? (consumedCalories / dailyCalories)
                                    .clamp(0.0, 1.0)
                                : 0.0,
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${remainingCalories.round()} kcal remaining',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Protein',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${consumedProtein.round()} / '
                            '${dailyProtein.round()} g',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: dailyProtein > 0
                                ? (consumedProtein / dailyProtein)
                                    .clamp(0.0, 1.0)
                                : 0.0,
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${remainingProtein.round()} g protein remaining',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Other nutrients',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('Carbohydrates: ${consumedCarbs.round()} g'),
                          const SizedBox(height: 8),
                          Text('Fat: ${consumedFat.round()} g'),
                        ],
                      ),
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
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take a photo'),
                    ),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _chooseFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose from gallery'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Today's meals",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_meals.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No meals added yet. Take a photo or choose '
                          'a picture from your gallery to get started.',
                        ),
                      ),
                    )
                  else
                    ..._meals.map(
                      (meal) => Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.restaurant),
                          ),
                          title: Text(meal.name),
                          subtitle: Text(
                            '${meal.calories} kcal'
                            ' • Protein ${meal.protein.round()} g'
                            ' • Carbs ${meal.carbs.round()} g'
                            ' • Fat ${meal.fat.round()} g',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
