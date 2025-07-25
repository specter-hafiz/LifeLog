import 'package:flutter/material.dart';
import 'package:lifelog/core/utils/app_colors.dart';

class MoodPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const MoodPicker({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Mood:'),
        Expanded(
          child: Slider(
            thumbColor: AppColors.primary,
            activeColor: AppColors.primary,
            min: 1,
            max: 5,
            divisions: 4,
            value: value.toDouble(),
            label: value.toString(),
            onChanged: (val) => onChanged(val.round()),
          ),
        ),
      ],
    );
  }
}
