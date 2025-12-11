import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/additional/custom_button.dart';
import 'package:proflight/ui/async_helper.dart';
import 'package:proflight/ui/additional/custom_text_field.dart';
import 'package:proflight/ui/auth_screen/register/view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterScreenModel model = context.watch<RegisterScreenModel>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomColors.background1, CustomColors.background2],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 120),

                Text(
                  "Регистрация",
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      color: CustomColors.main,
                      fontWeight: FontWeight.w800,
                      fontSize: 40,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                _StepHeader(currentStep: model.step),

                SizedBox(height: 35),
                _InputWindow(currentStep: model.step),
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onTap: model.stepDecrement,
                      text: "Вернуться",
                      width: 140,
                      height: 40,
                      color: CustomColors.accent2,
                      fontSize: 18,
                    ),
                    SizedBox(width: 15),
                    CustomButton(
                      onTap: model.allowRegister()
                          ? () async {
                              final success = await withLoadingDialog<bool>(
                                context: context,
                                action: model.registerUser,
                              );
                              if (!context.mounted) return;

                              if (!success) {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(title: Text(model.errorMessage ?? 'Неизвестная ошибка')),
                                );
                              } else {
                                Navigator.of(context).pushNamedAndRemoveUntil("/", (_) => false);
                              }
                            }
                          : model.stepIncrement,
                      text: "Далее",
                      width: 140,
                      height: 40,
                      color: CustomColors.accent2,
                      fontSize: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class _InputWindow extends StatelessWidget {
  final int currentStep;
  const _InputWindow({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final model = context.read<RegisterScreenModel>();

    return Container(
      height: 250,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(20)),
      child: switch (currentStep) {
        0 => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              'Почта',
              style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.main, fontSize: 16),
            ),
            CustomTextField(
              controller: model.emailController,
              key: const ValueKey("email"),

              width: 300,
              shadow: true,
              borderRadius: 15,
            ),
            SizedBox(height: 15),
            Text(
              'Пароль',
              style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.main, fontSize: 16),
            ),
            CustomTextField(
              key: UniqueKey(),
              controller: model.passwordController,
              width: 300,
              shadow: true,
              borderRadius: 15,
            ),
          ],
        ),
        1 => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              'Фио',
              style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.main, fontSize: 16),
            ),
            CustomTextField(
              key: UniqueKey(),
              controller: model.nameController,
              width: 300,
              shadow: true,
              borderRadius: 15,
            ),
            SizedBox(height: 15),
            Text(
              'Авиакомпания',
              style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.main, fontSize: 16),
            ),
            CustomTextField(
              key: UniqueKey(),
              controller: model.companyController,
              width: 300,
              shadow: true,
              borderRadius: 15,
            ),
            SizedBox(height: 15),
            Text(
              'Судно',
              style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.main, fontSize: 16),
            ),
            CustomTextField(
              key: UniqueKey(),
              controller: model.boardController,
              width: 300,
              shadow: true,
              borderRadius: 15,
            ),
          ],
        ),
        2 => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              'Часов всего',
              style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.main, fontSize: 16),
            ),
            CustomTextField(
              key: UniqueKey(),
              controller: model.totalHoursController,
              width: 300,
              shadow: true,
              borderRadius: 15,
            ),
            SizedBox(height: 15),
            Text(
              'Часов еще че то',
              style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.main, fontSize: 16),
            ),
            CustomTextField(
              key: UniqueKey(),
              controller: model.totalHours1Controller,
              width: 300,
              shadow: true,
              borderRadius: 15,
            ),
            SizedBox(height: 15),
            Text(
              'Ну и еще',
              style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.main, fontSize: 16),
            ),
            CustomTextField(
              key: UniqueKey(),
              controller: model.totalHours2Controller,
              width: 300,
              shadow: true,
              borderRadius: 15,
            ),
          ],
        ),
        _ => SizedBox(),
      },
    );
  }
}

class _StepHeader extends StatelessWidget {
  final int currentStep;

  const _StepHeader({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StepCircle(index: 0, currentStep: currentStep),
            _StepLine(isActive: currentStep >= 1),
            _StepCircle(index: 1, currentStep: currentStep),
            _StepLine(isActive: currentStep >= 2),
            _StepCircle(index: 2, currentStep: currentStep),
          ],
        ),
        SizedBox(height: 5),
        switch (currentStep) {
          0 => Container(
            width: 310,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 120,
              child: Text(
                'Введите данные для входа',
                textAlign: TextAlign.center,
                style: TextStyle(color: CustomColors.main, fontSize: 12),
                maxLines: 2,
                softWrap: true,
              ),
            ),
          ),
          1 => SizedBox(
            width: 120,
            child: Text(
              'Введите данные о себе',
              textAlign: TextAlign.center,
              style: TextStyle(color: CustomColors.main, fontSize: 12),
              maxLines: 2,
              softWrap: true,
            ),
          ),
          2 => Container(
            width: 310,
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 120,
              child: Text(
                'Укажите кол-во часов налета',
                textAlign: TextAlign.center,
                style: TextStyle(color: CustomColors.main, fontSize: 12),
                maxLines: 2,
                softWrap: true,
              ),
            ),
          ),
          _ => SizedBox(),
        },
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final int currentStep;

  const _StepCircle({required this.index, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentStep;
    final isDone = index < currentStep;

    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive || isDone ? CustomColors.accent2 : CustomColors.inActive,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;

  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(width: 50, height: 4, color: isActive ? CustomColors.accent2 : CustomColors.inActive);
  }
}
