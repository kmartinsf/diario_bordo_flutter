import 'package:diario_bordo_flutter/presentation/widgets/custom_button.dart';
import 'package:diario_bordo_flutter/presentation/widgets/custom_input.dart';
import 'package:diario_bordo_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool isLoading = false;

  String? _loginError;
  bool _showPassword = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      _loginError = null;
    });

    try {
      final auth = ref.read(authServiceProvider);
      await auth.login(email: _email.text.trim(), password: _password.text);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loginError = 'Dados incorretos';
        });
      }
      return;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF4E61F6),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38,
            left: 24,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFF383838)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.048,
            right: 0,
            left: 170,
            child: Center(
              child: Image.asset(
                'assets/images/login.png',
                height: media.height * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          ),
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
            top: MediaQuery.of(context).size.height * 0.45,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  32,
                  24,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bem vindo (a) de volta!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      'Preencha com seus dados.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Gap(24),

                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 24),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            CustomInput(
                              hint: 'Email',
                              errorText: _loginError,
                              controller: _email,
                              hasLoginError: _loginError != null,
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
                              obscure: !_showPassword,
                              controller: _password,
                              hasLoginError: _loginError != null,
                              errorText: _loginError,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(
                                  () => _showPassword = !_showPassword,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe a senha';
                                }
                                return null;
                              },
                            ),

                            const Gap(24),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                onPressed: isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4E61F6),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
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
                                        'Entrar',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            const Gap(12),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Esqueci minha senha',
                                style: TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
