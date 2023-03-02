import 'package:flutter/material.dart';

class ClothesQuestion extends StatelessWidget {
  final String _questionText;

  ClothesQuestion(this._questionText);

  @override
  Widget build(BuildContext context) {
    return Text(
      _questionText,
      style: const TextStyle(color: Colors.blue, fontSize: 30),
    );
  }
}
