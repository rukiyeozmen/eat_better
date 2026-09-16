import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  XFile? _mealPhoto;

  Future<void> _takePhoto() async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) {
        return;
      }

      setState(() {
        _mealPhoto = photo;
      });

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealAnalysisScreen(
            photo: photo,
          ),
        ),
      );
    } catch (e) {
      print('Camera error: $e');
    }
  }

  Future<void> _chooseFromGallery() async {
    print('Gallery button pressed');

    try {
      final files = await FilePicker.pickFiles(
        type: FileType.image,
      );

      print('File picker finished');

      if (files.isEmpty) {
        print('No file selected');
        return;
      }

      final file = files.first;

      print('Selected file: ${file.path}');

      if (file.path == null) {
        print('File path is null');
        return;
      }

      final photo = XFile(file.path!);

      setState(() {
        _mealPhoto = photo;
      });

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealAnalysisScreen(
            photo: photo,
          ),
        ),
      );
    } catch (e) {
      print('Gallery error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final calories =
        NutritionCalculator.calculateCalorieTarget(widget.profile);

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                'Let’s make better food choices today.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

                    const SizedBox(height: 6),

                    Text(
                      '${protein.round()} g protein',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Add a meal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
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
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _chooseFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Today’s meals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                child: const Text(
                  'No meals logged yet.',
                  style: TextStyle(
                    fontSize: 16,
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