import 'dart:convert';
import 'package:epik/env.dart';
import 'package:epik/models/login.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$authBaseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // login
  Future<BackLogin> logIn(PostLogin input) async {
    try {
      final url = Uri.parse('$authBaseUrl/login');
      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode(input.toJson()),
      );

      if (response.statusCode == 200) {
        // Successful response
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Ensure jsonResponse has the expected structure
        if (jsonResponse.containsKey('token') &&
            jsonResponse.containsKey('user')) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', jsonResponse['token']);
          prefs.setString('refresh', jsonResponse['refresh']);

          BackLogin data = BackLogin.fromJson(jsonResponse);
          return data;
        } else {
          throw Exception('Unexpected response format: $jsonResponse');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Incorrect credentials.');
      } else if (response.statusCode == 404) {
        throw Exception('Not found: The endpoint may be incorrect.');
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Catching general exceptions to log or handle other errors
      throw Exception('Failed to load data: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
