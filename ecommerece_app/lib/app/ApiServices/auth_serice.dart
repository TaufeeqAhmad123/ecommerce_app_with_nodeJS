import 'dart:convert';
import 'dart:io';
import 'package:ecommerece_app/app/data/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class AuthService {
  
  // screenRedirect(User user){
  //   if(user!=null){
  //     if(user.isVerified){
  //       Get.offAll(() => const HomeView());
  //     }else {
  //       Get.offAll(() => OtpView(userEmail: user.email));

  //     }
  //   }
  //   // else{
  //   //   final pref=SharedPreferences.getInstance();
  //   //   pref.setBool("isFirtTime",true);
  //   //   pref.getString("isFirtTime",true)
  //   // }

  // }
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
      var body = {'email': email, 'providedCode': code};
      print("the body: $body");


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
  Future<Map<String, dynamic>> getUserData(String token) async {
    try {
    


      var response = await http.get(
        Uri.parse(getUserDataUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
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
  Future<Map<String, dynamic>> uploadProfileImage(String token, File image) async {
    try {
        final mimeType = lookupMimeType(image.path)?.split('/');
    final mediaType = mimeType != null && mimeType.length == 2
        ? MediaType(mimeType[0], mimeType[1])
        : MediaType('image', 'jpeg'); // fallback
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(uploadprofilreImageURL),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('profile', image.path, contentType: mediaType));

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = await response.stream.bytesToString();
        print("🔎 Status Code: ${response.statusCode}");
        print("🔎 Raw Response: $data");

        return jsonDecode(data);
      } else {
        var data = await response.stream.bytesToString();
        if (kDebugMode) {
          print("Error: $data");
        }

        Map<String, dynamic> decodedData = {};
        try {
          decodedData = jsonDecode(data);
        } catch (e) {
          // If decoding fails, leave decodedData empty
        }

        return {
          'success': false,
          'message':
              decodedData['message'] ?? 'Error with uploading profile image',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

      
  
}
