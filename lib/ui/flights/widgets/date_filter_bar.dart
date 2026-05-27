import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/common/flight_formatters.dart';

class DateFilterBar extends StatelessWidget {
  const DateFilterBar({
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CustomColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${FlightFormatters.dateRu(selectedDate)}, ${_weekday(selectedDate)}',
              style: const TextStyle(
                color: CustomColors.main,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        IconButton.filled(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
        IconButton.filled(onPressed: () {}, icon: const Icon(Icons.filter_alt)),
      ],
    );
  }

  String _weekday(DateTime date) {
    return switch (date.weekday) {
      DateTime.monday => 'пн',
      DateTime.tuesday => 'вт',
      DateTime.wednesday => 'ср',
      DateTime.thursday => 'чт',
      DateTime.friday => 'пт',
      DateTime.saturday => 'сб',
      _ => 'вс',
    };
  }
}
