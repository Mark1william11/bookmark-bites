import 'package:bookmark_bites/src/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordTextField extends HookWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
  });

  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use a hook to manage the state of password visibility
    final isObscured = useState(true);

    return TextFormField(
      controller: controller,
      obscureText: isObscured.value,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured.value ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textLight,
          ),
          onPressed: () {
            isObscured.value = !isObscured.value;
          },
        ),
      ),
    );
  }
}