import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/common/flight_stats.dart';
import 'package:proflight/ui/common/time_badge.dart';

class PeriodStatCard extends StatelessWidget {
  const PeriodStatCard({
    required this.title,
    required this.stats,
    this.highlighted = false,
    super.key,
  });

  final String title;
  final FlightStats stats;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFF111319) : CustomColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted
              ? CustomColors.accent1.withValues(alpha: 0.55)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$title:',
                  style: TextStyle(
                    color: highlighted
                        ? CustomColors.main
                        : CustomColors.mainText,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'Вылетов: ${stats.flights}',
                style: const TextStyle(
                  color: CustomColors.mainText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
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
