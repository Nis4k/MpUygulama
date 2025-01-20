class Reservation {
  final int id;
  final int studentId;
  final String date;
  final String time;

  Reservation({
    required this.id,
    required this.studentId,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'date': date,
      'time': time,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'],
      studentId: map['studentId'],
      date: map['date'],
      time: map['time'],
    );
  }
}