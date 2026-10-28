import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class NutritionService {
  static const String _functionUrl =
      'http://127.0.0.1:5001/eat-better-2cb51/us-central1/testOpenAISetup';

  Future<Meal> analyzeMeal() async {
    final response = await http.get(Uri.parse(_functionUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load nutrition data.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final mealData = data['meal'] as Map<String, dynamic>;

    return Meal(
      name: mealData['name'] as String,
      calories: (mealData['calories'] as num).toInt(),
      protein: (mealData['protein'] as num).toDouble(),
      carbs: (mealData['carbs'] as num).toDouble(),
      fat: (mealData['fat'] as num).toDouble(),
    );
  }
}
