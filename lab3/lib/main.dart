import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import './model/exam.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var examNameController = TextEditingController();
  DateTime? examDate;

  final List<Exam> exams = [];

  Future<void> startDatePick(BuildContext context) async {
    final today = DateTime.now();

    final pickedDate = await DatePicker.showDateTimePicker(
      context,
      currentTime: today,
      minTime: today,
      maxTime: today.add(const Duration(days: 100)),
    );

    if (pickedDate != null) {
      setState(() {
        examDate = pickedDate;
      });
    }
  }

  void addExam() {
    final examName = examNameController.value.text;

    if (examName.trim().isEmpty || examDate == null) {
      return;
    }

    setState(() {
      exams.add(Exam(name: examName, dateTime: examDate!.copyWith()));
      examNameController.clear();
      examDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Planner'),
        actions: [
          IconButton(
            onPressed: addExam,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: examNameController,
                      decoration: const InputDecoration(labelText: 'Exam name'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            examDate != null
                                ? DateFormat.yMMMd().add_jm().format(examDate!)
                                : 'No Date Selected',
                            style: const TextStyle(color: Colors.grey)),
                        ElevatedButton(
                            onPressed: () => startDatePick(context),
                            child: const Text('Select Date'))
                      ],
                    )
                  ],
                ),
              ),
            ),
            ...exams
                .map((e) => Card(
                      elevation: 4,
                      child: ListTile(
                          title: Text(e.name),
                          subtitle: Text(
                              DateFormat.yMMMd().add_jm().format(e.dateTime))),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
