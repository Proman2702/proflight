import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.onChanged,
    this.controller,
    this.leading,
    this.text = '',
    this.obscured = false,
    this.width = 300,
    this.borderRadius = 20,
    this.shadow = false,
  });

  final Icon? leading;
  final String text;
  final double width;
  final double borderRadius;
  final bool shadow;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  final bool obscured;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CustomColors.main,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow ? [BoxShadow(offset: Offset(0, 3), color: Colors.black26, blurRadius: 3)] : [],
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: (leading != null) ? width - 60 : width - 30),
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 20),
              onChanged: onChanged,
              obscureText: obscured,

              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,

                hint: Text(text, style: TextStyle(color: Colors.black26, fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
