import '../models/user_profile.dart';

class NutritionCalculator {
  static double calculateBmi(UserProfile profile) {
    final heightMeters = profile.heightCm! / 100;
    return profile.weightKg! / (heightMeters * heightMeters);
  }

  static double calculateBmr(UserProfile profile) {
    if (profile.sex == 'female') {
      return (10 * profile.weightKg!) +
          (6.25 * profile.heightCm!) -
          (5 * profile.age!) -
          161;
    }

    return (10 * profile.weightKg!) +
        (6.25 * profile.heightCm!) -
        (5 * profile.age!) +
        5;
  }

  static double calculateTdee(UserProfile profile) {
    final bmr = calculateBmr(profile);

    double activityMultiplier;

    switch (profile.activity) {
      case 'light':
        activityMultiplier = 1.375;
        break;
      case 'moderate':
        activityMultiplier = 1.55;
        break;
      case 'very':
        activityMultiplier = 1.725;
        break;
      case 'extreme':
        activityMultiplier = 1.9;
        break;
      case 'sedentary':
      default:
        activityMultiplier = 1.2;
    }

    return bmr * activityMultiplier;
  }

  static double calculateCalorieTarget(UserProfile profile) {
    final tdee = calculateTdee(profile);

    switch (profile.goal) {
      case 'lose':
        return tdee - 500;
      case 'gain':
        return tdee + 300;
      case 'muscle':
        return tdee + 200;
      case 'maintain':
      case 'health':
      default:
        return tdee;
    }
  }

  static double calculateProtein(UserProfile profile) {
    final calories = calculateCalorieTarget(profile);

    // 25% of daily calories from protein.
    return (calories * 0.25) / 4;
  }

  static double calculateFat(UserProfile profile) {
    final calories = calculateCalorieTarget(profile);

    // 30% of daily calories from fat.
    return (calories * 0.30) / 9;
  }

  static double calculateCarbohydrates(UserProfile profile) {
    final calories = calculateCalorieTarget(profile);

    final proteinCalories = calculateProtein(profile) * 4;
    final fatCalories = calculateFat(profile) * 9;

    final carbohydrateCalories =
        calories - proteinCalories - fatCalories;

    return carbohydrateCalories / 4;
  }
}