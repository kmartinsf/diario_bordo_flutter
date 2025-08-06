import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/journal_options_menu.dart';
import 'package:flutter/material.dart';

class JournalListTile extends StatelessWidget {
  final TravelJournal journal;
  final VoidCallback onRefresh;
  final VoidCallback onTap;

  const JournalListTile({
    super.key,
    required this.journal,
    required this.onRefresh,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
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
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 48,
                    height: 48,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                )
              : Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
        ),
        title: Text(
          journal.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          journal.location,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        trailing: JournalOptionsMenu(journal: journal, onRefresh: onRefresh),
      ),
    );
  }
}
