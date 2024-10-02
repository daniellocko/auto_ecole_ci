import 'package:epik/models/eleve.dart';
import 'package:epik/models/user.dart';

class PostLogin {
  String username;
  String password;

  PostLogin({required this.username, required this.password});

  PostLogin.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        password = json['password'] as String;

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class BackLogin {
  final String code;
  final String message;
  final String token;
  final String refresh;
  final User user;
  final Instructor? instructor;
  final Student? student;

  BackLogin({
    required this.code,
    required this.message,
    required this.token,
    required this.refresh,
    required this.user,
    this.instructor,
    this.student,
  });

  factory BackLogin.fromJson(Map<String, dynamic> json) {
    return BackLogin(
      user: User.fromJson(json['user']),
      instructor: json['instructor'] == null
          ? null
          : Instructor.fromJson(json['instructor']),
      student:
          json['student'] == null ? null : Student.fromJson(json['student']),
      code: json['code'],
      message: json['message'],
      token: json['token'],
      refresh: json['refresh'],
    );
  }
}
