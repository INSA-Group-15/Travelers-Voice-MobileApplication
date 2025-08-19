class Report {
  final String? id; // Add this
  final String title;
  final String description;
  final String category;
  final String startPoint;
  final String endPoint;
  final String? receiptImagePath;
  final DateTime date;
  final dynamic startLatLng;
  final dynamic endLatLng;
  final String status; // Add this

  Report({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startPoint,
    required this.endPoint,
    this.receiptImagePath,
    required this.date,
    this.startLatLng,
    this.endLatLng,
    this.status = 'Pending', // Default status
  });

  // Add this copyWith method
  Report copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? startPoint,
    String? endPoint,
    String? receiptImagePath,
    DateTime? date,
    dynamic startLatLng,
    dynamic endLatLng,
    String? status,
  }) {
    return Report(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      date: date ?? this.date,
      startLatLng: startLatLng ?? this.startLatLng,
      endLatLng: endLatLng ?? this.endLatLng,
      status: status ?? this.status,
    );
  }

  // Update fromJson to include new fields
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      startPoint: json['startPoint'],
      endPoint: json['endPoint'],
      receiptImagePath: json['receiptImagePath'],
      date: DateTime.parse(json['date']),
      startLatLng: json['startLatLng'],
      endLatLng: json['endLatLng'],
      status: json['status'] ?? 'Pending',
    );
  }

  // Update toJson to include new fields
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'receiptImagePath': receiptImagePath,
      'date': date.toIso8601String(),
      'startLatLng': startLatLng,
      'endLatLng': endLatLng,
      'status': status,
    };
  }
}
