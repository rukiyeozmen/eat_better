import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MealAnalysisScreen extends StatelessWidget {
final XFile photo;

const MealAnalysisScreen({
super.key,
required this.photo,
});

void _showAnalysisResult(BuildContext context) {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => MealResultScreen(
photo: photo,
),
),
);
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

class MealResultScreen extends StatelessWidget {
final XFile photo;

const MealResultScreen({
super.key,
required this.photo,
});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Meal Result'),
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


          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.file(
              File(photo.path),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chicken, rice & vegetables',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NutritionItem(
                      value: '620',
                      label: 'Calories',
                    ),
                    _NutritionItem(
                      value: '42 g',
                      label: 'Protein',
                    ),
                    _NutritionItem(
                      value: '58 g',
                      label: 'Carbs',
                    ),
                    _NutritionItem(
                      value: '20 g',
                      label: 'Fat',
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
                    'This is a temporary estimate. The real AI analysis will identify the food and calculate nutrition from the photo.',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Meal added to your diary.',
                    ),
                  ),
                );
              },
              child: const Text(
                'Add to My Meals',
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
