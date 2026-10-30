
import 'package:flutter/material.dart';

import '../models/meal.dart';

class MealHistoryScreen extends StatefulWidget {
  final List<Meal> meals;

  const MealHistoryScreen({
    super.key,
    required this.meals,
  });

  @override
  State<MealHistoryScreen> createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  DateTime selectedDate = DateTime.now();
  late DateTime displayedMonth;

  @override
  void initState() {
    super.initState();
    displayedMonth = DateTime(selectedDate.year, selectedDate.month);
  }

  // Meals and nutrition totals for the selected date.
  List<Meal> get selectedMeals {
    return widget.meals.where((meal) {
      return DateUtils.isSameDay(meal.date, selectedDate);
    }).toList();
  }

  int get selectedCalories =>
      selectedMeals.fold(0, (sum, meal) => sum + meal.calories);

  double get selectedProtein =>
      selectedMeals.fold(0.0, (sum, meal) => sum + meal.protein);

  double get selectedCarbs =>
      selectedMeals.fold(0.0, (sum, meal) => sum + meal.carbs);

  double get selectedFat =>
      selectedMeals.fold(0.0, (sum, meal) => sum + meal.fat);

  bool _hasMeals(DateTime date) {
    return widget.meals.any((meal) {
      return DateUtils.isSameDay(meal.date, date);
    });
  }

  void _changeMonth(int amount) {
    setState(() {
      displayedMonth = DateTime(
        displayedMonth.year,
        displayedMonth.month + amount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );

    final daysInMonth = DateUtils.getDaysInMonth(
      displayedMonth.year,
      displayedMonth.month,
    );

    final startingWeekday = firstDay.weekday - 1;

    final dates = List<DateTime?>.generate(42, (index) {
      final day = index - startingWeekday + 1;

      if (day < 1 || day > daysInMonth) {
        return null;
      }

      return DateTime(displayedMonth.year, displayedMonth.month, day);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal History'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => _changeMonth(-1),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        '${_monthName(displayedMonth.month)} '
                        '${displayedMonth.year}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _changeMonth(1),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      'Mon', 'Tue', 'Wed', 'Thu',
                      'Fri', 'Sat', 'Sun',
                    ].map((day) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dates.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      final date = dates[index];

                      if (date == null) {
                        return const SizedBox.shrink();
                      }

                      final isSelected =
                          DateUtils.isSameDay(date, selectedDate);
                      final isToday =
                          DateUtils.isSameDay(date, DateTime.now());
                      final hasMeals = _hasMeals(date);

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            border: isToday && !isSelected
                                ? Border.all(
                                    color: Theme.of(context)
                                        .colorScheme.primary,
                                  )
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : null,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: hasMeals
                                      ? (isSelected
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme.primary)
                                      : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Daily Nutrition',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Calories: $selectedCalories kcal'),
                  Text('Protein: ${selectedProtein.toStringAsFixed(1)} g'),
                  Text('Carbs: ${selectedCarbs.toStringAsFixed(1)} g'),
                  Text('Fat: ${selectedFat.toStringAsFixed(1)} g'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Meals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (selectedMeals.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('No meals saved for this date.'),
              ),
            )
          else
            ...selectedMeals.map((meal) {
              return Card(
                child: ListTile(
                  title: Text(meal.name),
                  subtitle: Text(
                    '${meal.calories} kcal · '
                    'P: ${meal.protein.toStringAsFixed(1)} g · '
                    'C: ${meal.carbs.toStringAsFixed(1)} g · '
                    'F: ${meal.fat.toStringAsFixed(1)} g',
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];

    return months[month - 1];
  }
}
