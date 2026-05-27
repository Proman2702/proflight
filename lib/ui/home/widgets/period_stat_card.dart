import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/common/flight_stats.dart';
import 'package:proflight/ui/common/time_badge.dart';

class PeriodStatCard extends StatelessWidget {
  const PeriodStatCard({required this.title, required this.stats, super.key});

  final String title;
  final FlightStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CustomColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.mainText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Вылетов: ${stats.flights}',
                style: const TextStyle(
                  color: CustomColors.mainText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
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
        ],
      ),
    );
  }
}
