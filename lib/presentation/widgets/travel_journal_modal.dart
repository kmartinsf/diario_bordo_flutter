import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/image_selector.dart';
import 'package:diario_bordo_flutter/presentation/widgets/modal_header.dart';
import 'package:diario_bordo_flutter/presentation/widgets/snackbar.dart';
import 'package:diario_bordo_flutter/presentation/widgets/travel_form.dart';
import 'package:diario_bordo_flutter/providers/travel_journal_provider.dart';
import 'package:diario_bordo_flutter/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class TravelJournalModal extends ConsumerStatefulWidget {
  final TravelJournal? journal;
  final VoidCallback onSuccess;

  const TravelJournalModal({super.key, this.journal, required this.onSuccess});

  @override
  ConsumerState<TravelJournalModal> createState() => _TravelJournalModalState();
}

class _TravelJournalModalState extends ConsumerState<TravelJournalModal> {
  final _formKey = GlobalKey<FormState>();
  final _location = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();

  double _rating = 0;
  File? _coverImage;
  bool _isLoading = false;
  Timer? _debounceTimer;

  bool get isEditing => widget.journal != null;

  @override
  void initState() {
    super.initState();

    final journal = widget.journal;
    if (journal != null) {
      _location.text = journal.location;
      _title.text = journal.title;
      _description.text = journal.description;
      _rating = journal.rating;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final originalFile = File(picked.path);
      final compressed = await compressImage(originalFile);
      setState(() => _coverImage = compressed);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final repository = ref.read(travelJournalRepositoryProvider);
    final isEdit = isEditing;
    final journal = TravelJournal(
      id: isEdit ? widget.journal!.id : '',
      location: _location.text.trim(),
      title: _title.text.trim(),
      description: _description.text.trim(),
      rating: _rating,
      createdAt: isEdit ? widget.journal!.createdAt : Timestamp.now(),
      coverUrl: isEdit ? widget.journal!.coverUrl : null,
    );

    try {
      if (isEdit) {
        await repository.updateJournal(journal, newImage: _coverImage);
        if (!mounted) return;
        Navigator.pop(context);
        customSnackBar(context, 'Diário alterado');
      } else {
        await repository.addJournal(journal, imageFile: _coverImage);
        if (!mounted) return;
        Navigator.pop(context);
      }
      widget.onSuccess();
    } catch (_) {
      if (mounted) customSnackBar(context, 'Algo deu errado', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _location.dispose();
    _title.dispose();
    _description.dispose();
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
                ModalHeader(
                  title: isEditing ? 'Editar diário' : 'Novo diário',
                  onCancel: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CoverImageSection(
                        imageFile: _coverImage,
                        imageUrl: widget.journal?.coverUrl,
                        onPickImage: _pickImage,
                      ),
                      Positioned(
                        top: 120,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 80),
                          child: TravelForm(
                            formKey: _formKey,
                            locationController: _location,
                            titleController: _title,
                            descriptionController: _description,
                            isLoading: _isLoading,
                            isEditing: isEditing,
                            onSubmit: _submit,
                            onPickImage: _pickImage,
                            coverImage: _coverImage,
                            coverUrl: widget.journal?.coverUrl,
                            rating: _rating,
                            onRatingChanged: (value) =>
                                setState(() => _rating = value),
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
