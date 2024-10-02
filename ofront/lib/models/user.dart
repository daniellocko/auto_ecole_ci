import 'package:epik/models/eleve.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String first_name;
  final String last_name;
  final bool is_instructor;
  final bool is_student;

  final Student? student;
  final Instructor? instructor;

  User({
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.is_instructor,
    required this.is_student,
    required this.id,
    required this.username,
    required this.student,
    required this.instructor,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      is_instructor: json['is_instructor'],
      is_student: json['is_student'],
      student: json['student'],
      instructor: json['instructor'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'first_name': first_name,
        'last_name': last_name,
        'is_instructor': is_instructor,
        'is_student': is_student,
        'student': student,
        'instructor': instructor,
      };
}

class RetrieveUser {
  final String username;
  RetrieveUser({required this.username});
}
