import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/ui/common/flight_formatters.dart';

class ProfileDateHeader extends StatelessWidget {
  const ProfileDateHeader({required this.profile, super.key});

  final PilotProfile? profile;

  @override
  Widget build(BuildContext context) {
    final name = profile?.fio.split(' ').take(2).join(' ') ?? 'Профиль';
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: CustomColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: CustomColors.accent1,
                  child: Text(
                    name.characters.first.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CustomColors.main,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: CustomColors.mainText,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: CustomColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            FlightFormatters.dateRu(DateTime.now()),
            style: const TextStyle(
              color: CustomColors.main,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
