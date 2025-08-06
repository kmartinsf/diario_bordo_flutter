import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/details_modal.dart';
import 'package:diario_bordo_flutter/presentation/widgets/journal_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class JournalList extends StatelessWidget {
  final Future<List<TravelJournal>> journalsFuture;
  final Future<void> Function() onRefresh;
  const JournalList({
    super.key,
    required this.onRefresh,
    required this.journalsFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<TravelJournal>>(
        future: journalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar diários'));
          }

          final journals = snapshot.data ?? [];
          if (journals.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum diário criado ainda.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: journals.length,
              separatorBuilder: (_, __) => const Gap(12),
              itemBuilder: (context, index) {
                final journal = journals[index];
                return JournalListTile(
                  journal: journal,
                  onRefresh: onRefresh,
                  onTap: () => detailsModal(context, journal),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
