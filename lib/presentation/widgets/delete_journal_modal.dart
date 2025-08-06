import 'package:diario_bordo_flutter/presentation/widgets/custom_button.dart';
import 'package:diario_bordo_flutter/presentation/widgets/snackbar.dart';
import 'package:diario_bordo_flutter/providers/travel_journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

Future<void> deleteConfirmation(
  BuildContext context, {
  required String journalId,
  required VoidCallback onDeleteSuccess,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DeleteJournalModal(
      journalId: journalId,
      onDeleteSuccess: onDeleteSuccess,
    ),
  );
}

class _DeleteJournalModal extends ConsumerWidget {
  final String journalId;
  final VoidCallback onDeleteSuccess;

  const _DeleteJournalModal({
    required this.journalId,
    required this.onDeleteSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Excluir diário',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Gap(8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Todas as informações registradas nele serão perdidas de forma definitiva.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const Gap(30),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E61F6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          const Gap(12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(travelJournalRepositoryProvider)
                      .deleteJournal(journalId);
                  onDeleteSuccess();
                  if (context.mounted) {
                    Navigator.pop(context);
                    customSnackBar(context, 'Diário removido');
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    customSnackBar(context, 'Algo deu errado', isError: true);
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Excluir diário',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
