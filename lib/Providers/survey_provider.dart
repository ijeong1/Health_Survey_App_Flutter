import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../Models/question.dart';

// ViewModel(Provider)
class SurveyProvider extends ChangeNotifier {
  final SurveyRepository repository;
  SurveyProvider({required this.repository});

  List<Question> _questions = [];
  List<Map<String, dynamic>> _responses = [];
  int _currentIndex = 0;
  String _currentAnswer = '';
  bool _isLoading = false;
  String? _error;

  // getter
  int get currentIndex => _currentIndex;
  List<Question> get questions => _questions;
  List<Map<String, dynamic>> get responses => _responses;
  String get currentAnswer => _currentAnswer;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => repository.token != null;
  bool get isLastQuestion => _currentIndex == _questions.length - 1;
  Question get currentQuestion => _questions[_currentIndex];

  // setter
  set currentIndex(int index){
    _currentIndex = index;
    _updateCurrentAnswer();
    notifyListeners();
  }

  // Initialize - If authentication is successful, load the survey screen.
  Future<void> initialize() async {
    if (isAuthenticated) {
      await loadSurvey();
    }
  }

  // Authenticate
  Future<void> authenticate(String username) async {
    try {
      _startLoading();
      await repository.authenticate(username);
      await loadSurvey();
    } catch (e) {
      _setError('Authentication failed: $e');
    } finally {
      _stopLoading();
    }
  }

  // Load Survey Screen
  Future<void> loadSurvey() async {
    try {
      _startLoading();
      _questions = await repository.getQuestions();
      _responses = await repository.getResponses();
      _currentIndex = await repository.getProgress();
      _updateCurrentAnswer();
    } catch (e) {
      _setError('Failed to load survey: $e');
    } finally {
      _stopLoading();
    }
  }

  // Save Answer
  Future<void> saveAnswer() async {
    try {
      _startLoading();
      await repository.saveResponse(_currentIndex, _currentAnswer);
      _responses = await repository.getResponses();
    } catch (e) {
      _setError('Failed to save answer: $e');
    } finally {
      _stopLoading();
    }
  }

  // To the next Question
  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _updateCurrentAnswer();
      notifyListeners();
    }
  }

  // To the previous Question
  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _updateCurrentAnswer();
      notifyListeners();
    }
  }

  // Set the current answer
  void setCurrentAnswer(String answer) {
    _currentAnswer = answer;
    notifyListeners();
  }

  // Update the current answer
  void _updateCurrentAnswer() {
    final response = _responses.firstWhere(
          (r) => r['question_index'] == _currentIndex,
      orElse: () => {'response': ''},
    );
    _currentAnswer = response['response'];
  }

  // Start Loading
  void _startLoading() {
    _isLoading = true;
    _error = null;
    notifyListeners();
  }

  // Stop Loading
  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  // Show Error
  void _setError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }
}