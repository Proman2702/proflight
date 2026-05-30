import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: CustomColors.main, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.main,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText!,
                  style: const TextStyle(
                    color: CustomColors.mainText,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(
                Icons.chevron_right,
                color: CustomColors.mainText,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
