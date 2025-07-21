import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerece_app/app/data/constants/constants.dart';

class CustomOTPTextField extends StatelessWidget {

  final HandleControllers? handleControllers;
  final Function(String) onOTPInput;
  const CustomOTPTextField({required this.onOTPInput, super.key, this.handleControllers});

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      handleControllers: handleControllers,
      borderColor: AppColors.kPrimary1,
      focusedBorderColor: AppColors.kPrimary,
      disabledBorderColor: Colors.transparent,
      enabledBorderColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      showFieldAsBox: true,
      borderWidth: 2.w,
      filled: true,
      fillColor: const Color.fromARGB(255, 225, 223, 223),
      fieldWidth: 66.w,
      styles: [
        AppTypography.kSemiBold24,
        AppTypography.kSemiBold24,
        AppTypography.kSemiBold24,
        AppTypography.kSemiBold24,
      
      ],
      onSubmit: onOTPInput,
    );
  }
}
