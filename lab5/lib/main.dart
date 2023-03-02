import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lab5/pages/map_page.dart';
import './pages/user_form.dart';
import './services/local_notice_service.dart';
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

  bool showMap = false;

  final _finkiLatLong = const LatLng(42.00412550642568, 21.409533391068145);

  final notificationService = LocalNoticeService.getService();

  void addExam(String examName, DateTime examDate) {
    if (loggedInUser == null) {
      return;
    }

    notificationService.showNotification('New Exam Added',
        '$examName - ${DateFormat.yMMMd().add_jm().format(examDate)}');

    setState(() {
      exams.add(Exam(
          name: examName,
          dateTime: examDate,
          user: loggedInUser!,
          location: _finkiLatLong));
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
        'New user registered', 'User: $username');

    setState(() {
      users.add(user);
      loggedInUser = user;
    });
  }

  void toggleMap() {
    setState(() {
      showMap = !showMap;
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

  get getMainPage {
    if (loggedInUser == null) {
      return UserForm(
        doLogin: login,
        doRegister: register,
      );
    } else if (showMap) {
      return MapPage(markers: [
        Marker(
          markerId: const MarkerId('1'),
          position: _finkiLatLong,
        )
      ],
      toggleMap: toggleMap,);
    } else {
      return MyHomePage(
        exams: userExams,
        onAddExam: addExam,
        doLogout: logout,
        toggleMap: toggleMap,
      );
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: getMainPage,
    );
  }
}
