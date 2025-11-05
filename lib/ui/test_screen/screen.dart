import 'package:flutter/material.dart';

import 'package:proflight/ui/test_screen/provider.dart';
import 'package:provider/provider.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int value = context.watch<CounterProvider>().counter;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Нажато: $value"),
          GestureDetector(onTap: context.read<CounterProvider>().increment, child: Icon(Icons.add)),
        ],
      ),
    );
  }
}
