import 'dart:ui';

import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/delete_journal_modal.dart';
import 'package:diario_bordo_flutter/presentation/widgets/travel_journal_modal.dart';
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

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: journal.coverUrl != null
                          ? Image.network(
                              journal.coverUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 48,
                                  height: 48,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    title: Text(
                      journal.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      journal.location,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    trailing: Material(
                      type: MaterialType.transparency,
                      child: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.black.withValues(alpha: 0.5),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: TravelJournalModal(
                                  journal: journal,
                                  onSuccess: onRefresh,
                                ),
                              ),
                            );
                          } else if (value == 'delete') {
                            await deleteConfirmation(
                              context,
                              journalId: journal.id,
                              onDeleteSuccess: onRefresh,
                            );
                          }
                        },

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                        offset: const Offset(-4, -12),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            height: 24,
                            child: Text(
                              'Editar diário',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'delete',
                            height: 24,
                            child: Text(
                              'Excluir diário',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert, size: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
