import 'package:flutter/material.dart';
import 'package:helloworld/widgets/clothesAnswer.dart';
import 'package:helloworld/widgets/clothesQuestion.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _questions = [
    {
      'question': 'What color shoes do you wear',
      'answers': [
        'Red',
        'Green',
        'Black',
      ]
    },
    {
      'question': 'How do you like your jeans',
      'answers': [
        'Regular fit',
        'Loose',
        'Baggy',
        'Slim fit',
      ]
    },
    {
      'question': 'What kind of hats do you wear',
      'answers': [
        'Baseball Cap',
        'Beanie',
        'Bowler Hat',
        'Bonnet',
        'Bucket hat',
      ]
    },
  ];

  var _questionIdx = 0;

  void _onAnswerSelect(String answer) {
    if (_questionIdx == _questions.length - 1){
      setState(() {
        _questionIdx = 0;
      });
      return;
    }
    setState(() {
      _questionIdx += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello world',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('196048 Filip Shijakov'),
          ),
          body: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClothesQuestion(_questions[_questionIdx]['question'] as String),
                ...(_questions[_questionIdx]['answers'] as List<String>).map(
                    (answer) => ClothesAnswer(
                        answerText: answer,
                        answerHandler: () => _onAnswerSelect(answer))),
              ],
            ),
          )),
    );
  }
}
