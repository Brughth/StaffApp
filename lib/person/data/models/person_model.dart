import 'dart:io';

import 'package:equatable/equatable.dart';

class PersonModel extends Equatable {
  String firstName;
  String lastName;
  String email;
  String phone;
  DateTime dateOfBirth;
  File image;

  PersonModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.image,
  });

  @override
  List<Object?> get props => [];
}
