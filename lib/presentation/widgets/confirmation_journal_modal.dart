import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'custom_button.dart';

Future<void> confirmationModal({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmText,
  required String cancelText,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  Color confirmTextColor = const Color(0xFFFF0000),
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ConfirmationModal(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmTextColor: confirmTextColor,
    ),
  );
}

class ConfirmationModal extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmTextColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationModal({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
    this.confirmTextColor = const Color(0xFFFF0000),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Gap(8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              message,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const Gap(30),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: () {
                Navigator.pop(context);
                if (onCancel != null) onCancel!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E61F6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                cancelText,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Gap(12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              style: TextButton.styleFrom(
                foregroundColor: confirmTextColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                confirmText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
