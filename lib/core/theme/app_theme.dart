import 'package:flutter/material.dart';

/// Design tokens lifted directly from futurepath_full_app_v2.html
/// Keep this as the single source of truth for colors/spacing across
/// all Staff (and other) screens so everything matches the design file.
class AppColors {
  static const brand = Color(0xFFE03A2F); // --brand
  static const brandDim = Color(0xFF6B1A16); // --brand-dim
  static const brandLow = Color(0x1FE03A2F); // --brand-low (12% opacity)

  static const surf = Color(0xFF111111); // --surf
  static const surf2 = Color(0xFF1A1A1A); // --surf2
  static const surf3 = Color(0xFF242424); // --surf3
  static const surf4 = Color(0xFF2E2E2E); // --surf4

  static const bdr = Color(0x14FFFFFF); // --bdr (8% white)
  static const bdr2 = Color(0x24FFFFFF); // --bdr2 (14% white)

  static const t1 = Color(0xFFF0EDE8); // --t1 primary text
  static const t2 = Color(0xFF9E9B96); // --t2 secondary text
  static const t3 = Color(0xFF5C5A57); // --t3 tertiary text

  static const green = Color(0xFF2ECC8A);
  static const greenLow = Color(0x1F2ECC8A);

  static const amber = Color(0xFFF5A623);
  static const amberLow = Color(0x1FF5A623);

  static const blue = Color(0xFF4A9EE8);
  static const blueLow = Color(0x1F4A9EE8);

  static const redLow = Color(0x1FE03A2F);
}

class AppRadii {
  static const card = 14.0;
  static const cardSm = 12.0;
  static const input = 10.0;
  static const pill = 20.0;
  static const tag = 5.0;
}

/// Status badge styles, matching .bopen / .bpend / .bsusp in the design.
class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;

  const StatusBadge({super.key, required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    switch (type) {
      case StatusType.active:
        bg = AppColors.greenLow;
        fg = AppColors.green;
        break;
      case StatusType.pending:
        bg = AppColors.amberLow;
        fg = AppColors.amber;
        break;
      case StatusType.suspended:
        bg = AppColors.redLow;
        fg = AppColors.brand;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

enum StatusType { active, pending, suspended }

/// Primary button — matches .pbtn
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.input),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.2,
          ),
        )
            : Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Secondary / outline button — matches .sbtn
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SecondaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.bdr2),
          padding: const EdgeInsets.symmetric(vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.input),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.t2,
          ),
        ),
      ),
    );
  }
}

/// Text input field — matches .inp / .ilbl
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.t2),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 12, color: AppColors.t1),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.t3, fontSize: 12),
            filled: true,
            fillColor: AppColors.surf2,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.input),
              borderSide: const BorderSide(color: AppColors.bdr2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.input),
              borderSide: const BorderSide(color: AppColors.bdr2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.input),
              borderSide: const BorderSide(color: AppColors.brand),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.input),
              borderSide: const BorderSide(color: AppColors.brand),
            ),
          ),
        ),
      ],
    );
  }
}
