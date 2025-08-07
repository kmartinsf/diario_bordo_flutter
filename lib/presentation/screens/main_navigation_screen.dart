import 'dart:ui';

import 'package:diario_bordo_flutter/presentation/screens/home_screen.dart';
import 'package:diario_bordo_flutter/presentation/screens/profile_screen.dart';
import 'package:diario_bordo_flutter/presentation/widgets/travel_journal_modal.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  final _pages = [const HomeScreen(), const ProfileScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openNewJournalModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(50),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: TravelJournalModal(
          onSuccess: () {
            if (_selectedIndex != 0) {
              setState(() => _selectedIndex = 0);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => _onItemTapped(0),
                child: SizedBox(
                  height: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book,
                        color: _selectedIndex == 0
                            ? const Color(0xFF4E61F6)
                            : Colors.grey,
                      ),
                      const Gap(4),
                      Text(
                        'Diários',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 0
                              ? const Color(0xFF4E61F6)
                              : const Color(0x8A000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: GestureDetector(
                  onTap: _openNewJournalModal,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEF0FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Color(0xFF4E61F6)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _onItemTapped(1),
                child: SizedBox(
                  height: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: _selectedIndex == 1
                            ? const Color(0xFF4E61F6)
                            : Colors.grey,
                      ),
                      const Gap(4),
                      Text(
                        'Perfil',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == 1
                              ? const Color(0xFF4E61F6)
                              : const Color(0x8A000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
