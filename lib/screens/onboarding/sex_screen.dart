import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'height_screen.dart';

class SexScreen extends StatefulWidget {
  final UserProfile profile;

  const SexScreen({
    super.key,
    required this.profile,
  });

  @override
  State<SexScreen> createState() => _SexScreenState();
}

class _SexScreenState extends State<SexScreen> {
  String? selectedSex;

  void _continue() {
    if (selectedSex == null) {
      return;
    }

    widget.profile.sex = selectedSex;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeightScreen(
          profile: widget.profile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Tell us a little more',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'We use this information to make your '
                'nutrition calculations more accurate.',
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              const Center(
                child: Text(
                  'What is your sex?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              _SexOption(
                title: 'Female',
                icon: Icons.female,
                selected: selectedSex == 'female',
                onTap: () {
                  setState(() {
                    selectedSex = 'female';
                  });
                },
              ),

              const SizedBox(height: 16),

              _SexOption(
                title: 'Male',
                icon: Icons.male,
                selected: selectedSex == 'male',
                onTap: () {
                  setState(() {
                    selectedSex = 'male';
                  });
                },
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: selectedSex == null ? null : _continue,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SexOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SexOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),

            const SizedBox(width: 16),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            if (selected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}