import 'package:flutter/material.dart';
import 'package:proflight/features/main_screen/model.dart';
import 'package:proflight/features/main_screen/screen.dart';
import 'package:proflight/repositories/database/database_service.dart';
import 'package:provider/provider.dart';

class MainScreenProvider extends StatelessWidget {
  const MainScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(initialData: null, value: FlightDatabaseService().getElements(), child: MainScreen());
  }
}
