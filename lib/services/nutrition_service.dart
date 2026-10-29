
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/meal.dart';

class NutritionService {
  static const String _functionUrl =
      'http://127.0.0.1:5001/eat-better-2cb51/us-central1/testOpenAISetup';

  Future<Meal> analyzeMeal(File photo) async {
    final imageBytes = await photo.readAsBytes();

    final response = await http.post(
      Uri.parse(_functionUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'imageBase64': base64Encode(imageBytes),
        'mimeType': _getMimeType(photo.path),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Meal analysis failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final mealData = data['meal'] as Map<String, dynamic>;

    return Meal(
      name: mealData['name'] as String,
      calories: (mealData['calories'] as num).toInt(),
      protein: (mealData['protein'] as num).toDouble(),
      carbs: (mealData['carbs'] as num).toDouble(),
      fat: (mealData['fat'] as num).toDouble(),
      date: DateTime.now(),
    );
  }

  String _getMimeType(String path) {
    final extension = path.toLowerCase().split('.').last;

    switch (extension) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
