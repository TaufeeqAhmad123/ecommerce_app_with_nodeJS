import 'package:ecommerece_app/app/data/constants/app_assets.dart';

class User {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String profilePic;
  final String location;
  final String phoneNumber;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.profilePic ='',
    this.location = '',
    this.phoneNumber = '',
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      profilePic: json['profilePic'] ?? '',
      location: json['location'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
     isVerified: (json['verified'] ?? json['isVerified'] ?? false) == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profilePic': profilePic,
      'location': location,
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
    };
  }
}
User dummyUser = User(
  id: '1',
  name: 'Jhone Arent',
  email: '',
  profilePic: AppAssets.kProfilePic,
  location: 'Brooklyn',
  phoneNumber: '1234567890',

  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  isVerified: false,

);
