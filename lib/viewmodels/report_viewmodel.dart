import 'package:traveler_voice/models/report.dart'; // Ensure this matches your folder name
import 'package:traveler_voice/models/report_data.dart';

class ReportViewModel {
  final List<Report> _reports = [];
  ReportData _currentReportData = ReportData();

  List<Report> get reports => List.unmodifiable(_reports);

  // Getter for the current report data (useful for multi-step forms)
  ReportData get currentReportData => _currentReportData;

  // Update methods for each step
  void updateBasicInfo(
      {required String title,
      required String description,
      required String fanId}) {
    _currentReportData.title = title;
    _currentReportData.description = description;
    _currentReportData.fanId = fanId;
  }

  void updateLocationAndCategory({
    required String category,
    required String startCity,
    required String endCity,
  }) {
    _currentReportData.category = category;
    _currentReportData.startCity = startCity;
    _currentReportData.endCity = endCity;
    _currentReportData.date =
        DateTime.now(); // Set the report time when locations are selected
  }

  void updateAttachment(String? receiptImagePath) {
    _currentReportData.receiptImagePath = receiptImagePath;
  }

  void submitReport() {
    if (_validateReportData()) {
      _reports.add(_currentReportData.toReport());
      _currentReportData = ReportData(); // Reset for next report
    }
  }

  bool _validateReportData() {
    return _currentReportData.title != null &&
        _currentReportData.title!.isNotEmpty &&
        _currentReportData.description != null &&
        _currentReportData.description!.isNotEmpty &&
        _currentReportData.fanId != null &&
        _currentReportData.fanId!.isNotEmpty &&
        _currentReportData.category != null &&
        _currentReportData.startCity != null &&
        _currentReportData.endCity != null;
  }

  // Clear the current report data (useful if user cancels)
  void clearCurrentReport() {
    _currentReportData = ReportData();
  }
}
