import 'package:flutter/material.dart';
import '../models/report_data.dart';

class ReportStep2Screen extends StatefulWidget {
  final ReportData reportData;
  final Function(ReportData) onNext;
  final Function(ReportData) onBack;

  const ReportStep2Screen({
    Key? key,
    required this.reportData,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  State<ReportStep2Screen> createState() => _ReportStep2ScreenState();
}

class _ReportStep2ScreenState extends State<ReportStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _ethiopianCities = [
    'Addis Ababa',
    'Dire Dawa',
    'Mekele',
    'Adama',
    'Bahir Dar',
    'Gondar',
    'Hawassa',
    'Jimma',
    'Harar',
  ];

  final List<String> _categories = [
    'General',
    'Transport',
    'Accommodation',
    'Safety',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    widget.reportData.category ??= _categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        "Location Details",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      _buildDropdown(
                        value: widget.reportData.category,
                        items: _categories,
                        label: "Issue Type",
                        onChanged: (value) {
                          setState(() => widget.reportData.category = value!);
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildDropdown(
                        value: widget.reportData.startCity,
                        items: _ethiopianCities,
                        label: "From",
                        hint: "Select departure city",
                        onChanged: (value) {
                          setState(() => widget.reportData.startCity = value!);
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildDropdown(
                        value: widget.reportData.endCity,
                        items: _ethiopianCities,
                        label: "To",
                        hint: "Select arrival city",
                        onChanged: (value) {
                          setState(() => widget.reportData.endCity = value!);
                        },
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => widget.onBack(widget.reportData),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                                minimumSize: const Size(0, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                "Back",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _goToNextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom > 0
                            ? MediaQuery.of(context).viewInsets.bottom + 20
                            : 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    String? hint,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.1),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: hint != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      hint,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  )
                : null,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            dropdownColor: Colors.blue[800]?.withOpacity(0.95),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            icon: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 28,
              ),
            ),
            borderRadius: BorderRadius.circular(12),
            elevation: 4,
            menuMaxHeight: 300,
            isExpanded: true,
            validator: (value) => value == null ? 'Please select' : null,
          ),
        ),
      ],
    );
  }

  void _goToNextStep() {
    if (_formKey.currentState!.validate()) {
      widget.reportData.date = DateTime.now();
      widget.onNext(widget.reportData);
    }
  }
}
