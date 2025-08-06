import 'dart:io';

import 'package:flutter/material.dart';

class CoverImageSection extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onPickImage;

  const CoverImageSection({
    required this.imageFile,
    required this.imageUrl,
    required this.onPickImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: imageFile != null
              ? Image.file(imageFile!, fit: BoxFit.cover)
              : imageUrl != null
              ? Image.network(imageUrl!, fit: BoxFit.cover)
              : const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFB7C5FF), Color(0xFFFFFFFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
        ),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: onPickImage,
              icon: const Icon(
                Icons.photo_camera_outlined,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Escolher uma foto de capa',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E61F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
