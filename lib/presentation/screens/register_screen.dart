import 'dart:developer';

import 'package:diario_bordo_flutter/providers/auth_providers.dart';
import 'package:diario_bordo_flutter/presentation/widgets/input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool isLoading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final auth = ref.read(authServiceProvider);
      await auth.register(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      );

      if (mounted) {
        log('Conta criada com sucesso!');
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = _handleFirebaseError(e);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String _handleFirebaseError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Este e-mail já está em uso.';
        case 'invalid-email':
          return 'O e-mail informado é inválido.';
        case 'weak-password':
          return 'A senha precisa ter pelo menos 6 caracteres.';
        case 'operation-not-allowed':
          return 'Cadastro com e-mail/senha está desativado.';
        default:
          return 'Erro inesperado. Tente novamente mais tarde';
      }
    }

    return 'Erro desconhecido: ${e.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final topHeight = media.height * 0.4;
    final formTopHeight = media.height * 0.33;

    return Scaffold(
      backgroundColor: const Color(0xFF4E61F6),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topHeight,
              child: Stack(
                children: [
                  Positioned(
                    top: 56,
                    left: 24,
                    child: SvgPicture.asset(
                      'assets/images/rumo.svg',
                      width: 115,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Positioned(
                    top: topHeight * 0.63,
                    left: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Color(0xFF383838),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -150,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.asset(
                        'assets/images/register.png',
                        height: media.height * 0.52,
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: formTopHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(8),
                        const Text(
                          'Preencha os dados abaixo para criar sua conta.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const Gap(24),
                        CustomInput(
                          hint: 'Nome',
                          controller: _name,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Informe seu nome'
                              : null,
                        ),
                        const Gap(16),
                        CustomInput(
                          hint: 'E-mail',
                          controller: _email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe o e-mail';
                            }
                            final emailRegex = RegExp(
                              r'^[\w\.-]+@[\w\.-]+\.\w+$',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'E-mail inválido';
                            }
                            return null;
                          },
                        ),
                        const Gap(16),
                        CustomInput(
                          hint: 'Senha',
                          obscure: true,
                          controller: _password,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'A senha deve ter pelo menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const Gap(16),
                        CustomInput(
                          hint: 'Confirmar senha',
                          obscure: true,
                          controller: _confirmPassword,
                          validator: (value) => value != _password.text
                              ? 'As senhas não coincidem'
                              : null,
                        ),
                        const Gap(24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4E61F6),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Criar conta',
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
            ),
          ],
        ),
      ),
    );
  }
}
