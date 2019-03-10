import 'package:flutter/material.dart';

class User {
  final String email;
  final String password;
  final bool isAdmin;
  final List cart = [];

  User({@required this.email, @required this.password, this.isAdmin = false});
}
