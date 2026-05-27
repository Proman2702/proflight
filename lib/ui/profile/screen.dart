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
                decoration: const InputDecoration(labelText: 'ФИО'),
              ),
              TextField(
                controller: model.companyController,
                decoration: const InputDecoration(labelText: 'Компания'),
              ),
              TextField(
                controller: model.addAllController,
                decoration: const InputDecoration(labelText: 'Add all'),
              ),
              TextField(
                controller: model.addDayController,
                decoration: const InputDecoration(labelText: 'Add day'),
              ),
              TextField(
                controller: model.addNightController,
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
}
