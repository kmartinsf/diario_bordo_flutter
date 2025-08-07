import 'package:diario_bordo_flutter/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? errorText;
  final Widget? suffixIcon;
  final bool hasLoginError;

  const CustomInput({
    super.key,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.validator,
    this.errorText,
    this.suffixIcon,
    this.hasLoginError = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: hasLoginError ? AppColors.inputError : AppColors.inputFill,
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        prefix: const Padding(padding: EdgeInsets.only(left: 6)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red, width: 1.5),
        ),
      ),
    );
  }
}
