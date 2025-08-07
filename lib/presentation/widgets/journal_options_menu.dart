import 'dart:ui';

import 'package:diario_bordo_flutter/constants/colors.dart';
import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/confirmation_journal_modal.dart';
import 'package:diario_bordo_flutter/presentation/widgets/custom_snackbar.dart';
import 'package:diario_bordo_flutter/presentation/widgets/travel_journal_modal.dart';
import 'package:diario_bordo_flutter/providers/travel_journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JournalOptionsMenu extends ConsumerWidget {
  final TravelJournal journal;
  final VoidCallback onRefresh;

  const JournalOptionsMenu({
    super.key,
    required this.journal,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              backgroundColor: AppColors.transparent,
              barrierColor: AppColors.blackAlpha50,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            await confirmationModal(
              context: context,
              title: 'Excluir diário',
              message:
                  'Todas as informações registradas nele serão perdidas de forma definitiva.',
              confirmText: 'Excluir diário',
              cancelText: 'Cancelar',
              confirmTextColor: AppColors.red,
              onConfirm: () async {
                await ref
                    .read(travelJournalNotifierProvider.notifier)
                    .deleteJournal(journal.id);
                onRefresh();
                if (context.mounted) {
                  customSnackBar(context, 'Diário removido');
                }
              },
            );
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            height: 24,
            child: Text(
              'Editar diário',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
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
                color: AppColors.red,
              ),
            ),
          ),
        ],
        icon: const Icon(Icons.more_vert, size: 20),
      ),
    );
  }
}
