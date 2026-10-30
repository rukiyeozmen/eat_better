
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  String? _sex;
  String? _activity;
  String? _goal;

  @override
  void initState() {
    super.initState();

    _ageController = TextEditingController(
      text: widget.profile.age?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: widget.profile.heightCm?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.profile.weightKg?.toString() ?? '',
    );

    _sex = widget.profile.sex;
    _activity = widget.profile.activity;
    _goal = widget.profile.goal;
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_sex == null || _activity == null || _goal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all profile fields.')),
      );
      return;
    }

    widget.profile.age = int.parse(_ageController.text.trim());
    widget.profile.heightCm = double.parse(_heightController.text.trim());
    widget.profile.weightKg = double.parse(_weightController.text.trim());
    widget.profile.sex = _sex;
    widget.profile.activity = _activity;
    widget.profile.goal = _goal;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'user_profile',
      jsonEncode(widget.profile.toJson()),
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            children: [
              _sectionTitle('Personal information'),

              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  suffixText: 'years',
                ),
                validator: (value) {
                  final age = int.tryParse(value?.trim() ?? '');
                  if (age == null || age < 13 || age > 120) {
                    return 'Enter an age between 13 and 120.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _sex,
                decoration: const InputDecoration(labelText: 'Sex'),
                items: const [
                  DropdownMenuItem(
                    value: 'female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem(
                    value: 'male',
                    child: Text('Male'),
                  ),
                ],
                onChanged: (value) => setState(() => _sex = value),
              ),

              const SizedBox(height: 28),

              _sectionTitle('Body measurements'),

              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Height',
                  suffixText: 'cm',
                ),
                validator: (value) {
                  final height = double.tryParse(value?.trim() ?? '');
                  if (height == null || height < 100 || height > 220) {
                    return 'Enter a height between 100 and 220 cm.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  suffixText: 'kg',
                ),
                validator: (value) {
                  final weight = double.tryParse(value?.trim() ?? '');
                  if (weight == null || weight < 30 || weight > 300) {
                    return 'Enter a weight between 30 and 300 kg.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              _sectionTitle('Lifestyle'),

              DropdownButtonFormField<String>(
                initialValue: _activity,
                decoration: const InputDecoration(
                  labelText: 'Activity level',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'sedentary',
                    child: Text('Not very active'),
                  ),
                  DropdownMenuItem(
                    value: 'light',
                    child: Text('Lightly active'),
                  ),
                  DropdownMenuItem(
                    value: 'moderate',
                    child: Text('Moderately active'),
                  ),
                  DropdownMenuItem(
                    value: 'very',
                    child: Text('Very active'),
                  ),
                  DropdownMenuItem(
                    value: 'extreme',
                    child: Text('Extremely active'),
                  ),
                ],
                onChanged: (value) => setState(() => _activity = value),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _goal,
                decoration: const InputDecoration(labelText: 'Goal'),
                items: const [
                  DropdownMenuItem(
                    value: 'lose',
                    child: Text('Lose weight'),
                  ),
                  DropdownMenuItem(
                    value: 'maintain',
                    child: Text('Maintain weight'),
                  ),
                  DropdownMenuItem(
                    value: 'gain',
                    child: Text('Gain weight'),
                  ),
                  DropdownMenuItem(
                    value: 'muscle',
                    child: Text('Build muscle'),
                  ),
                  DropdownMenuItem(
                    value: 'health',
                    child: Text('Improve overall health'),
                  ),
                ],
                onChanged: (value) => setState(() => _goal = value),
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _saveProfile,
                  child: const Text(
                    'Save Changes',
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
