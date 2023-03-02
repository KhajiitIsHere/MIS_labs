import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/appointment_data_source.dart';
import '../model/exam.dart';

class MyHomePage extends StatefulWidget {
  final List<Exam> exams;
  final void Function(String, DateTime) onAddExam;
  final void Function() doLogout;
  final void Function() toggleMap;

  MyHomePage({
    Key? key,
    required this.exams,
    required this.onAddExam,
    required this.doLogout,
    required this.toggleMap,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final examNameController = TextEditingController();
  DateTime? examDate;

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

    widget.onAddExam(examName, examDate!.copyWith());

    setState(() {
      examNameController.clear();
      examDate = null;
    });
  }

  get appointments {
    final appointments = widget.exams
        .map((e) => Appointment(
            startTime: e.dateTime,
            subject: e.name,
            endTime: e.dateTime.add(Duration(hours: 1))))
        .toList();

    return AppointmentDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Planner'),
        actions: [
          TextButton(
              onPressed: widget.doLogout,
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              )),
          IconButton(onPressed: widget.toggleMap, icon: const Icon(Icons.map)),
          IconButton(
            onPressed: addExam,
            icon: const Icon(Icons.add),
          ),
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
            Card(
              elevation: 4,
              child: SfCalendar(
                view: CalendarView.schedule,
                dataSource: appointments,
                minDate: DateTime.now(),
              ),
            ),
            ...widget.exams
                .map((e) => Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text(e.name),
                        subtitle: Text(
                            DateFormat.yMMMd().add_jm().format(e.dateTime)),
                        trailing: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          child: const Text('FINKI', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
