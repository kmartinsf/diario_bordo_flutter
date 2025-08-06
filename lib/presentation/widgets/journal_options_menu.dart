import 'dart:ui';

import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/delete_journal_modal.dart';
import 'package:diario_bordo_flutter/presentation/widgets/travel_journal_modal.dart';
import 'package:flutter/material.dart';

class JournalOptionsMenu extends StatelessWidget {
  final TravelJournal journal;
  final VoidCallback onRefresh;

  const JournalOptionsMenu({
    super.key,
    required this.journal,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
        offset: const Offset(-4, -12),
        onSelected: (value) async {
          if (value == 'edit') {
            await showModalBottomSheet(
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
                child: TravelJournalModal(journal: journal, onSuccess: onRefresh),
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
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            height: 24,
            child: Text(
              'Editar diário',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'delete',
            height: 24,
            child: Text(
              'Excluir diário',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red),
            ),
          ),
        ],
        icon: const Icon(Icons.more_vert, size: 20),
      ),
    );
  }
}