import 'package:lab3/model/user.dart';

class Exam {
  final String name;
  final DateTime dateTime;
  final User user;

  Exam({
    required this.name,
    required this.dateTime,
    required this.user,
  });
}
