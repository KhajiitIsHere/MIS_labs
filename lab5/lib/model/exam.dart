import 'package:google_maps_flutter/google_maps_flutter.dart';

import './user.dart';

class Exam {
  final String name;
  final DateTime dateTime;
  final User user;
  final LatLng location;

  Exam({
    required this.name,
    required this.dateTime,
    required this.user,
    required this.location,
  });
}
