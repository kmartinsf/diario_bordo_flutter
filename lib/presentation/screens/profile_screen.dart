import 'dart:io';

import 'package:diario_bordo_flutter/data/models/user_model.dart';
import 'package:diario_bordo_flutter/presentation/widgets/confirmation_journal_modal.dart';
import 'package:diario_bordo_flutter/presentation/widgets/custom_button.dart';
import 'package:diario_bordo_flutter/presentation/widgets/custom_snackbar.dart';
import 'package:diario_bordo_flutter/providers/auth_provider.dart';
import 'package:diario_bordo_flutter/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  File? _selectedImage;
  bool _isSaving = false;
  bool _isInitialized = false;

  void _showLogoutModal(BuildContext context) {
    confirmationModal(
      context: context,
      title: 'Sair da conta',
      message: 'Tem certeza que deseja sair?',
      confirmText: 'Sair da minha conta',
      cancelText: 'Permanecer na minha conta',
      confirmTextColor: Colors.red,
      onConfirm: () async {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (_selectedImage == null) return null;

    final ref = FirebaseStorage.instance
        .ref()
        .child('users')
        .child('$userId.jpg');

    await ref.putFile(_selectedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _saveChanges(UserModel currentUser) async {
    setState(() => _isSaving = true);
    final repo = ref.read(authRepositoryProvider);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final photoUrl = await _uploadImage(userId);
      final updatedUser = currentUser.copyWith(
        name: _nameController.text.trim(),
        city: _cityController.text.trim(),
        photoUrl: photoUrl ?? currentUser.photoUrl,
      );

      await repo.updateUser(userId, updatedUser);
      ref.invalidate(userProvider);

      if (mounted) {
        customSnackBar(context, 'Perfil atualizado com sucesso!');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar alterações'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(''), centerTitle: false),
      body: userAsync.maybeWhen(
        data: (user) {
          if (!_isInitialized) {
            _nameController.text = user.name;
            _cityController.text = user.city ?? '';
            _isInitialized = true;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                )
                              : user.photoUrl != null
                              ? Image.network(
                                  user.photoUrl!,
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person, size: 32),
                        ),
                        const Gap(12),
                        const Text('Toque para alterar a foto'),
                      ],
                    ),
                  ),
                ),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Nome',
                    ),
                  ),
                ),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Cidade',
                    ),
                  ),
                ),

                CustomButton(
                  onPressed: _isSaving ? null : () => _saveChanges(user),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E61F6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : const Text(
                          'Salvar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const Gap(12),
                CustomButton(
                  onPressed: () => _showLogoutModal(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4E61F6),
                    side: const BorderSide(color: Color(0xFF4E61F6)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Sair',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

}
