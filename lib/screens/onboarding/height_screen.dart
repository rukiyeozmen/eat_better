import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'weight_screen.dart';

class HeightScreen extends StatefulWidget {
  final UserProfile profile;

  const HeightScreen({
    super.key,
    required this.profile,
  });

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  bool isMetric = true;

  final TextEditingController heightController =
      TextEditingController(text: '165');

  final TextEditingController feetController =
      TextEditingController(text: '5');

  final TextEditingController inchesController =
      TextEditingController(text: '5');

  void _continue() {
    double heightCm;

    if (isMetric) {
      final height = double.tryParse(heightController.text);

      if (height == null || height < 100 || height > 220) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter a height between 100 and 220 cm.',
            ),
          ),
        );
        return;
      }

      heightCm = height;
    } else {
      final feet = int.tryParse(feetController.text);
      final inches = int.tryParse(inchesController.text);

      if (feet == null ||
          inches == null ||
          feet < 3 ||
          feet > 7 ||
          inches < 0 ||
          inches > 11) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter a valid height.',
            ),
          ),
        );
        return;
      }

      heightCm = (feet * 30.48) + (inches * 2.54);

      if (heightCm < 100 || heightCm > 220) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter a height between 100 and 220 cm.',
            ),
          ),
        );
        return;
      }
    }

    widget.profile.heightCm = heightCm;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeightScreen(
          profile: widget.profile,
        ),
      ),
    );
  }

  @override
  void dispose() {
    heightController.dispose();
    feetController.dispose();
    inchesController.dispose();
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
                'Your height helps us personalize your nutrition plan.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              const Center(
                child: Text(
                  'How tall are you?',
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
                      label: Text('cm'),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('ft / in'),
                    ),
                  ],
                  selected: {isMetric},
                  onSelectionChanged: (selection) {
                    setState(() {
                      isMetric = selection.first;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              if (isMetric)
                Center(
                  child: SizedBox(
                    width: 180,
                    child: TextField(
                      controller: heightController,
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
                        suffixText: 'cm',
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
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: feetController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          suffixText: 'ft',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: inchesController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          suffixText: 'in',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
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