# Frontend LLM Handover Document

## Project Overview
This project is a **Flutter Web** application named "Teh Ais", designed as a cross-disciplinary talent platform for Kitahack. It features a modern, responsive, glassmorphic UI, with a unified custom color palette and complex UX flows specifically around team building and event pairing.

## Technology Stack
- **Framework:** Flutter (Web target)
- **Routing:** `go_router` (configured in `lib/main.dart`)
- **Animations:** `flutter_animate` (heavily used for micro-interactions and the landing page)
- **Theming:** Custom `AppTheme` with dynamic Light/Dark mode toggling via a global `ValueNotifier<ThemeMode>`.
- **Hosting:** Firebase Hosting (Static build served from `build/web/`), configured with `firebase.json`.

## Brand Identity & Theming (`lib/theme/app_theme.dart`)
The app uses a 5-color aesthetic Kitahack palette:
- **Primary (Brown):** `#8C5535` (Main CTA buttons, highlighted headers)
- **Primary Dark (Darker Brown):** `#8C4C35` (Outlines, hover states)
- **Secondary (Tan/Ochre):** `#BF8E63` (Secondary buttons, gradient combinations)
- **Background (Beige/Light Tan):** `#D9BFA0` (Subtle tag backgrounds, light mode accents)
- **Text/Dark Bg (Almost Black):** `#0D0D0D` (Text context, dark mode core background)

**Note on Theming:** We recently scrubbed all hardcoded coloring (e.g., `Colors.white`). When creating new UI components, **always** rely on `Theme.of(context).cardTheme.color`, `Theme.of(context).scaffoldBackgroundColor`, and `AppTheme` references so dynamic dark mode continues to function perfectly.

## App Architecture & Key Files

### 1. Root & Configuration
- **`lib/main.dart`**: Application entry point. Sets up the initial `MaterialApp.router` wrapped in a `ValueListenableBuilder` to actively listen to `themeNotifier` for instant toggling. Includes the `go_router` path map.
- **`pubspec.yaml`**: Manages dependencies. Includes `assets/logo.png`.
- **`firebase.json`**: Configured to serve the `/build/web` directory with caching headers to prevent UI staleness.

### 2. Public Screens (`lib/screens/public/`)
- **`landing_screen.dart`**: A massive, fully responsive, highly animated landing page translated directly from a React/Tailwind design. Uses `flutter_animate` heavily to simulate CSS keyframes (floating blobs, staggered fade-ins).
- **`login_screen.dart`**: Clean authentication entry with the App Logo integrated.

### 3. Application Shell (`lib/widgets/responsive_shell.dart`)
- Wraps all authenticated views (`/student`, `/enterprise`, etc.) to provide universal navigation.
- Implements a responsive layout: Desktop shows a fixed left-side `Drawer` (Sidebar), while Mobile hides it behind a standard `AppBar` hamburger menu.

### 4. Student Flow (`lib/screens/student/`) (Core Logic Area)
- **`student_dashboard_screen.dart`**: Overview widgets for student statistics.
- **`student_profile_screen.dart`**: Deep user profile displaying skills, custom tags, and portfolio grid.
- **`student_event_screen.dart`**: 
  - Divides events into "Recommended For You" and "Explore Entire Server". 
  - **Logic Note:** Renders different CTAs based on `isTeamRequired`. If True, it pushes "Create Room". If False, "Join Event".
- **`student_team_screen.dart`**: Implements complex pairing & lobby logic.
  - Tabs: "My Team", "My Room", "Suggested Room".
  - **Room Logic:** Users create/join transient rooms.
  - **Team Conversion & Chat Logic:** Once a room is full, it's converted to a Team. A designated member has a 180-second countdown to generate an external Group Chat link (e.g., WhatsApp/Telegram) and paste it. Once verified, all team members get access to a universal "Join Group" button.

### 5. Enterprise & School Flows (`lib/screens/enterprise/`, `lib/screens/school/`)
- Contains B2B dashboards, `candidate_search_screen.dart`, and `publish_content_screen.dart`. Fully adapted to Dark Mode constraints.

## Assets & Build Directory
- **App Logo:** `assets/logo.png` (Used inside the UI, replacing older generic icons).
- **Web Metadata:** The `web/` directory contains custom favicons, Apple Touch icons (`web/icons/`), and an updated `manifest.json` ensuring the PWA experience respects the brand colors.

## Common Operations for LLMs
- **To Build Web:** Run `flutter build web`.
- **To Deploy:** Run `firebase deploy --only hosting`.
- **To Re-evaluate UI:** Read `landing_screen.dart` as the gold standard for how to handle complex layouts and animations in this codebase.
