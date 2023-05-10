
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String email;
  final String uid;

  const UserModel({
    required this.email,
    required this.uid,
  });


  UserModel copyWith({
    String? email,
    String? uid,
  }) {
    return UserModel(
      email: email ?? this.email,
      uid: uid ?? this.uid,
    );
  }

  
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      uid: map['\$id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(email: $email, uid: $uid)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.email == email &&
      other.uid == uid;
  }

  @override
  int get hashCode => email.hashCode ^ uid.hashCode;
}
