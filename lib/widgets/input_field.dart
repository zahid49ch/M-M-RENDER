import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const InputField({
    super.key,
    required this.placeholder,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: placeholder,
          filled: true,
          fillColor: const Color(0xFF98353F),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
