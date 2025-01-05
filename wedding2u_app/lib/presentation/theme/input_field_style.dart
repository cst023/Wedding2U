import 'package:flutter/material.dart';

// Reusable InputField Widget
class InputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;

  const InputField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFf7706d)),
          const SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: const TextStyle(fontSize: 16, color: Colors.black),
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
