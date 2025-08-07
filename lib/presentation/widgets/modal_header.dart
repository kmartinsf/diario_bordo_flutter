import 'package:diario_bordo_flutter/constants/colors.dart';
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
                color: AppColors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: onCancel,
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: AppColors.primary,
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
