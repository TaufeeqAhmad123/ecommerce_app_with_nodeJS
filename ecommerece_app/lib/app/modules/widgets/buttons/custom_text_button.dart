import 'package:ecommerece_app/app/data/constants/app_colors.dart';
import 'package:ecommerece_app/app/data/constants/app_typography.dart';
import 'package:flutter/material.dart';


class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final double? fontSize;
  const CustomTextButton({
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTypography.kMedium14.copyWith(
          color: color ?? AppColors.kError,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
