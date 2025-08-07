import 'dart:io';

import 'package:diario_bordo_flutter/constants/colors.dart';
import 'package:diario_bordo_flutter/presentation/widgets/custom_button.dart';
import 'package:diario_bordo_flutter/presentation/widgets/custom_input_with_icon.dart';
import 'package:diario_bordo_flutter/presentation/widgets/custom_snackbar.dart';
import 'package:diario_bordo_flutter/presentation/widgets/rating_selector.dart';
import 'package:diario_bordo_flutter/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class TravelForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController locationController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final bool isLoading;
  final bool isEditing;
  final VoidCallback onSubmit;
  final VoidCallback onPickImage;
  final File? coverImage;
  final String? coverUrl;

  const TravelForm({
    super.key,
    required this.formKey,
    required this.locationController,
    required this.titleController,
    required this.descriptionController,
    required this.rating,
    required this.onRatingChanged,
    required this.isLoading,
    required this.isEditing,
    required this.onSubmit,
    required this.onPickImage,
    required this.coverImage,
    required this.coverUrl,
  });

  @override
  ConsumerState<TravelForm> createState() => _TravelFormState();
}

class _TravelFormState extends ConsumerState<TravelForm> {
  List<String> _suggestions = [];

  void _searchLocation(String query) async {
    if (query.isEmpty) return;
    try {
      final results = await ref
          .read(locationServiceProvider)
          .searchCities(query);
      if (mounted) setState(() => _suggestions = results);
    } catch (_) {
      if (mounted) {
        customSnackBar(context, 'Erro ao buscar localização', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          CustomInputWithIcon(
            controller: widget.locationController,
            hintText: 'Localização',
            icon: Icons.location_on_outlined,
            onChanged: _searchLocation,
          ),
          if (_suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackAlpha10,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: _suggestions
                    .map(
                      (s) => ListTile(
                        title: Text(s),
                        onTap: () {
                          setState(() {
                            widget.locationController.text = s;
                            _suggestions.clear();
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          const Gap(16),
          CustomInputWithIcon(
            controller: widget.titleController,
            hintText: 'Nome da sua viagem',
            icon: Icons.local_offer_outlined,
            validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
          ),
          const Gap(16),
          CustomInputWithIcon(
            controller: widget.descriptionController,
            hintText: 'Resumo da sua viagem',
            icon: Icons.notes,
            maxLines: 4,
            maxCharacterLength: 200,
            validator: (v) =>
                v == null || v.isEmpty ? 'Informe o resumo' : null,
          ),
          const Gap(16),
          RatingSelector(
            rating: widget.rating,
            onChanged: widget.onRatingChanged,
          ),

          const Gap(24),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: widget.isLoading ? null : widget.onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.white),
                    )
                  : Text(
                      widget.isEditing ? 'Salvar mudanças' : 'Salvar diário',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
