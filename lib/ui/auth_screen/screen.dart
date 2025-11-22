import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          colors: [Color.fromARGB(255, 13, 35, 54), Color.fromARGB(255, 76, 154, 196)],
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
                            color: Colors.white,
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
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 52,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(height: 100),
                Container(
                  height: 40,
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.account_circle_rounded, color: const Color.fromARGB(255, 195, 128, 145)),
                      SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: TextField(
                          style: TextStyle(fontSize: 20),

                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hint: Text('Почта', style: TextStyle(color: Colors.black26, fontSize: 20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 40,
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.lock, color: const Color.fromARGB(255, 195, 128, 145)),
                      SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: TextField(
                          style: TextStyle(fontSize: 20),

                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hint: Text('Пароль', style: TextStyle(color: Colors.black26, fontSize: 20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: 300,
                  alignment: Alignment.topRight,
                  child: Text(
                    'Забыли пароль?',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
                SizedBox(height: 100),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent,

                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(15),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 195, 128, 145),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: 190,
                        height: 36,
                        alignment: Alignment.center,
                        child: Text(
                          'Войти',
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => model.goToRegister(context),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Создать профиль',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(width: 155, height: 0.5, color: Colors.white),
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
