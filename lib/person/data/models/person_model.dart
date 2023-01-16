import 'dart:convert';

import 'package:equatable/equatable.dart';

class PersonModel extends Equatable {
  String id;
  String firstName;
  String? lastName;
  String email;
  String phone;
  DateTime dateOfBirth;
  String image;
  String createdAt;
  String? updateAt;

  PersonModel({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.image,
    required this.createdAt,
    this.updateAt,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        email,
        phone,
        dateOfBirth,
        image,
      ];

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'firstName': firstName});
    if (lastName != null) {
      result.addAll({'lastName': lastName});
    }
    result.addAll({'email': email});
    result.addAll({'phone': phone});
    result.addAll({'dateOfBirth': dateOfBirth.millisecondsSinceEpoch});
    result.addAll({'image': image});
    result.addAll({'createdAt': createdAt});
    if (updateAt != null) {
      result.addAll({'updateAt': updateAt});
    }

    return result;
  }

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      image: json['image'],
      createdAt: json['createdAt'],
      updateAt: json['updateAt'],
    );
  }
}
