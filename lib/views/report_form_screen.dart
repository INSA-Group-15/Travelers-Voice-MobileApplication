import 'package:flutter/material.dart';
import '../models/report_data.dart';
import '../models/report.dart';
import 'report_step1_screen.dart';
import 'report_step2_screen.dart';
import 'report_step3_screen.dart';

class ReportFormScreen extends StatefulWidget {
  final Function(Report)? onSubmit;

  const ReportFormScreen({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final ReportData _reportData = ReportData();
  int _currentStep = 0;

  List<Widget> _buildSteps() => [
        ReportStep1Screen(
          reportData: _reportData,
          onNext: (data) => setState(() => _currentStep = 1),
        ),
        ReportStep2Screen(
          reportData: _reportData,
          onNext: (data) => setState(() => _currentStep = 2),
          onBack: (data) => setState(() => _currentStep = 0),
        ),
        ReportStep3Screen(
          reportData: _reportData,
          onSubmit: (data) {
            if (widget.onSubmit != null) {
              widget.onSubmit!(data.toReport() as Report);
            }
            Navigator.of(context).pop();
          },
          onBack: (data) => setState(() => _currentStep = 1),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: _buildSteps()[_currentStep],
      ),
    );
  }
}
