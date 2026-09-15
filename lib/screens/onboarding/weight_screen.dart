import 'package:flutter/material.dart';
import 'activity_screen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  bool isMetric = true;

  final TextEditingController weightController =
      TextEditingController(text: '70');

  void _continue() {
    double weightKg;

    if (isMetric) {
      final weight = double.tryParse(weightController.text);

      if (weight == null || weight < 30 || weight > 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter a weight between 30 and 300 kg.',
            ),
          ),
        );
        return;
      }

      weightKg = weight;
    } else {
      final weight = double.tryParse(weightController.text);

      if (weight == null || weight < 66 || weight > 661) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter a weight between 66 and 661 lb.',
            ),
          ),
        );
        return;
      }

      weightKg = weight * 0.45359237;
    }

    print('Weight in kg: $weightKg');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActivityScreen(),
      ),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tell us about your body',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Your weight helps us personalize your nutrition plan.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              const Center(
                child: Text(
                  'What is your current weight?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('kg'),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('lb'),
                    ),
                  ],
                  selected: {isMetric},
                  onSelectionChanged: (selection) {
                    setState(() {
                      isMetric = selection.first;

                      if (isMetric) {
                        weightController.text = '70';
                      } else {
                        weightController.text = '154';
                      }
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: SizedBox(
                  width: 190,
                  child: TextField(
                    controller: weightController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixText: isMetric ? 'kg' : 'lb',
                      suffixStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: _continue,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Continue',
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
}