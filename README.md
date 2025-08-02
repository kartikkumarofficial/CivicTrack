CivicTrack - Community-Powered Issue Reporting
<p align="center">
<img src="https://www.google.com/search?q=https://img.shields.io/badge/Flutter-3.x-blue%3Flogo%3Dflutter" alt="Flutter">
<img src="https://www.google.com/search?q=https://img.shields.io/badge/Supabase-Backend-green%3Flogo%3Dsupabase" alt="Supabase">
<img src="https://www.google.com/search?q=https://img.shields.io/badge/Cloudinary-Media-blueviolet%3Flogo%3Dcloudinary" alt="Cloudinary">
<img src="https://www.google.com/search?q=https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT">
</p>

An open-source Flutter application that empowers citizens to report, track, and visualize local civic issues. Users can submit problems like potholes, broken streetlights, or uncollected garbage with photos and precise locations, and monitor their resolution status within the community.

📸 Screenshots
Home Screen (List View)

Report New Issue

Issues Map View

Issue Details









✨ Features
Real-time Issue Feed: View a live, scrollable list of all reported issues.

Interactive Map View: Visualize the geographic distribution of all reported issues on a full-screen map with custom markers.

Detailed Issue Reporting: Submit new issues with a title, description, category, and photo.

Precise Location Pinpointing: Automatically fetch the user's current location or use an interactive map with search to select the exact spot of an issue.

Cloud-Based Image Uploads: Images are handled by Cloudinary for efficient storage and delivery.

User-Specific Filtering: Filter the issue feed to show only the problems you have reported.

Detailed View: Tap any issue from the list or map to see its full details, including the image, description, and reporter information.

Light & Dark Mode: The UI seamlessly adapts to the system's theme.

🛠️ Tech Stack
Frontend: Flutter

Backend-as-a-Service (BaaS): Supabase (Database & Auth)

State Management: GetX

Mapping: OpenStreetMap with flutter_map

Image Hosting: Cloudinary

Location Services: geolocator, geocoding

📁 Folder Structure
The project maintains a clean and scalable folder structure:

lib
├── app
│   ├── controllers   # GetX controllers for state management (e.g., theme, account)
│   ├── models        # Data models (e.g., issue_model.dart)
│   └── services      # External services (e.g., cloudinary_service.dart)
├── presentation
│   ├── screens       # Main screens of the app (e.g., home_screen.dart, report_issue_screen.dart)
│   └── widgets       # Reusable widgets (e.g., issue_card.dart)
└── main.dart         # App entry point and initialization

🚀 Getting Started
Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

Prerequisites
Flutter SDK installed (version 3.x or higher)

A code editor like VS Code or Android Studio

A Supabase account (free tier)

A Cloudinary account (free tier)

Installation & Setup
1. Clone the Repository

git clone [https://github.com/YOUR_USERNAME/YOUR_REPO.git](https://github.com/YOUR_USERNAME/YOUR_REPO.git)
cd YOUR_REPO

2. Install Dependencies

flutter pub get

3. Set up Supabase

Go to your Supabase Dashboard and create a new project.

In your project, go to the SQL Editor and run the query from the database.sql file (or the queries provided in the development history) to create the issues table.

Go to Project Settings > API. Copy your Project URL and anon public Key.

In lib/main.dart, replace the placeholder values with your Supabase credentials:

await Supabase.initialize(
url: 'YOUR_SUPABASE_URL',
anonKey: 'YOUR_SUPABASE_ANON_KEY',
);

4. Set up Cloudinary

Go to your Cloudinary Dashboard.

Find your Cloud Name on the dashboard.

Go to Settings (gear icon) > Upload.

Scroll down to Upload presets, click "Add upload preset".

Change the "Signing Mode" from "Signed" to "Unsigned" and save. Copy the Upload preset name.

In lib/app/services/cloudinary_service.dart, replace the placeholder values:

class Secrets {
static const cloudName = 'YOUR_CLOUD_NAME';
static const uploadPreset = 'YOUR_UPLOAD_PRESET_NAME';
}

5. Configure Location Permissions

Follow the instructions in the geolocator and flutter_map package documentation to set up the necessary permissions for Android and iOS. This involves editing AndroidManifest.xml and Info.plist.

6. Run the App

flutter run

🤝 Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

Fork the Project

Create your Feature Branch (git checkout -b feature/AmazingFeature)

Commit your Changes (git commit -m 'Add some AmazingFeature')

Push to the Branch (git push origin feature/AmazingFeature)

Open a Pull Request

📄 License
This project is licensed under the MIT License - see the LICENSE.md file for details.