class UserProfile {
  int? age;
  String? sex;
  double? heightCm;
  double? weightKg;
  String? activity;
  String? goal;

  UserProfile({
    this.age,
    this.sex,
    this.heightCm,
    this.weightKg,
    this.activity,
    this.goal,
  });

  // Convert the profile into data that can be saved.
  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'sex': sex,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'activity': activity,
      'goal': goal,
    };
  }

  // Rebuild a profile from saved data.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      age: (json['age'] as num?)?.toInt(),
      sex: json['sex'] as String?,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      activity: json['activity'] as String?,
      goal: json['goal'] as String?,
    );
  }
}
