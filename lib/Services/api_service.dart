import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/question.dart';

// REST API Service
class ApiService {
  // API URL
  static const String baseUrl = 'https://PUT_YOUR_URL_HERE';

  // Get Authentication Token
  Future<String> getAuthToken(String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/get_auth_token'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_name': username}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body)['token'];
    }
    throw Exception('Failed to authenticate');
  }

  // Get Survey Questions
  Future<List<Question>> getQuestions(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/questions/$token'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.asMap().entries.map((entry) {
        final index = entry.key;
        final questionJson = entry.value;
        return Question.fromJson(questionJson, index);
      }).toList();
    }
    throw Exception('Failed to load questions');
  }

  // Post Save Response
  Future<void> saveResponse(String token, int questionIndex, String answer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/responses/$token'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'question_index': questionIndex,
        'response': answer,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save response');
    }
  }

  // GET the saved Responses
  Future<List<Map<String, dynamic>>> getResponses(String token, String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/responses/$token/$username'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    throw Exception('Failed to load responses');
  }

  Future<int> getProgress(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/progress/$token'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['progress'];
    }
    return 0;
  }
}

// Survey Repository
class SurveyRepository {
  final SharedPreferences prefs;
  final ApiService apiService;
  String? _token;
  String? _username;

  SurveyRepository({required this.prefs, required this.apiService}) {
    _token = prefs.getString('auth_token');
    _username = prefs.getString('username');
  }

  String? get token => _token;
  String? get username => _username;

  Future<void> authenticate(String username) async {
    _token = await apiService.getAuthToken(username);
    _username = username;
    await prefs.setString('auth_token', _token!);
    await prefs.setString('username', username);
  }

  Future<List<Question>> getQuestions() async {
    if (_token == null) throw Exception('Not authenticated');
    return apiService.getQuestions(_token!);
  }

  Future<void> saveResponse(int questionIndex, String answer) async {
    if (_token == null) throw Exception('Not authenticated');
    await apiService.saveResponse(_token!, questionIndex, answer);
  }

  Future<List<Map<String, dynamic>>> getResponses() async {
    if (_token == null || _username == null) throw Exception('Not authenticated');
    return apiService.getResponses(_token!, _username!);
  }

  Future<int> getProgress() async {
    if (_token == null) throw Exception('Not authenticated');
    return apiService.getProgress(_token!);
  }
}