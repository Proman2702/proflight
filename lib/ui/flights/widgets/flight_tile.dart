import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/models/flight_data.dart';
import 'package:proflight/ui/common/time_badge.dart';

class FlightTile extends StatelessWidget {
  const FlightTile({required this.flight, required this.onTap, super.key});

  final FlightData flight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final departure = flight.placeDeparture ?? '---';
    final arrival = flight.placeArrival ?? '---';

    return Material(
      color: CustomColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TimeBadge(
                    icon: Icons.schedule,
                    label: _hm(flight.timeAll),
                    color: CustomColors.main,
                  ),
                  const SizedBox(width: 12),
                  TimeBadge(
                    icon: Icons.nightlight_round,
                    label: _hm(flight.timeNight),
                    color: CustomColors.night,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.more_vert,
                    color: CustomColors.mainText,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    departure,
                    style: const TextStyle(
                      color: CustomColors.main,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      height: 1,
                      color: CustomColors.mainText,
                    ),
                  ),
                  Text(
                    arrival,
                    style: const TextStyle(
                      color: CustomColors.main,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${flight.flightDate} ${flight.timeDeparture ?? ''}',
                      style: const TextStyle(color: CustomColors.mainText),
                    ),
                  ),
                  const Text(
                    'UTC+0',
                    style: TextStyle(color: CustomColors.mainText),
                  ),
                  Expanded(
                    child: Text(
                      '${flight.flightDate} ${flight.timeArrival ?? ''}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: CustomColors.mainText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _hm(String? value) {
    if (value == null || value.length < 5) return '00:00';
    return value.substring(0, 5);
  }
}
