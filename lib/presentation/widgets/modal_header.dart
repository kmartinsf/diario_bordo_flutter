import 'package:flutter/material.dart';

class ModalHeader extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;

  const ModalHeader({super.key, required this.title, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: onCancel,
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Color(0xFF4E61F6),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
