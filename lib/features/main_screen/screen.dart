import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proflight/repositories/database/models/flight.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flights = Provider.of<QuerySnapshot<Flight>?>(context)?.docs;
    return Scaffold(
      body: Center(
        child: Column(children: flights?.map((e) => Text(e.data().toString())).toList() ?? [Text('нет данных')]),
      ),
    );
  }
}
