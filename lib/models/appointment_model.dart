class AppointmentModel {
  final String id;
  final String patientName;
  final String slot;
  // final String age;
  // final String issue;
  final String status;
  final String type; // Online or Offline
  final String date;
  final double rating;

  AppointmentModel({
    required this.id,
    required this.patientName,
    required this.slot,
    // required this.age,
    // required this.issue,
    required this.status,
    required this.type,
    required this.date,
    this.rating = 0.0,
  });

  factory AppointmentModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AppointmentModel(
      id: id,
      patientName: data['userName'] ?? 'Unknown Patient',
      slot: data['date'] ?? '',
      status: data['status'] ?? 'Pending',
      type: (data['paymentMethod'] == 'Pay Online') ? 'Online' : 'Offline',
      date: data['date'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  AppointmentModel copyWith({
    String? patientName,
    String? date,
    String? slot,
    String? status,
    String? type,
    double? rating,
  }) {
    return AppointmentModel(
      id: id,
      patientName: patientName ?? this.patientName,
      slot: slot ?? this.slot,
      status: status ?? this.status,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
}
