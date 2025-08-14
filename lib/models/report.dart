import 'package:google_maps_flutter/google_maps_flutter.dart';

class Report {
  final String title;
  final String description;
  final String? receiptImagePath;
  final String startPoint;
  final String endPoint;
  final DateTime date;
  final String category;
  final LatLng? startLatLng;
  final LatLng? endLatLng;

  Report({
    required this.title,
    required this.description,
    this.receiptImagePath,
    required this.startPoint,
    required this.endPoint,
    required this.date,
    required this.category,
    this.startLatLng,
    this.endLatLng,
  });
}
