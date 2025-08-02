📱 CivicTrack App
Empowering citizens to report and track local civic issues with ease.
Built with Flutter and GetX, this app features real-time reporting, community visibility, and an admin-friendly moderation panel.

🗂️ Folder Structure
bash
Copy
Edit
lib/
├── app/
│   ├── bindings/       # GetX Bindings for dependency injection
│   ├── controllers/    # GetX Controllers for managing state & logic
│   ├── data/           # Data sources like APIs, local storage
│   ├── models/         # Model classes (Issue, User, etc.)
│   ├── services/       # Network, location, auth, and other services
│   └── utils/          # Constants, helpers, extensions
├── presentation/
│   ├── screens/        # UI screens for each route
│   └── widgets/        # Reusable widgets (buttons, cards, etc.)
└── main.dart           # App entry point
🚀 Features
🗺️ Location-based visibility (3–5 km radius)

📸 Civic issue reporting with photos (up to 5)

🔔 Status tracking & notifications

🗂️ Category filters (roads, water, lighting, etc.)

🧑‍⚖️ Anonymous or verified user reporting

🛡️ Spam moderation & flagging

📊 Admin analytics dashboard

📦 Tech Stack
Flutter (UI framework)

GetX (State management + routing + dependency injection)

Supabase / Firebase (Backend services)

Cloudinary (Image hosting)

Google Maps API (Location and filtering)

🧠 Design Principles
Modular architecture — clean separation of logic, UI, and data layers.

Scalable structure — easily extend features without tight coupling.

Performance-aware — lazy loading, minimal rebuilds using GetX.

Maintainable — consistent naming, reusable widgets, readable logic.

🛠️ Getting Started
bash
Copy
Edit
git clone https://github.com/yourusername/civictrack.git
cd civictrack
flutter pub get
flutter run
📸 Screenshots
Add UI previews or dashboard mockups here to showcase the app.

🧪 Contributing
Pull requests and feature ideas are welcome!
Open an issue or drop feedback to help improve CivicTrack.

📄 License
MIT

