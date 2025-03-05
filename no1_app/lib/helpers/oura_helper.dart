// lib/helpers/oura_helper.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:no1_app/database/db_helper.dart';
import 'package:no1_app/database/user_info_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class OuraHelper {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final UserInfoHelper _userInfoHelper = UserInfoHelper();

  // Validate the format of the Access Token
  bool isAccessTokenFormatValid(String token) {
    if (token.isEmpty) {
      return false;
    }
    if (token.length != 32) {
      return false;
    }
    final regex = RegExp(r'^[A-Z0-9]+$');
    return regex.hasMatch(token);
  }

  // Validate the Access Token with Oura API
  Future<bool> validateOuraToken(String token) async {
    final url = Uri.parse('https://api.ouraring.com/v2/usercollection/personal_info');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Token is valid");
      return true;
    } else {
      print("Token is invalid");
      return false;
    }
  }

  // Save the Access Token securely
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: 'oura_access_token', value: token);
    print("Access Token saved securely");
  }

  // Pull data from Oura API
  Future<void> pullOuraData() async {
    // Get the Access Token from secure storage
    String? token = await _secureStorage.read(key: 'oura_access_token');
    if (token == null) {
      print("Access Token not found");
      return;
    }

    // Get the last pull date from user_info
    String startDate = await _userInfoHelper.getOuraPullDate();
    String endDate = DateTime.now().toIso8601String().split('T').first;

    List<String> endpoints = [
      "daily_activity",
      "daily_readiness",
      "daily_resilience",
      "daily_sleep",
      "daily_spo2",
      "daily_stress",
      "sleep",
      "sleep_time",
    ];

    for (String endpoint in endpoints) {
      await fetchAndSaveOuraData(token, startDate, endDate, endpoint);
    }

    // Update the ouraPullDate in user_info
    await _userInfoHelper.updateOuraPullDate(endDate);
    print("Oura data pulled and saved successfully");
  }

  // Helper function to fetch and save data for a specific endpoint
  Future<void> fetchAndSaveOuraData(String token, String startDate, String endDate, String endpoint) async {
    final url = Uri.parse('https://api.ouraring.com/v2/usercollection/$endpoint').replace(queryParameters: {
      'start_date': startDate,
      'end_date': endDate,
    });

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> dataList = data['data'] ?? [];
      // Save data to the database
      await saveOuraData(dataList);
    } else {
      print("Error fetching data from $endpoint: ${response.statusCode}");
    }
  }

  // Save the pulled data in the oura table
  Future<void> saveOuraData(List<dynamic> dataList) async {
    final db = await DBHelper().database;

    for (var data in dataList) {
      String date = data['day'] ?? data['summary_date'] ?? data['timestamp'] ?? '';

      // Convert data to JSON string
      String jsonData = jsonEncode(data);

      // Insert into the database
      await db.insert(
        'oura',
        {
          'date': date,
          'data': jsonData,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
