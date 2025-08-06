import 'dart:ui';

import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/new_travel_journal_modal.dart';
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
    setState(() {
      _journalsFuture = ref
          .read(travelJournalRepositoryProvider)
          .fetchJournals();
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
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: const NewTravelJournalModal(),
        );
      },
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            Expanded(
              child: FutureBuilder<List<TravelJournal>>(
                future: _journalsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar diários'),
                    );
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
                    onRefresh: _refresh,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Material(
                              type: MaterialType.transparency,
                              child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                  } else if (value == 'delete') {}
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: _refresh,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.menu_book, color: Color(0xFF4E61F6)),
                    SizedBox(height: 4),
                    Text(
                      'Diários',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4E61F6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _openNewJournalModal,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEF0FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Color(0xFF4E61F6)),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_outline, color: Colors.grey),
                    SizedBox(height: 4),
                    Text(
                      'Perfil',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
