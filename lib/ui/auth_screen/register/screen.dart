import 'package:flutter/material.dart';
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
                controller: TextEditingController(text: model.email),
                onChanged: (value) => model.setEmail(value),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 50,
              width: 300,

              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Пароль"),
                controller: TextEditingController(text: model.password),
                onChanged: (value) => model.setPassword(value),
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(onPressed: () => model.leaveWithRegister(context), child: Text("Зарегаться")),
          ],
        ),
      ),
    );
  }
}
