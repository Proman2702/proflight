import 'package:flutter/material.dart';
import 'package:proflight/ui/additional/custom_button.dart';
import 'package:proflight/ui/main_screen/view_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainScreenModel>();
    return Scaffold(
      extendBody: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Главное меню"),

            ElevatedButton(onPressed: model.signOut, child: Text("Выйти")),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButtonModified(
                  onTap: () async {},
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                  child: Icon(Icons.send),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    "Отправить запрос на сервер",
                    style: TextStyle(fontSize: 9),
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
