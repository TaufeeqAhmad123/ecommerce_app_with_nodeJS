import 'dart:convert';

import 'package:ecommerece_app/app/data/constants/constants.dart';
import 'package:ecommerece_app/app/models/user_model.dart';
import 'package:ecommerece_app/app/modules/auth/otp_view.dart';
import 'package:ecommerece_app/app/modules/home/home_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  screenRedirect(User user){
    if(user!=null){
      if(user.isVerified){
        Get.offAll(() => const HomeView());
      }else {
        Get.offAll(() => OtpView(userEmail: user.email));

      }
    }
    // else{
    //   final pref=SharedPreferences.getInstance();
    //   pref.setBool("isFirtTime",true);
    //   pref.getString("isFirtTime",true)
    // }

  }
  Future<Map<String, dynamic>> registerUser(name, email, password) async {
    try {
      var body = {'name': name, 'email': email, 'password': password};

      var response = await http.post(
        Uri.parse(registerationUrl),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.body;
        print("Response: $data");
        return jsonDecode(data);
      } else {
        var data = jsonDecode(response.body);
        print("Error: ${data['message']}");

        return {
          'success': false,
          'message': data['message'] ?? 'response.statusCode',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }
  Future<Map<String, dynamic>> login( email, password) async {
    try {
      var body = { 'email': email, 'password': password};

      var response = await http.post(
        Uri.parse(loginUrl),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.body;
        print("Response: $data");
        return jsonDecode(data);
      } else {
        var data = jsonDecode(response.body);
        print("Error: ${data['message']}");

        return {
          'success': false,
          'message': data['message'] ?? 'response.statusCode',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> sendEmailVerificationCode(email) async {
    try {
      var body = {'email': email};

      var response = await http.patch(
        Uri.parse(sendEmailVerificationCodeUrl),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.body;
        print("🔎 Status Code: ${response.statusCode}");
        print("🔎 Raw Response: ${response.body}");

        return jsonDecode(data);
      } else {
        var data = jsonDecode(response.body);
        print("Error: ${data['message']}");

        return {
          'success': false,
          'message':
              data['message'] ?? 'Error with sending email verification code',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> verifyEmailVerificationCode(email, code) async {
    try {
      var body = {'email': email, 'code': code};

      var response = await http.patch(
        Uri.parse(verifyEmailVerificationCodeUrl),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.body;
        print("🔎 Status Code: ${response.statusCode}");
        print("🔎 Raw Response: ${response.body}");

        return jsonDecode(data);
      } else {
        var data = jsonDecode(response.body);
        print("Error: ${data['message']}");

        return {
          'success': false,
          'message':
              data['message'] ?? 'Error with sending email verification code',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }
}
