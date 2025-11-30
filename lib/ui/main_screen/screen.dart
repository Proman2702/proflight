import 'package:flutter/material.dart';
import 'package:proflight/ui/main_screen/view_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainScreenModel>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Главное меню"),
            ElevatedButton(onPressed: model.signOut, child: Text("Выйти")),
          ],
        ),
      ),
    );
  }
}
