import 'package:flutter/material.dart';

// Reusable InputField Widget
class InputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;

  const InputField({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent),
          SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



