import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/survey_provider.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SurveyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${provider.currentIndex + 1}/${provider.questions.length}'),
        actions: [
          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        itemCount: provider.questions.length,
        itemBuilder: (context, index) {
          final question = provider.questions[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ...question.options.map((option) => _AnswerTile(
                  option: option,
                  isSelected: option == provider.currentAnswer,
                  onSelect: () => provider.setCurrentAnswer(option),
                )),
                const Spacer(),
                _NavigationControls(
                  onPrevious: () {
                    provider.previousQuestion();
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  onNext: () async {
                    await provider.saveAnswer();
                    if (provider.currentIndex < provider.questions.length - 1) {
                      provider.nextQuestion();
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushNamed(context, '/complete');
                    }
                  },
                  isNextEnabled: provider.currentAnswer.isNotEmpty,
                  isLastQuestion: provider.isLastQuestion,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onSelect;

  const _AnswerTile({
    required this.option,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue.withOpacity(0.1) : null,
      child: ListTile(
        title: Text(option),
        leading: Radio<String>(
          value: option,
          groupValue: isSelected ? option : null,
          onChanged: (_) => onSelect(),
        ),
        onTap: onSelect,
      ),
    );
  }
}

class _NavigationControls extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isNextEnabled;
  final bool isLastQuestion;

  const _NavigationControls({
    required this.onPrevious,
    required this.onNext,
    required this.isNextEnabled,
    required this.isLastQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isLastQuestion) // Show "Previous" only if not on the first question
          TextButton(
            onPressed: onPrevious,
            child: const Text('Previous'),
          ),
        ElevatedButton(
          onPressed: isNextEnabled ? onNext : null,
          child: Text(isLastQuestion ? 'Complete' : 'Next'),
        ),
      ],
    );
  }
}