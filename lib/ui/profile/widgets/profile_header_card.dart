import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/models/pilot_profile.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    required this.profile,
    required this.email,
    super.key,
  });

  final PilotProfile? profile;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final fio = profile?.fio ?? 'Профиль пилота';
    final initial = fio.characters.isEmpty
        ? 'P'
        : fio.characters.first.toUpperCase();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: CustomColors.night,
            child: Text(
              initial,
              style: const TextStyle(
                color: CustomColors.main,
                fontSize: 42,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fio,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CustomColors.main,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email ?? '',
            style: const TextStyle(color: CustomColors.mainText),
          ),
        ],
      ),
    );
  }
}
