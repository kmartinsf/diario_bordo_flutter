import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/custom_input_with_icon.dart';
import 'package:diario_bordo_flutter/providers/location_provider.dart';
import 'package:diario_bordo_flutter/providers/travel_journal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class NewTravelJournalModal extends ConsumerStatefulWidget {
  const NewTravelJournalModal({super.key});

  @override
  ConsumerState<NewTravelJournalModal> createState() =>
      _NewTravelJournalModalState();
}

class _NewTravelJournalModalState extends ConsumerState<NewTravelJournalModal> {
  final _formKey = GlobalKey<FormState>();
  final _location = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  double _rating = 0;
  File? _coverImage;
  bool _isLoading = false;
  List<String> _suggestions = [];
  Timer? _debounceTimer;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _coverImage = File(picked.path));
    }
  }

  Future<void> _createJournal() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final journal = TravelJournal(
      id: '',
      location: _location.text.trim(),
      title: _title.text.trim(),
      description: _description.text.trim(),
      rating: _rating,
      createdAt: Timestamp.now(),
      coverUrl: null,
    );

    try {
      await ref
          .read(travelJournalRepositoryProvider)
          .addJournal(journal, imageFile: _coverImage);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao criar diário'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _searchLocation(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      if (query.isEmpty) return;
      try {
        final results = await ref
            .read(locationServiceProvider)
            .searchCities(query);
        if (mounted) setState(() => _suggestions = results);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao buscar localização'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.8,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Material(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Novo diário',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Color(0xFF4E61F6),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: _coverImage != null
                            ? Image.file(_coverImage!, fit: BoxFit.cover)
                            : const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFB7C5FF),
                                      Color(0xFFFFFFFF),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        top: 40,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(
                              Icons.photo_camera_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              'Escolher uma foto de capa',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4E61F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 120,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 80),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomInputWithIcon(
                                  controller: _location,
                                  hintText: 'Localização',
                                  icon: Icons.location_on_outlined,
                                  onChanged: _searchLocation,
                                ),
                                if (_suggestions.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      children: _suggestions.map((s) {
                                        return ListTile(
                                          title: Text(s),
                                          onTap: () {
                                            setState(() {
                                              _location.text = s;
                                              _suggestions.clear();
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                const Gap(16),
                                CustomInputWithIcon(
                                  controller: _title,
                                  hintText: 'Nome da sua viagem',
                                  icon: Icons.local_offer_outlined,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Informe o nome'
                                      : null,
                                ),
                                const Gap(16),
                                CustomInputWithIcon(
                                  controller: _description,
                                  hintText: 'Resumo da sua viagem',
                                  icon: Icons.notes,
                                  maxLines: 4,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Informe o resumo'
                                      : null,
                                ),
                                const Gap(16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F4F4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Nota para a viagem',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 12),
                                      Center(
                                        child: RatingBar.builder(
                                          initialRating: _rating,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 32,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 2.0,
                                              ),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                          onRatingUpdate: (rating) {
                                            setState(() => _rating = rating);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _createJournal,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4E61F6),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                              Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Salvar diário',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
