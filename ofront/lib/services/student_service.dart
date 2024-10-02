import 'dart:convert';
import 'dart:typed_data';
import 'package:epik/env.dart';
import 'package:epik/models/eleve.dart';
import 'package:epik/models/post_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudentService {
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    return token;
  }

  Future<Map<String, String>> getHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String refresh = prefs.getString('refresh')!;

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Student>> getStudents(String? value) async {
    try {
      final headers = await getHeader();

      final url = value == null
          ? Uri.parse('$authBaseUrl/search?type=student')
          : Uri.parse('$authBaseUrl/search?type=student&name=$value');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((json) {
          return Student.fromJson(json);
        }).toList();
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<BackRegistration> createStudent(UserRegistration input) async {
    try {
      final headers = await getHeader();

      final url = Uri.parse('$authBaseUrl/enrollment');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(input.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        BackRegistration enrollment = BackRegistration.fromJson(jsonResponse);
        return enrollment;
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('ERROR $e');
      // Catching general exceptions to log or handle other errors
      throw Exception('Failed to load data: $e');
    }
  }

  // Create Instructor Account
  Future<Instructor> createInsctructor(Instructor input) async {
    try {
      //final token = await getToken();
      final url = Uri.parse('$authBaseUrl/instructor');
      final request = http.MultipartRequest('POST', url);

      //request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      if (input.logo != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'logo',
            input.logo!,
            filename: 'IMAGE.PNG',
          ),
        );
      }

      request.fields['name'] = input.name!;
      request.fields['email'] = input.email!;
      request.fields['first_name'] = input.firstName!;
      request.fields['last_name'] = input.lastName!;
      request.fields['telephone'] = input.telephone!;
      request.fields['password'] = input.password!;
      request.fields['password2'] = input.password!;
      request.fields['capp'] = input.capp!;
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        Instructor instructor = Instructor.fromJson(jsonResponse);
        return instructor;
      } else {
        throw Exception(
            'Failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('ERROR $e');
      // Catching general exceptions to log or handle other errors
      throw Exception('Failed to push data: $e');
    }
  }

  //
  Future<Instructor> updateInsctructor(Instructor input) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$authBaseUrl/update_instructor');
      final request = http.MultipartRequest('POST', url);

      request.files.add(
        http.MultipartFile.fromBytes(
          'logo',
          input.logo!,
          filename: 'IMAGE.PNG',
        ),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['id'] = input.id!;
      request.fields['name'] = input.name!;
      request.fields['email'] = input.email!;
      request.fields['first_name'] = input.firstName!;
      request.fields['last_name'] = input.lastName!;
      request.fields['telephone'] = input.telephone!;

      request.fields['password'] = '';
      request.fields['password2'] = '';
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        Instructor instructor = Instructor.fromJson(jsonResponse);
        return instructor;
      } else {
        throw Exception(
            'Failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('ERROR $e');
      // Catching general exceptions to log or handle other errors
      throw Exception('Failed to push data: $e');
    }
  }

  Future<Uint8List?> urlToUint8List(String imageUrl) async {
    try {
      // Fetch the image from the URL
      final http.Response response = await http.get(Uri.parse(imageUrl));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Convert the response body to Uint8List
        return response.bodyBytes;
      } else {
        print('Error: Unable to load image');
        return null;
      }
    } catch (e) {
      print('Exception caught: $e');
      return null;
    }
  }
}
