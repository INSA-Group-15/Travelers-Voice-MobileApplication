import '../models/report.dart';

class ReportData {
  String? title;
  String? description;
  String? category;
  String? fanId;
  String? startCity;
  String? endCity;
  String? receiptImagePath;
  DateTime? date;

  Report toReport() {
    return Report(
      title: title ?? '',
      description: description ?? '',
      category: category ?? 'General',
      startPoint: startCity ?? '',
      endPoint: endCity ?? '',
      receiptImagePath: receiptImagePath,
      date: date ?? DateTime.now(),
      startLatLng: null,
      endLatLng: null,
    );
  }

  // Convert ReportData to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'fanId': fanId,
      'startCity': startCity,
      'endCity': endCity,
      'receiptImagePath': receiptImagePath,
      'date': date?.toIso8601String(),
    };
  }
}
