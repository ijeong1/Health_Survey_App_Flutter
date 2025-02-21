import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/welcome_screen.dart';
import 'Screens/question_screen.dart';
import 'Screens/completion_screen.dart';
import 'Providers/survey_provider.dart';
import 'Services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();
  final repository = SurveyRepository(prefs: prefs, apiService: apiService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => SurveyProvider(repository: repository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Survey',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<SurveyProvider>(
        builder: (context, provider, _) {
          if (provider.isAuthenticated) {
            return const QuestionScreen();
          }
          return const WelcomeScreen();
        },
      ),
      routes: {
        '/survey': (context) => const QuestionScreen(),
        '/complete': (context) => const CompletionScreen(),
      },
    );
  }
}