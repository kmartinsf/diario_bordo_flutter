import 'package:diario_bordo_flutter/constants/colors.dart';
import 'package:diario_bordo_flutter/presentation/widgets/journal_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                'Todos os Diários'.toUpperCase(),
                style: TextStyle(fontSize: 14, color: AppColors.grey),
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
