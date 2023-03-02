import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClothesAnswer extends StatelessWidget {
  final String _answerText;
  final void Function() _answerHandler;

  ClothesAnswer({
    required answerText,
    required answerHandler,
  })  : _answerHandler = answerHandler,
        _answerText = answerText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.red),
          backgroundColor: MaterialStateProperty.all(Colors.green),
        ),
        onPressed: _answerHandler,
        child: Text(_answerText),
      ),
    );
  }
}
