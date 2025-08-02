
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

## 🧾 Database Schema (Supabase SQL)


### 🧍‍♂️ Table: `users`

Stores basic profile information about users (caregivers, citizens, admins, etc.)

| Column        | Type        | Description                          |
|---------------|-------------|--------------------------------------|
| `id`          | `uuid`      | Primary key (Supabase Auth UID)      |
| `username`    | `text`      | Display name of the user             |
| `profile_image` | `text`    | URL of the user's profile image      |
| `created_at`  | `timestamptz` | Timestamp when account was created  |
| `email`       | `text`      | User email                           |
| `bio`         | `text`      | Short bio/description (optional)     |
| `last_seen`   | `timestamptz` | Last active timestamp                |

---

### 📍 Table: `issues`

Stores all civic issue reports submitted by users.

| Column         | Type        | Description                                      |
|----------------|-------------|--------------------------------------------------|
| `id`           | `int8`      | Auto-incrementing primary key                   |
| `created_at`   | `timestamptz` | Time the issue was reported                   |
| `title`        | `text`      | Short title of the issue                        |
| `description`  | `text`      | Detailed description of the problem             |
| `category`     | `text`      | One of: Roads, Lighting, Water, Cleanliness, etc. |
| `image_url`    | `text`      | Cloudinary image URL                            |
| `latitude`     | `float8`    | Latitude coordinate                             |
| `longitude`    | `float8`    | Longitude coordinate                            |
| `is_anonymous` | `boolean`   | Whether the report is anonymous                 |
| `status`       | `text`      | One of: Reported, In Progress, Resolved         |
| `user_id`      | `uuid`      | Foreign key → `users.id`                        |
| `user_name`    | `text`      | Copied username (for quick access/display)      |

---

### 🛠️ SQL to Create Tables

```sql
-- Table: users
create table if not exists public.users (
  id uuid primary key,
  username text,
  profile_image text,
  created_at timestamptz default now(),
  email text,
  bio text,
  last_seen timestamptz
);

-- Table: issues
create table if not exists public.issues (
  id bigint generated always as identity primary key,
  created_at timestamptz default now(),
  title text not null,
  description text,
  category text,
  image_url text,
  latitude float8,
  longitude float8,
  is_anonymous boolean default false,
  status text default 'Reported',
  user_id uuid references public.users(id) on delete cascade,
  user_name text
);
```


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

Feel free to fork or contribute.


