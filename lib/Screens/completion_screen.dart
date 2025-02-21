import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/survey_provider.dart';

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SurveyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Complete'),
        actions: [
          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Thank you for completing the survey!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: provider.questions.length,
                itemBuilder: (context, index) {
                  final question = provider.questions[index];
                  final response = provider.responses.firstWhere(
                        (r) => r['question_index'] == index,
                    orElse: () => {'response': 'No answer'},
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(question.text),
                      subtitle: Text(
                        response['response'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToQuestion(context, index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToQuestion(BuildContext context, int index) {
    final provider = context.read<SurveyProvider>();
    provider.currentIndex = index;
    Navigator.pop(context); // Go back to the question screen
  }
}
