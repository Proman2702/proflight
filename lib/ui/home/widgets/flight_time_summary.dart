import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/common/flight_stats.dart';
import 'package:proflight/ui/common/time_badge.dart';

class FlightTimeSummary extends StatelessWidget {
  const FlightTimeSummary({required this.stats, super.key});

  final FlightStats stats;

  @override
  Widget build(BuildContext context) {
    final totalMinutes = stats.total.inMinutes;
    final dayShare = totalMinutes == 0
        ? 0.0
        : stats.day.inMinutes / totalMinutes;

    return Column(
      children: [
        const Text(
          'Общее время',
          style: TextStyle(color: Color(0xFFC7D4F4), fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          stats.totalLabel,
          style: const TextStyle(
            color: CustomColors.main,
            fontSize: 38,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF111319),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 5,
                  child: Row(
                    children: [
                      Expanded(
                        flex: (dayShare * 1000).round().clamp(1, 999),
                        child: Container(color: CustomColors.sun),
                      ),
                      Expanded(
                        flex: ((1 - dayShare) * 1000).round().clamp(1, 999),
                        child: Container(color: CustomColors.night),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
