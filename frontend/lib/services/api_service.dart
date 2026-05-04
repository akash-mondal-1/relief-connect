import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

const String _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);

const Duration _requestTimeout = Duration(seconds: 10);

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class Need {
  final String id;
  final String title;
  final String location;
  final String category;
  final int urgency;
  final String description;

  Need({
    required this.id,
    required this.title,
    required this.location,
    required this.category,
    required this.urgency,
    required this.description,
  });

  factory Need.fromJson(Map<String, dynamic> json) {
    return Need(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      urgency: (json['urgency'] as num?)?.toInt() ?? 1,
      description: json['description'] ?? '',
    );
  }
}

class MatchResult {
  final Need need;
  final String reason;
  final int score;

  MatchResult({
    required this.need,
    required this.reason,
    required this.score,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      need: Need.fromJson(json),
      reason: json['reason'] ?? '',
      score: json['score'] ?? 0,
    );
  }
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  static bool _redirecting = false;
  factory ApiService() => _instance;
  ApiService._internal();

  final _client = http.Client();

  Future<http.Response> _withTimeout(Future<http.Response> request) async {
    try {
      return await request.timeout(_requestTimeout);
    } on TimeoutException {
      throw const ApiException('Request timed out. Check your connection.');
    }
  }

  ApiException _error(String msg) => ApiException(msg);

  void _handle401() {
    if (_redirecting) return;
    _redirecting = true;

    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('jwt_token');
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      VolunteerApp.navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthGate()),
        (route) => false,
      );
    });
  }

  Future<void> login(String email, String password) async {
    final response = await _withTimeout(
      _client.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ),
    );

    if (response.statusCode != 200) {
      throw _error('Login failed');
    }

    final data = jsonDecode(response.body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', data['access_token']);
  }

  Future<void> signup(String email, String password) async {
    final response = await _withTimeout(
      _client.post(
        Uri.parse('$_baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ),
    );

    if (response.statusCode != 200) {
      throw _error('Signup failed');
    }

    final data = jsonDecode(response.body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', data['access_token']);
  }

  Future<Need> postNeed({
    required String title,
    required String location,
    required String category,
    required int urgency,
    required String description,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await _withTimeout(
      _client.post(
        Uri.parse('$_baseUrl/needs'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'location': location,
          'category': category,
          'urgency': urgency,
          'description': description,
        }),
      ),
    );

    if (response.statusCode == 401) {
      _handle401();
      throw const ApiException('Please login again');
    }

    if (response.statusCode != 201) {
      throw _error('Failed to post need');
    }

    return Need.fromJson(jsonDecode(response.body));
  }

  Future<List<Need>> getNeeds() async {
    final response = await _withTimeout(
      _client.get(Uri.parse('$_baseUrl/needs')),
    );

    if (response.statusCode != 200) {
      throw _error('Failed to load needs');
    }

    final list = jsonDecode(response.body) as List;
    return list.map((e) => Need.fromJson(e)).toList();
  }

  Future<List<MatchResult>> matchNeeds(String skills) async {
    final response = await _withTimeout(
      _client.get(Uri.parse('$_baseUrl/match?skills=$skills')),
    );

    if (response.statusCode != 200) {
      throw _error('Match failed');
    }

    final list = jsonDecode(response.body) as List;
    return list.map((e) => MatchResult.fromJson(e)).toList();
  }

  Future<List<Need>> getMyNeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await _withTimeout(
      _client.get(
        Uri.parse('$_baseUrl/my-needs'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 401) {
      _handle401();
      throw const ApiException('Please login again');
    }

    if (response.statusCode != 200) {
      throw _error('Failed to load my needs');
    }

    final list = jsonDecode(response.body) as List;
    return list.map((e) => Need.fromJson(e)).toList();
  }

  Future<Need> updateNeed(String id, {
    required String title,
    required String location,
    required String category,
    required int urgency,
    required String description,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await _withTimeout(
      _client.put(
        Uri.parse('$_baseUrl/needs/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'location': location,
          'category': category,
          'urgency': urgency,
          'description': description,
        }),
      ),
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      await prefs.remove('jwt_token');
      throw const ApiException('Session expired or permission denied');
    }

    if (response.statusCode != 200) {
      throw _error('Failed to update need');
    }

    return Need.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteNeed(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await _withTimeout(
      _client.delete(
        Uri.parse('$_baseUrl/needs/$id'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      await prefs.remove('jwt_token');
      throw const ApiException('Session expired or permission denied');
    }

    if (response.statusCode != 204) {
      throw _error('Failed to delete need');
    }
  }
}