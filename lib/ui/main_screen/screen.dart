import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proflight/models/flight.dart';
import 'package:provider/provider.dart';

import '../../etc/colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final flights = Provider.of<QuerySnapshot<Flight>?>(context)?.docs;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3255AC), Color(0xFF1C1C1E)],
          begin: Alignment.topCenter,
          end: Alignment(0, -0.5),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(color: Color(0xFF121212)),
                      alignment: Alignment.center,
                      child: Text("зделать профиль", style: TextStyle(color: Color(CustomColors.main), fontSize: 14)),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(color: Color(0xFF121212)),
                      alignment: Alignment.center,
                      child: Text("зделать дату"),
                    ),
                  ],
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 80),
                Text("Общее время"),
                Text("ЗДЕЛАТЬ ВРЕМЯ СКА"),
                SizedBox(height: 80),
                Container(
                  width: 350,
                  height: 100,
                  decoration: BoxDecoration(color: Color(0xFF121212), borderRadius: BorderRadius.circular(15)),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 162,
                      height: 70,
                      decoration: BoxDecoration(color: Color(0xFF121212), borderRadius: BorderRadius.circular(15)),
                    ),
                    SizedBox(width: 4),
                    Container(
                      width: 162,
                      height: 70,
                      decoration: BoxDecoration(color: Color(0xFF121212), borderRadius: BorderRadius.circular(15)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "За день",
                  style: TextStyle(color: Color(CustomColors.main), fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Container(
                  width: 350,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color(CustomColors.mainDark),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Прочие периоды",
                  style: TextStyle(color: Color(CustomColors.main), fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Container(
                  width: 350,
                  height: 90,
                  decoration: BoxDecoration(color: Color(0xFF121212), borderRadius: BorderRadius.circular(15)),
                ),
                SizedBox(height: 10),
                Container(
                  width: 350,
                  height: 90,
                  decoration: BoxDecoration(color: Color(0xFF121212), borderRadius: BorderRadius.circular(15)),
                ),
                SizedBox(height: 10),
                Container(
                  width: 350,
                  height: 90,
                  decoration: BoxDecoration(color: Color(0xFF121212), borderRadius: BorderRadius.circular(15)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
