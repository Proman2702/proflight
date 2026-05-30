import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/ui/common/flight_formatters.dart';

class ProfileDateHeader extends StatelessWidget {
  const ProfileDateHeader({required this.profile, super.key});

  final PilotProfile? profile;

  @override
  Widget build(BuildContext context) {
    final name = profile?.fio.split(' ').take(2).join(' ') ?? 'Профиль';
    final initial = name.characters.isEmpty
        ? 'P'
        : name.characters.first.toUpperCase();

    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => context.go('/main/profile'),
              child: _HeaderPill(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: CustomColors.accent1,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: CustomColors.main,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
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
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
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
          ),
        ),
        const SizedBox(width: 8),
        _HeaderPill(
          width: 112,
          child: Center(
            child: Text(
              FlightFormatters.dateRu(DateTime.now()),
              style: const TextStyle(
                color: CustomColors.main,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.child, this.width});

  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111319),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
