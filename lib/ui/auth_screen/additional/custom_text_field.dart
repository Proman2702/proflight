import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.onChanged, required this.leading, this.obscured = false});

  final Function(String)? onChanged;
  final Icon leading;

  final bool obscured;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 300,
      padding: EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: CustomColors.fill, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          leading,
          SizedBox(width: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250),
            child: TextField(
              style: TextStyle(fontSize: 20),
              onChanged: onChanged,
              obscureText: obscured,

              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hint: Text('Почта', style: TextStyle(color: Colors.black26, fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
