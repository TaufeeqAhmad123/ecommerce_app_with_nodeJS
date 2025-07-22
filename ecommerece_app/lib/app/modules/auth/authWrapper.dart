import 'package:ecommerece_app/app/modules/auth/otp_view.dart';
import 'package:ecommerece_app/app/modules/auth/signin_view.dart';
import 'package:ecommerece_app/app/modules/landingPage/landing_page.dart';
import 'package:ecommerece_app/app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<void> _authFuture;

  @override
  void initState() {
    super.initState();
    _authFuture =
        Provider.of<AuthProvider>(context, listen: false).initAuth();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return FutureBuilder(
      future:_authFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ⬇️ Main logic based on auth & verification
        if (authProvider.isAuthenticated) {
         return authProvider.isUserVerified
            ? const LandingPage()
            : OtpView(userEmail: authProvider.user?.email);
        } else {
          return const SignInView();
        }
      },
    );
  }
}


