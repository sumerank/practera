import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mbansw/configs/config.dart';

class AuthService {
  final String baseUrl = Config.baseUrl;
  static String token = "";

  static var authUser = {};

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          'Content-Type': "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        token = jsonDecode(response.body)['token'];
        authUser = jsonDecode(response.body)['user'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/logout"), headers: {
        'Content-Type': "application/json",
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        token = "";
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(
    String firstName,
    String lastName,
    String email,
    String confirmEmail,
    String contactNumber,
    String country,
    String state,
    String city,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {
          'Content-Type': "application/json",
          'Accept': "application/json",
        },
        body: jsonEncode(
          {
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "email_confirmation": confirmEmail,
            "contactNumber": contactNumber,
            "country": country,
            "state": state,
            "city": city,
            "password": password,
            "password_confirmation": confirmPassword,
          },
        ),
      );
      if (response.statusCode == 200) {
        token = jsonDecode(response.body)['token'];
        authUser = jsonDecode(response.body)['user'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {                                       
    if (token.isEmpty) {
      return false;
    }
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/is_logged_in"),
        headers: {
          'Accept': "application/json",
          'Authorization': 'Bearer $token'
        },
      );   
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
