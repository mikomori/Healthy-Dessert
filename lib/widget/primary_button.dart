import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  PrimaryButton(this.title, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.pink,
      padding: EdgeInsets.symmetric(vertical: 10),
      onPressed: onPressed,
      textColor: Colors.white,
      // borderSide: BorderSide(color: Colors.pink, width: 2),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
      ),
    );
  }
}
