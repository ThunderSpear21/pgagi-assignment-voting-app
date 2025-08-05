#The Startup Idea Evaluator 🚀

This project is a mobile application built for a mobile developer internship assignment. It allows users to submit, vote on, and discover startup ideas in a fun and interactive way. The app features a mock AI rating system, a community voting mechanism, and a leaderboard to showcase the most popular ideas.

🎥 Video Walkthrough
Watch a walkthrough of the app here! https://drive.google.com/file/d/1SEvKVnw83gF0bh9HniJSbc8hSgdWEdCn/view?usp=sharing 👈

✨ Features Implemented
📱 Multi-Screen UI: A clean, responsive, and intuitive user interface.

💡 Idea Submission: A dedicated form to submit a startup name, tagline, and description.

🤖 Mock AI Rating: Upon submission, each idea receives a fun, randomly generated "AI score" between 60 and 98 to provide instant feedback.

🗳️ Community Voting: Users can browse all submitted ideas and upvote their favorites.

🚫 One-Vote System: The app prevents a user from upvoting the same idea more than once.

🏆 Leaderboard: A dynamic leaderboard screen that showcases the top 5 ideas, sortable by either vote count or AI rating.

🎨 Custom UI Elements: The leaderboard features 🥇🥈🥉 badges and gradient card styles for a premium feel.

🔄 Data Persistence: All ideas and vote counts are saved locally on the device, so data is not lost when the app closes.

🌓 Dark Mode: The app includes a fully functional dark theme that respects the system settings.

🔔 Toast Notifications: Users receive friendly toast/snackbar notifications for key actions like submitting an idea or casting a vote.

🛠️ Tech Stack
Framework: Flutter

Language: Dart

Local Storage: shared_preferences for persisting ideas and user votes.

UI: Material 3 widgets, custom-themed components.

Icons: flutter_launcher_icons for generating the app icon.

Fonts: google_fonts for custom typography (Concert One).

🚀 Getting Started
There are two ways to try the app: installing the ready-made APK or running the project locally from the source code.

1. How to Install the APK (Android)
This is the easiest way to test the app on an Android device.

Download the APK file:
Download app-release.apk here https://drive.google.com/file/d/1o6BtKtxVmaS2serlEXqkJ5Nkc7SU5_eS/view?usp=sharing 👈

Enable Installation from Unknown Sources:
On your Android phone, go to Settings > Security (or Biometrics and security) and enable the "Install unknown apps" permission for your browser or file manager.

Install the App:
Open the downloaded .apk file and tap "Install".

2. How to Run Locally
If you want to run the project from the source code, you'll need to have the Flutter SDK installed.

Clone the Repository:

git clone https://github.com/ThunderSpear21/pgagi-assignment-voting-app

Navigate to the Project Directory:

cd pgagi-assignment-voting-app

Install Dependencies:

flutter pub get

Run the App:
Connect a device or start an emulator, then run:

flutter run
