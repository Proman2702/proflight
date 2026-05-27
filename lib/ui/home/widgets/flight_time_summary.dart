import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/common/flight_stats.dart';
import 'package:proflight/ui/common/time_badge.dart';

class FlightTimeSummary extends StatelessWidget {
  const FlightTimeSummary({required this.stats, super.key});

  final FlightStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Общее время',
          style: TextStyle(color: CustomColors.mainText),
        ),
        Text(
          stats.totalLabel,
          style: const TextStyle(
            color: CustomColors.main,
            fontSize: 38,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CustomColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TimeBadge(
                icon: Icons.schedule,
                label: stats.totalLabel,
                color: CustomColors.main,
              ),
              TimeBadge(
                icon: Icons.wb_sunny,
                label: stats.dayLabel,
                color: CustomColors.sun,
              ),
              TimeBadge(
                icon: Icons.nightlight_round,
                label: stats.nightLabel,
                color: CustomColors.night,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
