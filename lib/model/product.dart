import 'package:flutter/material.dart';

class Product{
  final String title;
  final String description;
  final double price;
  final dynamic image;
  final String type;

  Product({@required this.title, @required this.description, @required this.price, @required this.image, @required this.type});
}