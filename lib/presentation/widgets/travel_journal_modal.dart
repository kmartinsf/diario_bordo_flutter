import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:diario_bordo_flutter/constants/colors.dart';
import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/custom_snackbar.dart';
import 'package:diario_bordo_flutter/presentation/widgets/image_selector.dart';
import 'package:diario_bordo_flutter/presentation/widgets/modal_header.dart';
import 'package:diario_bordo_flutter/presentation/widgets/travel_form.dart';
import 'package:diario_bordo_flutter/providers/travel_journal_provider.dart';
import 'package:diario_bordo_flutter/utils/image_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  bool _isPickingImage = false;

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    _isPickingImage = true;
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        final originalFile = File(picked.path);
        final compressed = await compressImage(originalFile);
        setState(() => _coverImage = compressed);
      }
    } catch (e) {
      if (mounted) {
        customSnackBar(context, 'Erro ao escolher imagem', isError: true);
      }
    } finally {
      _isPickingImage = false;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final service = ref.read(travelJournalServiceProvider);
    final notifier = ref.read(travelJournalNotifierProvider.notifier);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final isEdit = isEditing;

    try {
      if (isEdit) {
        final updated = TravelJournal(
          id: widget.journal!.id,
          location: _location.text.trim(),
          title: _title.text.trim(),
          description: _description.text.trim(),
          rating: _rating,
          createdAt: widget.journal!.createdAt,
          coverUrl: widget.journal!.coverUrl,
          userId: userId,
        );

        await notifier.updateJournal(updated, newImage: _coverImage);
        if (!mounted) return;
        Navigator.pop(context);
        customSnackBar(context, 'Diário alterado');
      } else {
        await service.createJournal(
          userId: userId,
          location: _location.text.trim(),
          title: _title.text.trim(),
          description: _description.text.trim(),
          rating: _rating,
          imageFile: _coverImage,
        );
        if (!mounted) return;
        Navigator.pop(context);
        customSnackBar(context, 'Diário criado');
      }

      await notifier.refresh();
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
            color: AppColors.white,
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
