import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab3/pages/user_form.dart';
import 'package:lab3/services/local_notice_service.dart';
import './pages/home_page.dart';
import 'model/exam.dart';
import 'model/user.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Exam> exams = [];
  final List<User> users = [];
  User? loggedInUser;

  final notificationService = LocalNoticeService.getService();

  void addExam(String examName, DateTime examDate) {
    if (loggedInUser == null) {
      return;
    }

    notificationService.showNotification(
      'New Exam Added',
      '$examName - ${DateFormat.yMMMd().add_jm().format(examDate)}'
    );

    setState(() {
      exams.add(Exam(name: examName, dateTime: examDate, user: loggedInUser!));
    });
  }

  void login(String username, String password) {
    for (User user in users) {
      if (user.username == username && user.password == password) {
        setState(() {
          loggedInUser = user;
        });
        break;
      }
    }
  }

  void logout() {
    setState(() {
      loggedInUser = null;
    });
  }

  void register(String username, String password) {
    if (users.any((user) => user.username == username)) {
      return;
    }

    final user = User(username, password);

    notificationService.showNotification(
      'New user registered',
      'User: $username'
    );

    setState(() {
      users.add(user);
      loggedInUser = user;
    });
  }

  get userExams {
    if (loggedInUser == null) {
      return [];
    }

    return exams
        .where((exam) => exam.user.username == loggedInUser!.username)
        .toList();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loggedInUser == null
          ? UserForm(
              doLogin: login,
              doRegister: register,
            )
          : MyHomePage(
              exams: userExams,
              onAddExam: addExam,
              doLogout: logout,
            ),
    );
  }
}
