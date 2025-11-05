import 'package:flutter/material.dart';
import 'package:proflight/ui/main_screen/provider.dart';
import 'package:provider/provider.dart';

import '../../etc/colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainScreenModule(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3255AC), Color(0xFF1C1C1E)],
            begin: Alignment.topCenter,
            end: Alignment(0, -0.5),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(color: Color(0xFF121212)),
                        alignment: Alignment.center,
                        child: Text("зделать профиль", style: TextStyle(color: Color(CustomColors.main), fontSize: 14)),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(color: Color(0xFF121212)),
                        alignment: Alignment.center,
                        child: Text("зделать дату"),
                      ),
                    ],
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [Text("главный экран")]),
            ),
          ),
        ),
      ),
    );
  }
}
