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
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text(value ?? '-', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
