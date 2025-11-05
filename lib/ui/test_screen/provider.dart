import "package:flutter/foundation.dart";

class CounterProvider extends ChangeNotifier {
  int _counter = 0;

  void increment() {
    _counter++;
    notifyListeners();
  }

  int get counter => _counter;
}
