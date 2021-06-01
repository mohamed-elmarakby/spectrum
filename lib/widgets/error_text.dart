import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'This Field needs to be filled',
      style: TextStyle(
        color: Colors.red,
        fontSize: 14,
      ),
    );
  }
}
