import 'package:intl/intl.dart';

class UserRegistration {
  final String email;
  final String firstName;
  final String lastName;
  final String telephone;
  final String numPiece;
  final String enrollmentDate;
  final String dateOfBirth;
  final bool isInstructor;
  final bool isStudent;

  // Constructor with named parameters
  UserRegistration({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.telephone,
    required this.numPiece,
    required this.enrollmentDate,
    required this.dateOfBirth,
    this.isInstructor = false,
    this.isStudent = false,
  });

  // Factory constructor to create a new UserRegistration instance from a JSON object
  factory UserRegistration.fromJson(Map<String, dynamic> json) {
    return UserRegistration(
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      telephone: json['telephone'] as String,
      numPiece: json['num_piece'] as String,
      enrollmentDate: DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(json['enrollment_date'] as String)),
      dateOfBirth: DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(json['date_of_birth'] as String)),
      isInstructor: json['is_instructor'] as bool,
      isStudent: json['is_student'] as bool,
    );
  }

  // Method to convert a UserRegistration instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'telephone': telephone,
      'num_piece': numPiece,
      'enrollment_date':
          DateFormat('yyyy-MM-dd').format(DateTime.parse(enrollmentDate)),
      'date_of_birth':
          DateFormat('yyyy-MM-dd').format(DateTime.parse(dateOfBirth)),
      'is_instructor': isInstructor,
      'is_student': isStudent,
    };
  }
}

class BackRegistration {
  final String id;
  final String student;
  final DateTime enrollmentDate;

  // Constructor with named parameters
  BackRegistration({
    required this.id,
    required this.student,
    required this.enrollmentDate,
  });

  // Factory constructor to create a new EnrollmentResponse instance from a JSON object
  factory BackRegistration.fromJson(Map<String, dynamic> json) {
    return BackRegistration(
      id: json['id'] as String,
      student: json['student'] as String,
      enrollmentDate: DateTime.parse(json['enrollment_date'] as String),
    );
  }

  // Method to convert an EnrollmentResponse instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student,
      'enrollment_date': enrollmentDate.toIso8601String(),
    };
  }
}
