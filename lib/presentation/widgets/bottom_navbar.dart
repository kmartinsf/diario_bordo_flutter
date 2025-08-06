import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onRefresh;

  const HomeBottomNavBar({
    super.key,
    required this.onAdd,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: onRefresh,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.menu_book, color: Color(0xFF4E61F6)),
                  SizedBox(height: 4),
                  Text(
                    'Diários',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4E61F6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFEEF0FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Color(0xFF4E61F6)),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person_outline, color: Colors.grey),
                  SizedBox(height: 4),
                  Text(
                    'Perfil',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4E61F6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
