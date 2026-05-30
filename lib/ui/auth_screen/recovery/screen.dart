import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/async_helper.dart';
import 'package:proflight/ui/auth_screen/recovery/view_model.dart';
import 'package:proflight/ui/common/app_toast.dart';
import 'package:provider/provider.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<RecoveryScreenModel>();

    return Scaffold(
      backgroundColor: CustomColors.mainDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => context.go('/auth'),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: CustomColors.main,
                    ),
                  ),
                ),
                Container(
                  width: 66,
                  height: 66,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: CustomColors.accent1,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'P',
                    style: TextStyle(
                      color: CustomColors.main,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Восстановление',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.main,
                    fontSize: 32,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  width: 300,
                  child: Text(
                    'Введите почту аккаунта. Мы отправим письмо для восстановления пароля.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.mainText,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 54),
                _AuthTextField(
                  controller: model.emailController,
                  hint: 'Почта',
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: 86),
                SizedBox(
                  width: 200,
                  height: 38,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: CustomColors.accent1,
                      foregroundColor: CustomColors.main,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final success = await withLoadingDialog<bool>(
                        context: context,
                        action: model.sendVerification,
                      );
                      if (!context.mounted) return;
                      if (!success) {
                        showAppMessage(
                          context,
                          model.errorMessage ?? 'Неизвестная ошибка',
                        );
                        return;
                      }
                      showAppMessage(context, 'Письмо отправлено');
                      context.go('/auth');
                    },
                    child: const Text(
                      'Отправить',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => context.go('/auth'),
                  child: const Column(
                    children: [
                      Text(
                        'Вернуться ко входу',
                        style: TextStyle(
                          color: CustomColors.main,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      SizedBox(
                        width: 145,
                        child: Divider(height: 1, color: CustomColors.main),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 44,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: CustomColors.mainDark, fontSize: 17),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF6F737C)),
          prefixIcon: Icon(icon, color: CustomColors.accent1, size: 22),
          filled: true,
          fillColor: const Color(0xFFEEF1F6),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: CustomColors.accent1, width: 2),
          ),
        ),
      ),
    );
  }
}
