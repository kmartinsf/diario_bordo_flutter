import 'dart:ui';

import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/bottom_navbar.dart';
import 'package:diario_bordo_flutter/presentation/widgets/journal_list.dart';
import 'package:diario_bordo_flutter/presentation/widgets/travel_journal_modal.dart';
import 'package:diario_bordo_flutter/providers/travel_journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<TravelJournal>> _journalsFuture;

  @override
  void initState() {
    super.initState();
    _journalsFuture = ref.read(travelJournalRepositoryProvider).fetchJournals();
  }

  Future<void> _refresh() async {
    final future = ref.read(travelJournalRepositoryProvider).fetchJournals();
    if (!mounted) return;
    setState(() {
      _journalsFuture = future;
    });
  }

  void _openNewJournalModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: TravelJournalModal(onSuccess: _refresh),
      ),
    );

    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Meus diários',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const Gap(24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'TODOS OS DIÁRIOS',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const Gap(16),
            JournalList(journalsFuture: _journalsFuture, onRefresh: _refresh),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        onAdd: _openNewJournalModal,
        onRefresh: _refresh,
      ),
    );
  }
}
