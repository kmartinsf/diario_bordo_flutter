import 'package:diario_bordo_flutter/presentation/widgets/details_modal.dart';
import 'package:diario_bordo_flutter/presentation/widgets/journal_list_tile.dart';
import 'package:diario_bordo_flutter/providers/travel_journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class JournalList extends ConsumerWidget {
  const JournalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalsAsync = ref.watch(travelJournalNotifierProvider);

    return Expanded(
      child: journalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Erro ao carregar diários')),
        data: (journals) {
          if (journals.isEmpty) {
            return const Center(child: Text('Nenhum diário criado ainda.'));
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(travelJournalNotifierProvider.notifier).refresh(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: journals.length,
              separatorBuilder: (_, __) => const Gap(12),
              itemBuilder: (context, index) {
                final journal = journals[index];
                return JournalListTile(
                  journal: journal,
                  onRefresh: () => ref
                      .read(travelJournalNotifierProvider.notifier)
                      .refresh(),
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
