import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/async_helper.dart';
import 'package:proflight/ui/auth_screen/view_model.dart';
import 'package:proflight/ui/common/app_toast.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthScreenModel>();

    return Scaffold(
      backgroundColor: CustomColors.mainDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
            child: Column(
              children: [
                const _BrandHeader(),
                const SizedBox(height: 72),
                _AuthTextField(
                  controller: model.emailController,
                  hint: 'Почта',
                  icon: Icons.account_circle_rounded,
                ),
                const SizedBox(height: 14),
                _AuthTextField(
                  controller: model.passwordController,
                  hint: 'Пароль',
                  icon: Icons.key_rounded,
                  obscureText: true,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 300,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/auth/recovery'),
                      style: TextButton.styleFrom(
                        foregroundColor: CustomColors.main,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        'Забыли пароль?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 86),
                SizedBox(
                  width: 190,
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
                        action: model.signInUser,
                      );
                      if (!context.mounted) return;
                      if (!success) {
                        showAppMessage(
                          context,
                          model.errorMessage ?? 'Неизвестная ошибка',
                        );
                      }
                    },
                    child: const Text(
                      'Войти',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => context.push('/auth/register'),
                  child: const Column(
                    children: [
                      Text(
                        'Создать профиль',
                        style: TextStyle(
                          color: CustomColors.main,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      SizedBox(
                        width: 130,
                        child: Divider(height: 1, color: CustomColors.main),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 56),
                const Text(
                  'Created and designed by Proman2702',
                  style: TextStyle(
                    color: Color(0xFF3A3B40),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
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

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 78,
          height: 78,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: CustomColors.accent1,
            shape: BoxShape.circle,
          ),
          child: const Text(
            'P',
            style: TextStyle(
              color: CustomColors.main,
              fontSize: 42,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'ProFlight',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: CustomColors.main,
            fontSize: 48,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 44,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
