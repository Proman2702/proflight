import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/async_helper.dart';
import 'package:proflight/ui/auth_screen/register/view_model.dart';
import 'package:proflight/ui/common/app_toast.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<RegisterScreenModel>();

    return Scaffold(
      backgroundColor: CustomColors.mainDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 24),
            child: Column(
              children: [
                _AuthHeader(
                  title: 'Регистрация',
                  step: model.step,
                  onBack: () => model.step == 0
                      ? context.go('/auth')
                      : model.stepDecrement(),
                ),
                const SizedBox(height: 42),
                _StepFields(step: model.step),
                const SizedBox(height: 58),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 132,
                      height: 38,
                      child: OutlinedButton(
                        onPressed: () => model.step == 0
                            ? context.go('/auth')
                            : model.stepDecrement(),
                        child: const Text('Назад'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    SizedBox(
                      width: 132,
                      height: 38,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: CustomColors.accent1,
                          foregroundColor: CustomColors.main,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: model.allowRegister()
                            ? () async {
                                final success = await withLoadingDialog<bool>(
                                  context: context,
                                  action: model.registerUser,
                                );
                                if (!context.mounted) return;
                                if (!success) {
                                  showAppMessage(
                                    context,
                                    model.errorMessage ?? 'Неизвестная ошибка',
                                  );
                                  return;
                                }
                                context.go('/main');
                              }
                            : model.stepIncrement,
                        child: Text(
                          model.allowRegister() ? 'Создать' : 'Далее',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 42),
                GestureDetector(
                  onTap: () => context.go('/auth'),
                  child: const Text(
                    'Уже есть профиль',
                    style: TextStyle(
                      color: CustomColors.mainText,
                      fontWeight: FontWeight.w800,
                    ),
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

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({
    required this.title,
    required this.step,
    required this.onBack,
  });

  final String title;
  final int step;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBack,
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
        Text(
          title,
          style: const TextStyle(
            color: CustomColors.main,
            fontSize: 34,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        _StepDots(step: step),
      ],
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < 3; index++) ...[
          Container(
            width: index == step ? 28 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index <= step
                  ? CustomColors.accent1
                  : CustomColors.surfaceHigh,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          if (index != 2) const SizedBox(width: 7),
        ],
      ],
    );
  }
}

class _StepFields extends StatelessWidget {
  const _StepFields({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final model = context.read<RegisterScreenModel>();
    return switch (step) {
      0 => Column(
        children: [
          _AuthTextField(
            controller: model.emailController,
            hint: 'Почта',
            icon: Icons.mail_outline,
          ),
          const SizedBox(height: 14),
          _AuthTextField(
            controller: model.passwordController,
            hint: 'Пароль',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
        ],
      ),
      1 => Column(
        children: [
          _AuthTextField(
            controller: model.nameController,
            hint: 'ФИО',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 14),
          _AuthTextField(
            controller: model.companyController,
            hint: 'Авиакомпания',
            icon: Icons.business_outlined,
          ),
          const SizedBox(height: 14),
          _AuthTextField(
            controller: model.boardController,
            hint: 'Название профиля',
            icon: Icons.badge_outlined,
          ),
        ],
      ),
      _ => Column(
        children: [
          _AuthTextField(
            controller: model.totalHoursController,
            hint: 'Налет всего',
            icon: Icons.schedule,
          ),
          const SizedBox(height: 14),
          _AuthTextField(
            controller: model.totalHours1Controller,
            hint: 'Налет днем',
            icon: Icons.wb_sunny_outlined,
          ),
          const SizedBox(height: 14),
          _AuthTextField(
            controller: model.totalHours2Controller,
            hint: 'Налет ночью',
            icon: Icons.nightlight_outlined,
          ),
        ],
      ),
    };
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
