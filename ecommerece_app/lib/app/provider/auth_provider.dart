import 'dart:convert';
import 'dart:io';

import 'package:ecommerece_app/app/ApiServices/auth_serice.dart';
import 'package:ecommerece_app/app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AuthProvider extends ChangeNotifier {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  User? _user;
  User? get user => _user;
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  String? _token;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  bool _isUserVerified = false;
  String? get error => _error;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;
  bool get isUserVerified => _isUserVerified;
  bool get isLoading => _isLoading;
  File? get profileImage => _profileImage;
  AuthService authService = AuthService();

  Future<void> initAuth() async {
    print('=== INIT AUTH STARTED ===');
    final pref = await SharedPreferences.getInstance();
    final userJson = pref.getString('user');
    final storedToken = pref.getString('token');

    print('Raw userJson from storage: $userJson');
    print('Raw storedToken from storage: $storedToken');

    if (userJson != null && storedToken != null) {
      try {
        final userMap = jsonDecode(userJson);
        print('Decoded user map: $userMap');

        _user = User.fromJson(userMap);
        _token = storedToken;
        _isAuthenticated = true;
        _isUserVerified = _user?.isVerified ?? false;

        print('User loaded: ${_user?.toJson()}');
        print('User isVerified field: ${_user?.isVerified}');
        print('_isUserVerified set to: $_isUserVerified');

        notifyListeners();
      } catch (e) {
        print('Error parsing stored data: $e');
        _error = 'Failed to load user data';
        _clearAuthData();
        notifyListeners();
      }
    } else {
      print('No stored auth data found');
      _clearAuthData();
      notifyListeners();
    }

    print('=== INIT AUTH COMPLETED ===');
    print(
      'Final state - Authenticated: $_isAuthenticated, Verified: $_isUserVerified',
    );
  }

  void _clearAuthData() {
    _user = null;
    _token = null;
    _isAuthenticated = false;
    _isUserVerified = false;
  }

  Future<bool> register(name, email, password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await authService.registerUser(name, email, password);
      print("Response from register: $response");
      if (response['success'] == true) {
        _user = User.fromJson(response['user']);
        _token = response['token'];
        await saveData(_user!, _token!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Registration failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authService.login(email, password);
      print("=== LOGIN RESPONSE ===");
      print("Full response: $response");

      if (response['success'] == true) {
        print("User data from response: ${response['user']}");

        _user = User.fromJson(response['user']);
        _token = response['token'];

        print("Parsed user: ${_user?.toJson()}");
        print("User isVerified: ${_user?.isVerified}");

        await saveData(_user!, _token!);
        _isLoading = false;

        print("After saveData - _isUserVerified: $_isUserVerified");
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      _error = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getUSerProfileData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authService.getUserData(_token!);
      print("=== USER PROFILE RESPONSE ===");
      print("Full response: $response");

      if (response['success'] == true) {
        print("User data from response: ${response['user']}");
        if (response['data'] != null) {
          _user = User.fromJson(response['data']);
        } else {
          print("No user data found in response");
          _user = null;
        }

        _isLoading = false;

        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      _error = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final _pref = await SharedPreferences.getInstance();
      _pref.remove("user");
      _pref.remove("token");
      _user = null;
      _token = null;
      _isAuthenticated = false;

      notifyListeners();
      return true;
    } catch (e) {
      _error = "logot failed";
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendEmailVerificationCode(email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      print("Sending verification code to: $email");
      final response = await authService.sendEmailVerificationCode(email);
      if (response['success'] == true) {
        final code = response['code'];
        print("Verification code sent: $code");
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to send verification code';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Failed to send verification code';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyEmailVerificationCode(email, code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      print("Sending verification code to: $email");
      final response = await authService.verifyEmailVerificationCode(
        email,
        code,
      );
      if (response['success'] == true) {
        final user = response['user'];
        print("Verification code verified for user: ${user['name']}");

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to send verification code';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Failed to send verification code';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> saveData(User user, String token) async {
    print('=== SAVING DATA ===');
    final prefs = await SharedPreferences.getInstance();

    try {
      final userJsonString = jsonEncode(user.toJson());
      print('Saving user JSON: $userJsonString');
      print('Saving token: $token');
      print('User isVerified before saving: ${user.isVerified}');

      await prefs.setString('user', userJsonString);
      await prefs.setString('token', token);

      _user = user;
      _token = token;
      _isAuthenticated = true;
      _isUserVerified = user.isVerified;

      print('Data saved successfully');
      print('_isUserVerified set to: $_isUserVerified');

      // Verify data was saved correctly
      final savedUserJson = prefs.getString('user');
      final savedToken = prefs.getString('token');
      print('Verification - saved user: $savedUserJson');
      print('Verification - saved token: $savedToken');

      notifyListeners();
    } catch (e) {
      print('Error saving data: $e');
      _error = 'Failed to save user data';
      notifyListeners();
    }
  }

  Future<void> pickProfileImage() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null) {
        _profileImage = File(image.path);
        print("Picked image: ${_profileImage!.path}");
        _isLoading = false;

        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to pick image';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadProfileImage()async
{
  try{
      _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await authService.uploadProfileImage(
      _token!,
      _profileImage!,
    );
    print("=== UPLOAD PROFILE IMAGE RESPONSE ===");
    print("Full response: $response");
    if (response['success'] == true) {
      print("Profile image uploaded successfully");
      _user!.profilePic = response['profilePic'];
      await saveData(_user!, _token!);
      _isLoading = false;
      Get.snackbar("Success", "Profile image uploaded successfully");
      notifyListeners();
      return true;
    } else {
      _error = response['message'] ?? 'Failed to upload profile image';
      _isLoading = false;
      notifyListeners();
      return false;
    }

  }catch(e){
    _error = 'Failed to upload image';
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
  // Add this method to check current auth state
  void printCurrentAuthState() {
    print('=== CURRENT AUTH STATE ===');
    print('_isAuthenticated: $_isAuthenticated');
    print('_isUserVerified: $_isUserVerified');
    print('_user: ${_user?.toJson()}');
    print('_token: $_token');
    print('========================');
  }
}
