
import 'package:ecommerece_app/app/modules/landingPage/landing_page.dart';
import 'package:ecommerece_app/app/provider/auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecommerece_app/app/data/constants/constants.dart';
import 'package:ecommerece_app/app/modules/auth/components/components.dart';
import 'package:ecommerece_app/app/modules/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

class OtpView extends StatelessWidget {
  final String? userEmail;
  const OtpView({super.key, this.userEmail});

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> _otpControllers = List.generate(
      4,
      (_) => TextEditingController(),
    );
    final provider = Provider.of<AuthProvider>(context, listen: false);
    void verifyCode(String code) async {
   
      if (code.length == 4) {
        bool isVerified = await provider.verifyEmailVerificationCode(
          userEmail,
          code,
        );

        if (isVerified) {
          Get.offAll(() => const LandingPage());
        } else {
          Get.snackbar(
            'Error',
            'Invalid verification code. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color.fromARGB(
              255,
              74,
              13,
              195,
            ).withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Please enter a valid 4-digit code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }

    return Scaffold(
      appBar: const AuthAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          children: [
            Text('Enter OTP', style: AppTypography.kBold24),
            SizedBox(height: AppSpacing.fiveVertical),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: RichText(
                text: TextSpan(
                  text: 'We have just sent you 4 digit code via your email ',
                  style: AppTypography.kMedium14.copyWith(
                    color: AppColors.kGrey60,
                  ),
                  children: [
                    TextSpan(
                      text: userEmail ?? 'your email',
                      style: AppTypography.kMedium14.copyWith(
                        color: AppColors.kGrey100,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.thirtyVertical),
            CustomOTPTextField(
              handleControllers: (controllers) {
                _otpControllers = controllers
                    .whereType<TextEditingController>()
                    .toList();
              },
              onOTPInput: (value) {
                verifyCode(value); // use the value directly
              },
            ),

            SizedBox(height: 40.h),
            PrimaryButton(
              onTap: () {
              //  String otp = _otpControllers.map((controller) => controller.text).join();
               // verifyCode(otp);
               Get.offAll(() => const LandingPage());
      
              },
              text: 'Continue',
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            RichText(
              text: TextSpan(
                text: 'Didn’t receive code? ',
                style: AppTypography.kSemiBold16.copyWith(
                  color: AppColors.kGrey60,
                ),
                children: [
                  TextSpan(
                    text: 'Resend Code',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await provider.sendEmailVerificationCode(userEmail);
                        Get.snackbar(
                          'Success',
                          'Verification code sent successfully.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                      },
                    style: AppTypography.kSemiBold16.copyWith(
                      color: AppColors.kPrimary,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
