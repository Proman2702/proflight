import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/additional/custom_button.dart';
import 'package:proflight/ui/async_helper.dart';
import 'package:proflight/ui/additional/custom_text_field.dart';
import 'package:proflight/ui/auth_screen/recovery/view_model.dart';
import 'package:provider/provider.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<RecoveryScreenModel>();

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
                SizedBox(height: 150),

                Text(
                  maxLines: 2,
                  "Восстановление пароля",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      color: CustomColors.main,
                      fontWeight: FontWeight.w900,
                      fontSize: 38,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(height: 100),
                SizedBox(
                  width: 300,

                  child: Text(
                    "Введите почту уже зарегистрированного аккаунта, который хотите восстановить",
                    style: TextStyle(color: CustomColors.main),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(controller: model.emailController),
                SizedBox(height: 200),

                CustomButton(
                  onTap: () async {
                    final success = await withLoadingDialog<bool>(
                      context: context,
                      action: model.sendVerification,
                    );
                    if (!context.mounted) return;

                    if (!success) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            model.errorMessage ?? 'Неизвестная ошибка',
                          ),
                        ),
                      );
                    } else {
                      context.go('/auth');
                    }
                  },
                  text: "Восстановить",
                  width: 200,
                  height: 36,
                  color: CustomColors.accent2,
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
