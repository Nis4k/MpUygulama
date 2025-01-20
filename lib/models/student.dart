class Student {
  final int? id;
  final String name;
  final String roomNumber;

  Student({
    this.id,
    required this.name,
    required this.roomNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'roomNumber': roomNumber,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      roomNumber: map['roomNumber'],
    );
  }
}
