import 'package:diario_bordo_flutter/presentation/widgets/journal_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Gap(32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Meus diários',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Gap(24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'TODOS OS DIÁRIOS',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Gap(16),
            JournalList(),
          ],
        ),
      ),
    );
  }
}
