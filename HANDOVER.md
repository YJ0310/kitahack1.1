# Handover Note — Student Portal (Teh Ais)

> **Project:** Teh Ais — University Student Super-App Prototype  
> **Stack:** Flutter Web · Firebase Hosting · go_router · flutter_animate  
> **Live URL:** https://chinshi-bf91e.web.app  
> **Repo:** https://github.com/YJ0310/kitahack1.1  
> **Date:** 2026-02-25  

---

## Overview

This is a Flutter Web prototype for a university student collaboration platform. Students can discover events, form hackathon teams, chat with teammates, and build their skill profile. The design uses a minimal, clean aesthetic inspired by iOS/macOS.

---

## Architecture

```
lib/
├── main.dart                     # Entry point, theme notifier (ValueNotifier)
├── routes/
│   └── app_router.dart           # GoRouter — all named routes
├── theme/
│   └── app_theme.dart            # Colors, fonts, theme data
├── widgets/
│   ├── responsive_shell.dart     # Student portal shell (sidebar + topbar)
│   ├── school_shell.dart         # School portal shell
│   └── enterprise_shell.dart     # Enterprise portal shell
└── screens/
    ├── public/
    │   ├── landing_screen.dart
    │   └── login_screen.dart
    └── student/                  ← YOUR FOCUS
        ├── student_dashboard_screen.dart
        ├── student_event_screen.dart
        ├── student_team_screen.dart
        ├── student_chat_screen.dart
        └── student_profile_screen.dart
```

---

## Student Portal Routes

| Route | Screen | Description |
|---|---|---|
| `/student` | `StudentDashboardScreen` | Main dashboard — stats, AI insights, events, suggested connections |
| `/student/event` | `StudentEventScreen` | Browse and register for events |
| `/student/team` | `StudentTeamScreen` | 3-step team wizard |
| `/student/chat` | `StudentChatScreen` | Temporary team/group chat |
| `/student/profile` | `StudentProfileScreen` | Profile, skills, and tags |

---

## Student Portal Screens

### 1. Dashboard (`student_dashboard_screen.dart`)

- **Welcome Banner** — greeting, quick action buttons
- **Stats Grid** — events joined, teams, achievements, connections
- **AI Executive Summary** — mock AI-generated insights (randomised on load)
- **Upcoming Events** — list of events with date/time
- **My Teams** — current active teams
- **Suggested Connections** — AI-matched students
- **Floating Chat Button** — opens a temporary in-app chat overlay (`_ChatFab` + `_ChatPanel`)

> [!NOTE]
> The floating chat panel (bottom-right bubble) is a **separate** lightweight overlay from the full Chat page. It's in `_ChatFab` / `_ChatPanel` at the bottom of `student_dashboard_screen.dart`.

---

### 2. Teams & Pairing (`student_team_screen.dart`)

Redesigned as a **3-step wizard**:

| Step | Label | What happens |
|---|---|---|
| 1 | Room | User joins or creates a room. Room details collapsed; tap "Show more" to expand. |
| 2 | Teammates | AI-matched room list. First 3 rooms shown; "Show more" reveals rest. Collab Groups hidden until tapped. |
| 3 | Finalize | Lock team → create group chat (WhatsApp/Telegram/Discord link) → Done |

**Key state variables in `_State`:**

```dart
int _step = 1;           // Wizard step (1-3)
bool _inRoom = true;     // Whether user is already in a hackathon room
bool _showRoomDetails;   // Toggle room member details & AI pool (Step 1)
bool _showMoreRooms;     // Toggle extra rooms (Step 2)
bool _showCollabGroups;  // Toggle collab groups section (Step 2)
int _teamStep = 1;       // Sub-step in Step 3 (1=finalize, 2=group chat, 3=done)
```

> [!IMPORTANT]
> All data is **mock/hardcoded** — no Firestore reads/writes yet. Replace `_rooms`, `_myMembers`, `_hackRooms` with real Firestore queries when integrating the backend.

---

### 3. Chat (`student_chat_screen.dart`)

