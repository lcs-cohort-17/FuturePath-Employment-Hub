import 'package:flutter/material.dart';

class UserProfile {
  final String fullName;
  final String idNumber;
  final String email;
  final String phone;

  UserProfile({
    required this.fullName,
    required this.idNumber,
    required this.email,
    required this.phone,
  });
}

class UserProfileProvider extends ChangeNotifier {
  UserProfile? userProfile = UserProfile(
    fullName: 'Keanu Visagie',
    idNumber: '0000000000000',
    email: 'keanu@example.com',
    phone: '0712345678',
  );
}