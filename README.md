# health survey app

This repository and application were created for the Mobile Developer Technical Assignment. For more details, please refer to the following GitHub repository: https://github.com/vecpsygrp/Technical-Assessment/.
The main objective is to develop a mobile quiz application that calls a REST API to obtain a token and proceeds with a 10-step quiz.

## 📦 Dependencies
You can configure it by modifying the pubspec.yaml file, assuming the Flutter development environment is already set up.
The dependencies are as follows:
```
dependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.1
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  http: ^0.13.6
```

## 🛠️ Installation and Run
```
` unzip the health_survey_app file.
` cd health_survey_app
` flutter pub get
` flutter run
```

---
## 🗂️ Project Structure
```
lib/
├── Models/
│   └── question.dart       # Survey data model
│   └── response.dart       # Response data model
├── Providers/
│   └── survey_provider.dart    # Provider (ViewModel)
├── Screens/
│   └── completion_screen.dart  # Suervey Completion screen
│   └── question_screen.dart    # Suervey screen
│   └── welcome_screen.dart     # welcome screen (befure authentication)
├── Services/
│   └── api_service.dart        # API Service
└── main.dart                   # App entry & DI setup
```
---
## 🗝️ Key Features of the Question Screen
```
* Smooth Transitions: 
  * Uses PageView with PageController for smooth horizontal transitions. 
  * Animations for question navigation. 
* Progress Tracking:
  * Displays current question number and total questions in the app bar. 
  * Updates progress as the user navigates. 
* Answer Selection:
  * Radio buttons for multiple-choice answers. 
  * Visual feedback for selected answers. 
* Navigation Controls:
  * Previous/Next buttons. 
  * Next button disabled until an answer is selected.
  * "Complete" button on the last question. 
* State Management:
  * Listens to SurveyProvider for state changes. 
  * Updates UI based on current question and selected answer. 
* Error Handling:
  * Shows loading indicator during API calls. 
  * Disables buttons during loading.
```
