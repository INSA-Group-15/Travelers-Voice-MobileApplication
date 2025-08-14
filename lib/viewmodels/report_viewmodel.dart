import '../models/report.dart';

class ReportViewModel {
  final List<Report> _reports = [];

  List<Report> get reports => _reports;

  void addReport(Report report) {
    _reports.add(report);
  }
}
