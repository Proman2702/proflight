import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/additional/custom_button.dart';
import 'package:proflight/ui/async_helper.dart';
import 'package:proflight/ui/additional/custom_text_field.dart';
import 'package:proflight/ui/auth_screen/view_model.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthScreenModel>();

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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://www.dropbox.com/scl/fi/ewgdjpbhku51fgc0loe49/nik.png?rlkey=bdf7kv74xt1aq3ihv0t0eeq12&dl=1',
                      height: 80,
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "---",
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            color: CustomColors.main,
                            fontWeight: FontWeight.w900,
                            fontSize: 42,
                            letterSpacing: 6.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "ProFlight",
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
                  text: 'Почта',
                  onChanged: (value) => model.setEmail(value),
                ),
                SizedBox(height: 15),
                CustomTextField(
                  onChanged: (value) => model.setPassword(value),
                  text: 'Пароль',
                  leading: Icon(Icons.key, color: CustomColors.accent2),
                  obscured: true,
                ),
                SizedBox(height: 5),
                Container(
                  width: 300,
                  alignment: Alignment.topRight,
                  child: Text(
                    'Забыли пароль?',
                    style: TextStyle(fontWeight: FontWeight.w600, color: CustomColors.main),
                  ),
                ),
                SizedBox(height: 100),

                CustomButton(
                  onTap: () async {
                    final success = await withLoadingDialog<bool>(context: context, action: model.signInUser);
                    if (!context.mounted) return;

                    if (!success) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(title: Text(model.errorMessage ?? 'Неизвестная ошибка')),
                      );
                    }
                  },
                  text: 'Войти',
                  width: 190,
                  height: 36,
                  color: CustomColors.accent2,
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/register"),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Создать профиль',
                      style: TextStyle(
                        color: CustomColors.main,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        decorationColor: CustomColors.main,
                      ),
                    ),
                  ),
                ),
                Container(width: 155, height: 0.5, color: CustomColors.main),
                SizedBox(height: 55),
                Text(
                  'Created and designed by Proman2702',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black12),
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
