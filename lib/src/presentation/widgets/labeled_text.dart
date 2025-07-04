import 'package:flutter/material.dart';

class LabeledText extends StatelessWidget {
  final String label;
  final String? value;
  const LabeledText({required this.label, this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          ),
        ),
        Text(value ?? '-', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
