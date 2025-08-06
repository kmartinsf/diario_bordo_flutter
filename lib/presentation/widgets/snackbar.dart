import 'package:flutter/material.dart';

void customSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final icon = isError ? Icons.error : Icons.check_circle;
  final iconColor = isError ? Color(0xFFFF0000) : Color(0xFF01E17B);

  final messenger = ScaffoldMessenger.of(context);

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color(0xFF2E3336),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 26),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    content: Builder(
      builder: (ctx) => Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => messenger.hideCurrentSnackBar(),
            child: Icon(Icons.close, size: 18, color: iconColor),
          ),
        ],
      ),
    ),
  );

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
