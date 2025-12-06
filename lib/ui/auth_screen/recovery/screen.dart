import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/async_helper.dart';
import 'package:proflight/ui/auth_screen/additional/custom_text_field.dart';
import 'package:proflight/ui/auth_screen/recovery/view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      color: CustomColors.main,
                      fontWeight: FontWeight.w900,
                      fontSize: 52,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(height: 100),
                CustomTextField(
                  leading: Icon(Icons.account_circle_rounded, color: CustomColors.accent2),
                  onChanged: (value) => model.setEmail(value),
                ),
                SizedBox(height: 100),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent,

                  child: InkWell(
                    onTap: () async {
                      final success = await withLoadingDialog<bool>(context: context, action: model.sendVerification);
                      if (!context.mounted) return;

                      if (!success) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(title: Text(model.errorMessage ?? 'Неизвестная ошибка')),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Ink(
                      decoration: BoxDecoration(color: CustomColors.accent2, borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        width: 250,
                        height: 36,
                        alignment: Alignment.center,
                        child: Text(
                          'Зарегистрироваться',
                          style: TextStyle(fontSize: 20, color: CustomColors.main, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
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
