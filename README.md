
# 🏙️ CivicTrack – Report, Resolve, Revive

**CivicTrack** is a community-driven platform that empowers citizens to report local civic issues like potholes, water leaks, garbage overflow, and more — all within a 3–5 km radius. With real-time updates, map-based tracking, and admin moderation, CivicTrack bridges the gap between the public and the authorities for a cleaner, safer neighborhood.

---

## ✨ Core Features

- 🧾 **Quick Issue Reporting**  
  Users can report civic problems with a title, description, photo uploads (up to 5), and category selection.

- 📍 **Radius-Based Visibility**  
  Only reports within a 3–5 km GPS or manually set radius are visible, keeping things hyper-local.

- 👤 **Anonymous or Verified Reporting**  
  Users can choose to report anonymously or using their verified profile.

- 🔔 **Status Tracking**  
  View live status updates like _Reported_, _In Progress_, and _Resolved_ with timestamps and change logs.

- 🗺️ **Interactive Map View**  
  All reports appear as pins on a map with filtering by distance, category, and status.

- 🧼 **Spam Reporting & Moderation**  
  Users can flag spam/irrelevant reports. Reports flagged multiple times are auto-hidden pending admin review.

- 📊 **Admin Dashboard & Analytics**  
  Admins can view insights like most reported categories, total reports, and take moderation actions.

---

## 📲 Quick Start

1. **Clone the repository**
    ```bash
    git clone https://github.com/your-username/civictrack.git
    cd civictrack
    ```

2. **Install dependencies**
    ```bash
    flutter pub get
    ```

3. **Set up Supabase**  
   Open the file `lib/main.dart` and replace the placeholder values with your actual Supabase credentials:

    ```dart
    Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();

      await Supabase.initialize(
        url: 'YOUR_SUPABASE_URL',         // <-- PASTE YOUR URL HERE
        anonKey: 'YOUR_SUPABASE_ANON_KEY' // <-- PASTE YOUR KEY HERE
      );

      runApp(const MyApp());
    }
    ```

4. **Run the app**
    ```bash
    flutter run
    ```

---

## 📂 Project Structure

```plaintext
lib/
├── app/
│   ├── bindings/       # GetX Bindings for dependency injection
│   ├── controllers/    # GetX Controllers for managing state & logic
│   ├── data/           # Data providers and mock APIs
│   ├── models/         # Model classes (Issue, User, etc.)
│   ├── services/       # Business logic (API calls, Supabase, Cloudinary)
│   └── utils/          # Constants, helpers, extensions
├── presentation/
│   ├── screens/        # UI pages like Home, Report Issue, Admin Panel
│   └── widgets/        # Reusable UI components (e.g., issue cards, map pins)
└── main.dart           # Entry point
````

---

## 🌍 Future Enhancements

* 🌐 **Multilingual Support**
  For diverse communities across regions.

* 🧠 **AI-Powered Issue Categorization**
  Smart detection of issue types from image and description.

* 🎟️ **Issue Upvoting**
  Let citizens vote on issues that need the most attention.

* 📬 **Push Notifications**
  For real-time status updates on submitted reports.

* 🧑‍⚖️ **Advanced Admin Tools**
  Tagging priority issues, assigning responders, exporting reports.

---

## 🛠️ Built With

* **Flutter** 💙 – Fast, beautiful, and multi-platform UI toolkit
* **Supabase** 🔐 – Authentication, database, and storage
* **GetX** ⚡ – Lightweight and reactive state management
* **Google Maps / flutter\_map** 🗺️ – For visualizing civic reports on the map
* **Cloudinary** ☁️ – To upload and host report images
* **fl\_chart** 📊 – For beautiful analytics graphs and charts

---

## 👨‍💻 Made by Kartik and Hemish

We're on a mission to improve our cities — one report at a time.
Feel free to fork, contribute, or just say hi! 🙌

```

