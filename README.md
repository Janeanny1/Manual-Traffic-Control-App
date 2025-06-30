🛑 Manual Traffic Control App
`
A Flutter-based traffic direction timer app for use by traffic officers when traffic lights are non-functional. It cycles through 4 directions — North, East, South, and West — giving equal time to each, with clear UI and optional beeps. `

🚦 Features
- Auto countdown (45 seconds per direction)

- 2-second pause between directions

- Audio beep before and after each direction (optional)

- Beautiful and responsive user interface

- Manual skip button for officers to move to next direction

- Works on Android, Web, and Desktop (Windows)

🛠 Built With
- Flutter

- Dart

- audioplayers for optional beeping sound

📱 Demo
`Try it live on Netlify:`
👉 https://whimsical-mochi-da267c.netlify.app/

🚀 Getting Started

🔧 Prerequisites
- Flutter SDK

- Dart 3.x

- VS Code

📦 Install Dependencies
`flutter pub get`

▶️ Run the App
- flutter run -d chrome     # For Web
- flutter run -d windows    # For Desktop
- flutter run -d android    # For Android

📦 Build for Deployment
` flutter build web `

🔔 Notes
- Browsers block auto-play audio until the user interacts. For web builds, sound is skipped unless triggered by button tap.

- On Windows, you must enable Developer Mode to run with plugins.

📝 License
`MIT License – free for use, sharing, and modification.`

