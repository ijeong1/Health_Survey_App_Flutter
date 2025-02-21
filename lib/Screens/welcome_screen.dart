import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/survey_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SurveyProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (provider.error != null)
              Text(provider.error!, style: const TextStyle(color: Colors.red)),
            const Text(
              'Health Survey',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () => provider.authenticate(_usernameController.text),
              child: const Text('Start Survey'),
            ),
          ],
        ),
      ),
    );
  }
}