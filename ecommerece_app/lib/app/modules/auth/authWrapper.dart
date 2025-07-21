import 'package:ecommerece_app/app/modules/auth/otp_view.dart';
import 'package:ecommerece_app/app/modules/auth/signin_view.dart';
import 'package:ecommerece_app/app/modules/home/home_view.dart';
import 'package:ecommerece_app/app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.initAuth(); // Check if user is already logged in
    } catch (error) {
      print('Auth check error: $error');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Use Consumer to listen to authentication changes
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          return SignInView();
        }
        if (!authProvider.isUserVerified) {
        return  OtpView();
        }
        return HomeView();
      },
    );
  }
}

/* Removed custom CircularProgressIndicator class to use Flutter's built-in widget */
