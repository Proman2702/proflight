import 'package:flutter/material.dart';

class TimeFieldRow extends StatelessWidget {
  const TimeFieldRow({
    required this.leftLabel,
    required this.leftController,
    required this.rightLabel,
    required this.rightController,
    super.key,
  });

  final String leftLabel;
  final TextEditingController leftController;
  final String rightLabel;
  final TextEditingController rightController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Field(label: leftLabel, controller: leftController),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Field(label: rightLabel, controller: rightController),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.datetime,
    );
  }
}
