import 'package:flutter/material.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/ui/common/app_toast.dart';
import 'package:proflight/ui/profile/view_model.dart';
import 'package:proflight/ui/profile/widgets/profile_header_card.dart';
import 'package:proflight/ui/profile/widgets/profile_menu_tile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ProfileViewModel>();
    final failure = model.takeFailure();
    if (failure != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) showAppToast(context, failure);
      });
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          ProfileHeaderCard(profile: model.profile, email: model.email),
          const SizedBox(height: 12),
          ProfileMenuTile(
            icon: Icons.palette_outlined,
            title: 'Внешний вид',
            onTap: () => _showProfileEditor(context),
          ),
          const SizedBox(height: 8),
          ProfileMenuTile(
            icon: Icons.lock_outline,
            title: 'Логин и пароль',
            onTap: () => showAppMessage(context, 'Раздел будет добавлен позже'),
          ),
          const SizedBox(height: 8),
          ProfileMenuTile(
            icon: Icons.language,
            title: 'Язык',
            onTap: () => showAppMessage(context, 'Раздел будет добавлен позже'),
          ),
          const SizedBox(height: 8),
          ProfileMenuTile(
            icon: Icons.flight,
            title: 'Список воздушных судов',
            onTap: () => showAppMessage(context, 'Раздел будет добавлен позже'),
          ),
          const SizedBox(height: 8),
          ProfileMenuTile(
            icon: Icons.pin_drop_outlined,
            title: 'Коды аэропортов',
            trailingText: model.airportCodeFormat,
            onTap: () => _showAirportCodeEditor(context),
          ),
          const SizedBox(height: 8),
          ProfileMenuTile(
            icon: Icons.backup_outlined,
            title: 'Бэкап данных',
            onTap: () => showAppMessage(context, 'Раздел будет добавлен позже'),
          ),
          const SizedBox(height: 8),
          ProfileMenuTile(
            icon: Icons.settings_outlined,
            title: 'Настройки',
            onTap: () => _showProfileEditor(context),
          ),
          const SizedBox(height: 8),
          ProfileMenuTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Политика конфиденциальности',
            onTap: () => showAppMessage(context, 'Раздел будет добавлен позже'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.read<ProfileViewModel>().signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  Future<void> _showProfileEditor(BuildContext context) async {
    final model = context.read<ProfileViewModel>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CustomColors.surface,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Профиль пилота',
                style: TextStyle(
                  color: CustomColors.main,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: model.fioController,
                style: const TextStyle(color: CustomColors.main),
                decoration: const InputDecoration(labelText: 'ФИО'),
              ),
              TextField(
                controller: model.companyController,
                style: const TextStyle(color: CustomColors.main),
                decoration: const InputDecoration(labelText: 'Компания'),
              ),
              TextField(
                controller: model.addAllController,
                style: const TextStyle(color: CustomColors.main),
                decoration: const InputDecoration(labelText: 'Add all'),
              ),
              TextField(
                controller: model.addDayController,
                style: const TextStyle(color: CustomColors.main),
                decoration: const InputDecoration(labelText: 'Add day'),
              ),
              TextField(
                controller: model.addNightController,
                style: const TextStyle(color: CustomColors.main),
                decoration: const InputDecoration(labelText: 'Add night'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  final result = await model.save();
                  if (!context.mounted) return;
                  if (result is Err<PilotProfile>) {
                    showAppToast(context, result.error);
                    return;
                  }
                  Navigator.pop(context);
                  showAppMessage(context, 'Профиль обновлен');
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAirportCodeEditor(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: CustomColors.surface,
      builder: (context) {
        final model = context.watch<ProfileViewModel>();
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Коды аэропортов',
                style: TextStyle(
                  color: CustomColors.main,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Как отображать и добавлять аэропорты в полетах.',
                style: TextStyle(
                  color: CustomColors.mainText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              _AirportCodeButton(
                label: 'IATA',
                description: 'Трехбуквенный код: SVO, CDG, JFK',
                selected: model.airportCodeFormat == 'IATA',
                onTap: () => _saveAirportCodeFormat(context, 'IATA'),
              ),
              const SizedBox(height: 8),
              _AirportCodeButton(
                label: 'ICAO',
                description: 'Четырехбуквенный код: UUEE, LFPG, KJFK',
                selected: model.airportCodeFormat == 'ICAO',
                onTap: () => _saveAirportCodeFormat(context, 'ICAO'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveAirportCodeFormat(
    BuildContext context,
    String value,
  ) async {
    final result = await context.read<ProfileViewModel>().saveAirportCodeFormat(
      value,
    );
    if (!context.mounted) return;
    if (result is Err<PilotProfile>) {
      showAppToast(context, result.error);
      return;
    }
    Navigator.pop(context);
    showAppMessage(context, 'Формат кодов обновлен');
  }
}

class _AirportCodeButton extends StatelessWidget {
  const _AirportCodeButton({
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? CustomColors.surfaceHigh : CustomColors.mainDark,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? CustomColors.accent1 : CustomColors.mainText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: CustomColors.main,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        color: CustomColors.mainText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
