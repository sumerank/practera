import 'dart:convert';

import 'package:mbansw/http/AuthService.dart';

import '../configs/config.dart';
import 'package:http/http.dart' as http;

class StatisticsService {
  final String baseUrl = Config.baseUrl;
  String token = AuthService.token;

  Future<Map<String, dynamic>> getDonorNumber() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/donor_number"),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Map<String, dynamic> donations = jsonDecode(response.body);
        return donations;
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<Map<String, dynamic>> getDonorType() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/donor_type"),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Map<String, dynamic> donations = jsonDecode(response.body);
        return donations;
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<Map<String, dynamic>> getRecurringDonorType() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/recurring_type"),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Map<String, dynamic> donations = jsonDecode(response.body);
        return donations;
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<List<dynamic>> getRegistrationData() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/registration_count"),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        List<dynamic> donations = jsonDecode(response.body);
        return donations;
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<List<dynamic>> getLoginData() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/login_count"),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        List<dynamic> donations = jsonDecode(response.body);
        return donations;
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<bool> sendMail(email, name, donationAmount, donationType, date) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/mail"),
        headers: {
          'Content-Type': "application/json",
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          {
            "name": name,
            "email": email,
            "amount": donationAmount,
            "type": donationType,
            "date": date,
          },
        ),
      );
      if (response.statusCode == 200) {
        // List<dynamic> donations = jsonDecode(response.body);
        return true;
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to send email');
    }
  }
}
