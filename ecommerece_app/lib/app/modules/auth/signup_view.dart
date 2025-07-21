import 'package:ecommerece_app/app/provider/auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecommerece_app/app/data/constants/constants.dart';
import 'package:ecommerece_app/app/modules/auth/components/components.dart';
import 'package:ecommerece_app/app/modules/auth/otp_view.dart';
import 'package:ecommerece_app/app/modules/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AuthProvider>(context, listen: false);

      final success = await provider.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success) {
        final email = _emailController.text.trim();
        print( "Email for verification: $email");
        final otp =await provider.sendEmailVerificationCode(email);
        if (otp) {
          Get.to<Widget>(() =>  OtpView(userEmail: email,));
        } else {
          Get.snackbar(
            'Error',
            'Failed to send verification code please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      }
    } else {
      Get.snackbar(
        'Error',
        'Please fill in all fields correctly.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Text('Create Account', style: AppTypography.kBold24),
                SizedBox(height: AppSpacing.fiveVertical),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur',
                  style: AppTypography.kMedium14.copyWith(
                    color: AppColors.kGrey60,
                  ),
                ),
                SizedBox(height: AppSpacing.thirtyVertical),
                // FullName.
                AuthField(
                  title: 'Full Name',
                  hintText: 'Enter your name',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.fifteenVertical),
                // Email Field.
                AuthField(
                  title: 'E-mail',
                  hintText: 'Enter your email address',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!value.isEmail) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.fifteenVertical),
                // Password Field.
                AuthField(
                  title: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 8) {
                      return 'Password should be at least 8 characters long';
                    }
                    return null;
                  },
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: AppSpacing.thirtyVertical),
                PrimaryButton(
                  onTap: () {
                    _register();
                  },
                  text: 'Create An Account',
                ),
                SizedBox(height: AppSpacing.thirtyVertical),
                const TextWithDivider(),
                SizedBox(height: AppSpacing.twentyVertical),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomSocialButton(onTap: () {}, icon: AppAssets.kGoogle),
                    CustomSocialButton(onTap: () {}, icon: AppAssets.kApple),
                    CustomSocialButton(onTap: () {}, icon: AppAssets.kFacebook),
                  ],
                ),
                SizedBox(height: AppSpacing.twentyVertical),
                const AgreeTermsTextCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
