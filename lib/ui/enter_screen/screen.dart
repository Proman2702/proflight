import 'package:flutter/material.dart';
import 'package:proflight/ui/test_screen/provider.dart';
import 'package:proflight/ui/test_screen/screen.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(create: (_) => CounterProvider(), child: CounterScreen()),
    );
  }
}
