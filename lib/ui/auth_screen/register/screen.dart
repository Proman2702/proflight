import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 50,
              width: 300,

              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Пароль"),
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(onPressed: () {}, child: Text("Зарегаться")),
          ],
        ),
      ),
    );
  }
}
