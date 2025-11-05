import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflight/ui/test_screen/provider.dart';
import 'package:proflight/ui/test_screen/screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 13, 13, 54), Color.fromARGB(255, 76, 110, 196)],
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
                    Image.asset("assets/images/nik.png", height: 80),
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
                SizedBox(height: 120),
                Container(
                  height: 40,
                  width: 300,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.account_circle_rounded, color: Colors.black54),
                      SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: TextField(decoration: InputDecoration(border: InputBorder.none)),
                      ),
                    ],
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
