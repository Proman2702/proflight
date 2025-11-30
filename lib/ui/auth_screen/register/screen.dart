import 'package:flutter/material.dart';
import 'package:proflight/ui/async_helper.dart';
import 'package:proflight/ui/auth_screen/register/view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<RegisterScreenModel>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: 300,

              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Почта"),

                onChanged: (value) => model.setEmail(value),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 50,
              width: 300,

              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Пароль"),
                onChanged: (value) => model.setPassword(value),
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                final success = await withLoadingDialog<bool>(context: context, action: model.registerUser);
                if (!context.mounted) return;

                if (success) {
                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(title: Text(model.errorMessage ?? 'Неизвестная ошибка')),
                  );
                }
              },
              child: const Text("Зарегаться"),
            ),
          ],
        ),
      ),
    );
  }
}
