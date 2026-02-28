# ☕ Teh Ais — University Collaboration Platform (Frontend)

> **KitaHack 2025 Hackathon Project**
> Connecting university students for academic collaboration through AI-powered matching.

## 🔗 Prototype Access

**Live Demo:** [https://kitahack-app--kitahack-tehais.us-central1.hosted.app/](https://kitahack-app--kitahack-tehais.us-central1.hosted.app/)

---

## 📐 Technical Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Flutter Web (Frontend)                       │
│               kitahack-tehais.web.app (Firebase Hosting)         │
│                                                                   │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌─────────────────┐  │
│  │ Dashboard │ │ Team Find │ │  Events   │ │Profile + Resume │  │
│  │ (JARVIS   │ │ & Matching│ │ Discovery │ │ + Spectrum UM   │  │
│  │  AI Agent)│ │           │ │           │ │    Import       │  │
│  └─────┬─────┘ └─────┬─────┘ └─────┬─────┘ └───────┬─────────┘  │
│        │              │             │               │             │
│        └──────────────┴─────────────┴───────────────┘             │
│                           │                                       │
│                     REST API Calls                                │
│                    (ApiService)                                    │
└───────────────────────────┬───────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│               Node.js / Express (Backend API)                    │
│      kitahack-app Cloud Run (Firebase App Hosting)               │
│                                                                   │
│  ┌─────────────┐ ┌───────────────┐ ┌───────────────────────────┐ │
│  │  Vertex AI  │ │ AI Database   │ │    Firestore (NoSQL DB)   │ │
│  │  Gemini 2.5 │ │    Manager    │ │   Users · Tags · Posts    │ │
│  │    Flash    │ │ (Smart Cache  │ │   Matches · Events        │ │
│  │             │ │ + Pre-filter) │ │   TempChats               │ │
│  └─────────────┘ └───────────────┘ └───────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Tech Stack

| Layer        | Technology                                   |
| :----------- | :------------------------------------------- |
| Framework    | Flutter 3.x (Dart SDK ^3.11.0)               |
| Platform     | Web (primary), Android/iOS (secondary)       |
| State Mgmt   | ValueNotifier + StatefulWidget               |
| Routing      | GoRouter with shell routes                   |
| Auth         | Firebase Auth + Google Sign-In               |
| HTTP         | Dart `http` package → REST API               |
| Hosting      | Firebase Hosting (`kitahack-tehais.web.app`)  |
| UI/Fonts     | Google Fonts (Poppins), Material 3            |
| Animations   | flutter_animate                              |
| File Upload  | file_picker + Firebase Storage               |

---

## 🏗️ Implementation Details

### Project Structure

```
lib/
├── main.dart                     # App entry point, Firebase init
├── firebase_options.dart         # Firebase configuration
├── routes/
│   └── app_router.dart           # GoRouter with role-based shell routes
├── screens/
│   ├── public/                   # Landing & Login screens
│   │   ├── landing_screen.dart
│   │   └── login_screen.dart
│   ├── student/                  # Student portal (5 core screens)
│   │   ├── student_dashboard_screen.dart    # JARVIS AI command center
│   │   ├── student_team_screen.dart         # Team finding & matching
│   │   ├── student_event_screen.dart        # Event discovery
│   │   ├── student_chat_screen.dart         # 48-hour temp chats
│   │   └── student_profile_screen.dart      # Profile, resume, import
│   ├── enterprise/               # Enterprise recruiter view
│   │   ├── enterprise_dashboard_screen.dart
│   │   └── candidate_search_screen.dart
│   └── school/                   # University admin view
│       ├── school_dashboard_screen.dart
│       ├── enterprise_network_screen.dart
│       └── publish_content_screen.dart
├── services/
│   ├── api_service.dart          # Centralized REST API client
│   └── auth_service.dart         # Firebase Auth wrapper
├── models/                       # Data models
│   ├── user_model.dart
│   ├── post_model.dart
│   ├── match_model.dart
│   ├── event_model.dart
│   ├── chat_model.dart
│   └── tag_model.dart
├── widgets/                      # Shared UI components
│   ├── responsive_shell.dart     # Responsive side nav / bottom nav
│   ├── enterprise_shell.dart
│   └── school_shell.dart
└── theme/
    └── app_theme.dart            # Light/dark themes, color palette
```

### Key Features

1. **JARVIS AI Dashboard** — Natural language command interface that can search teammates, recommend events, generate insights, and execute actions (create posts, join events)
2. **AI Team Matching** — Post project requirements and let Gemini AI find the best-fit candidates from 10K+ students based on skills, courses, and development areas
3. **Smart Event Discovery** — AI-powered event search and recommendation based on student profile and interests
4. **48-Hour Temp Chats** — Time-limited chat rooms after match acceptance to encourage quick collaboration
5. **AI Profile Auto-Tagging** — Describe your skills in free text; AI maps them to standardized university tags
6. **AI Resume Generator** — One-click resume generation from profile data
7. **Spectrum UM Import** — Import academic data from university system

### API Integration

All AI features are powered by the backend REST API. The `ApiService` class handles:
- Automatic environment switching (`localhost:3000` in debug, `/api` in production)
- Firebase Auth token forwarding
- Dev bypass via `X-Dev-UID` header

### Theme & Design

The app uses a warm, Malaysian tea-inspired color palette:
- **Primary:** `#8C5535` (rich brown)
- **Secondary:** `#BF8E63` (warm tan)
- **Background:** `#D9BFA0` (cream)

Both light and dark themes are supported with toggle on the dashboard.

---

## ⚡ Challenges Faced

1. **Cross-Platform Web Compatibility** — Flutter Web with WASM required careful CSP configuration; Google Fonts, Firebase Auth popup, and service workers all needed specific headers. Solved by disabling helmet's CSP on the backend and configuring custom headers.

2. **Massive Data Scale** — With 10K users and 1K tags in Firestore, every AI operation was reading the entire database (~11K reads per call). Solved by building an AI Database Manager with in-memory tag cache and smart pre-filtering, reducing reads by 95%.

3. **Vertex AI JSON Parsing** — Gemini's text model sometimes returned malformed JSON with markdown fences or trailing text. Solved by creating a dedicated `jsonModel` with `responseMimeType: 'application/json'` and multi-layer fallback parsing.

4. **Production DNS Resolution** — After deploying to Firebase App Hosting, the frontend couldn't reach the backend API due to `ERR_NAME_NOT_RESOLVED`. Root cause: `firebase.json` rewrites pointed to the wrong Cloud Run service name. Fixed by correcting the service identifier.

5. **Real-Time State Consistency** — Keeping the dashboard AI insights, match statuses, and chat states in sync across navigation required careful state management with `ValueNotifier` rebuilds and pull-to-refresh patterns.

6. **Rate Limiting & 429 Errors** — High-frequency AI calls during demo scenarios triggered Vertex AI rate limits. Implemented exponential backoff with jitter (up to 3 retries) in the Vertex AI client layer.

---

## 🗺️ Future Roadmap (by 28 March — Final Round)

### Week 1 (1–7 Mar) — UX Polish & Testing
- [ ] Improve responsive layout for mobile and tablet breakpoints
- [ ] Add loading skeletons and error state UI across all screens
- [ ] End-to-end testing of all AI features with real user data
- [ ] Fix edge cases in 48-hour temp chat expiration flow

### Week 2 (8–14 Mar) — AI Accuracy & Reliability
- [ ] Fine-tune AI matching prompts for higher relevance scores
- [ ] Add match explanation transparency (show why AI recommended each candidate)
- [ ] Implement multi-turn JARVIS conversations with session context
- [ ] Stress test AIDB Manager with full 10K user dataset

### Week 3 (15–21 Mar) — Enterprise & School Portals
- [ ] Complete enterprise recruiter dashboard with candidate search
- [ ] Build school admin portal for event publishing and analytics
- [ ] Add real-time notification system for match/chat updates
- [ ] Integrate Spectrum UM data import for auto-profile population

### Week 4 (22–28 Mar) — Final Polish & Demo Prep
- [ ] Performance optimization and cold-start reduction on Cloud Run
- [ ] Comprehensive demo walkthrough with seed data scenarios
- [ ] Final UI/UX review and accessibility improvements
- [ ] Documentation and presentation preparation for judging

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.11.0
- Firebase CLI
- A Firebase project with Auth + Firestore enabled

### Local Development

```bash
# Clone the repository
git clone https://github.com/YJ0310/kitahack1.1.git
cd kitahack1.1

# Install dependencies
flutter pub get

# Run in debug mode (connects to localhost:3000 backend)
flutter run -d chrome

# Build for production
flutter build web --release --no-web-resources-cdn

# Deploy to Firebase Hosting
firebase deploy --only hosting --project kitahack-tehais
```

---

## 👥 Team

- **Yin Jia Sek** — Full-Stack Developer, AI Integration
- **Ruo Qian** — Backend Architecture
- **Jia Qian** — Database Design
- **Jolin Lee** — Frontend UI/UX

---

## 📄 License

This project was built for KitaHack 2025. All rights reserved.
