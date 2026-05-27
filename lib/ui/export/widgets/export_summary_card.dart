import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/common/flight_stats.dart';
import 'package:proflight/ui/common/time_badge.dart';

class ExportSummaryCard extends StatelessWidget {
  const ExportSummaryCard({required this.stats, super.key});

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
        children: [
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Вылетов: ${stats.flights}',
                  style: const TextStyle(
                    color: CustomColors.mainText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Посадок: ${stats.landings}',
                style: const TextStyle(
                  color: CustomColors.mainText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
