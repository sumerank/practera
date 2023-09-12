import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;

import 'AuthService.dart';

class DonationService {
  String baseUrl = AuthService().baseUrl;
  String token = AuthService.token;
  int? userID = AuthService.authUser['id'];
  Map<dynamic, dynamic> donations = {};

  Future<bool> donate(String amount, bool recurring, String? interval) async {
    try {
      // amount = (double.parse(amount) / 100).toString();
      amount = (double.parse(amount)).toString();

      final response = await http.post(
        Uri.parse("$baseUrl/donate"),
        headers: {
          'Content-Type': "application/json",
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "user_id": userID,
          "amount": amount,
          "recurring": recurring,
          "interval": interval
        }),
      );

      print("Status code ${response.statusCode}");

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("SSSS");
      print(e.toString());
      return false;
    }
  }

  Future<List> getDonations() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/donations"),
          headers: {'Authorization': 'Bearer $token'});
      print("Status Code ${response.statusCode}");
      if (response.statusCode == 200) {
        List donations = jsonDecode(response.body) as List;
        print(donations);
        return donations;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