Two-panel layout:
- **Left panel (280px)** — conversation list with unread badges and online indicators
- **Right panel** — full message thread with send input

**Key facts:**
- All messages are **in-memory mock data** (`_mockMsgs` map)
- Labelled "Temporary" — messages clear when user navigates away
- To make it persistent, integrate **Firebase Realtime Database** or **Firestore** with a `messages/{chatId}/{msgId}` document structure

---

### 4. Events (`student_event_screen.dart`)

- Browse upcoming events with filtering by category
- Register / unregister functionality (mock state only)
- Event cards show location, time, team requirement, and category badge

---

### 5. Profile (`student_profile_screen.dart`)

- Displays student info, faculty, skills/tags
- Tags are used for AI matching in the team screen
- Edit functionality is mocked (no backend write)

---

## Navigation Shell (`responsive_shell.dart`)

- **Desktop (≥860px):** Fixed left sidebar (240px) + top breadcrumb bar
- **Mobile (<860px):** Hamburger drawer
- Sidebar items: Dashboard, Events, Teams & Pairing, Profile & Tags, **Chat**
- Dark/Light mode toggle stored in `themeNotifier` (a `ValueNotifier<ThemeMode>` in `main.dart`)

---

## Key Dependencies

```yaml
# pubspec.yaml (relevant)
dependencies:
  flutter_animate: ^4.x     # Used for fade/slide micro-animations
  go_router: ^13.x          # Declarative routing
  firebase_core: ^x         # Firebase init
  # No provider/state management — pure StatefulWidget + setState
```

---

## What's NOT Done Yet (Backend TODOs)

| Feature | Current State | What to Build |
|---|---|---|
| Authentication | Hardcoded user "Ahmad Raza" | Firebase Auth with Google Sign-In |
| Team rooms | Mock data | Firestore `rooms/{roomId}` collection |
| Chat messages | In-memory only | Firestore `chats/{chatId}/messages` with StreamBuilder |
| AI matching | Hardcoded percentages | Gemini API call based on user skill tags |
| Events | Mock list | Firestore `events` collection |
| Profile tags | Static | Firestore `users/{uid}/tags` |

---

## Deployment

```bash
# Build
flutter build web

# Deploy to Firebase Hosting (student portal site)
firebase deploy --only hosting:chinshi-bf91e

# Or push to main branch — GitHub Actions will auto-deploy
git push origin main
```

Firebase project: `chinshi-bf91e`  
Hosting config: `firebase.json` → `hosting.site = "chinshi-bf91e"`  
GitHub Actions workflow: `.github/workflows/firebase-hosting-merge.yml`

---

## Design Tokens (`app_theme.dart`)

```dart
AppTheme.primaryColor      // Main blue/teal
AppTheme.primaryDarkColor  // Darker variant
AppTheme.secondaryColor    // Secondary accent
AppTheme.accentPurple      // Purple — used for AI features
AppTheme.accentPink        // Pink — used for social/connection features
AppTheme.textPrimaryColor  // Dark text (light mode)
AppTheme.backgroundColor   // Light background tint
```

Dark mode is toggled via `themeNotifier.value = ThemeMode.dark/light` from `main.dart`.

---

## Tips for Next Developer

1. **Start with Firestore integration** — the biggest gap. Add `StreamBuilder` widgets in the Team and Chat screens first.
2. **State management** — currently pure `setState`. As the app grows, consider `Riverpod` or `Provider`.
3. **The 3-step Teams wizard** is intentionally simple — secondary features (room details, collab groups, more rooms) are hidden behind tap-to-expand. Keep this UX pattern.
4. **Don't break the shell** — `responsive_shell.dart` is shared. Changes there affect all student screens.
5. **Mock data locations:**
   - Teams: hardcoded in `student_team_screen.dart` (`_rooms`, `_myMembers`)
   - Chat: hardcoded in `student_chat_screen.dart` (`_conversations`, `_mockMsgs`)
   - Dashboard: hardcoded in `student_dashboard_screen.dart` (`_upcomingEvents`, `_myTeams`, `_suggestedUsers`)
