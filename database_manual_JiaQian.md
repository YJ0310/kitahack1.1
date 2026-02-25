# Database Developer Manual (Kitahack 1.6)
**Assignee:** Foo Jia Qian

Welcome to the data modeling phase for the Kitahack ecosystem! This project centers around three distinct user roles: **Student, Enterprise, and School**.

## Tech Stack & Environment
*   **Database:** Google Firebase (Firestore or Realtime DB).
*   **Goal:** Define the JSON schemas and generate mock data for these collections so the frontend UI can populate realistically.

## Core Collections & Schema Design

### 1. `tags` Collection (Centralized Dictionary)
Since we may have thousands of tags, a dedicated collection prevents duplication and allows for auto-complete searches.
*   **Document ID:** Auto-generated Firebase ID.
*   **Fields:**
    *   `name`: String (e.g., "python", "ui/ux", "fintech" - stored entirely lowercase for searchability).
    *   `displayName`: String (e.g., "Python", "UI/UX").
    *   `type`: String (Enum: `'development'`, `'course'`, `'skills'`). Helps organize tag types.
    *   `useCount`: Integer (Helps sort popular tags).

### 2. `users` Collection
*   **Document ID:** Auto-generated Firebase `uid`.
*   **Fields Validation:**
    *   `role`: String (Enum: `'student'`, `'enterprise'`, `'school'`).
    *   `name`: String.
    *   `email`: String.
    *   `createdAt`: Timestamp.

#### Student Profiles
*   `faculty`: String.
*   `tags`: Array of Strings (references to `displayName` from the `tags` collection).
*   `autoPairingEnabled`: Boolean (Default: `false`).
*   `projects`: Array of Objects:
    *   `title`: String.
    *   `description`: String.
    *   `associatedTags`: Array of Strings.

#### Enterprise & School Profiles
*   *(Enterprise)* `companyName`: String, `industryFocus`: String, `openRoles`: Integer.
*   *(School)* `institutionName`: String.

### 3. `events` Collection (Published by Schools/Enterprises)
*   **Document ID:** Auto-generated Firebase ID.
*   **Fields:**
    *   `title`: String.
    *   `tags`: Array of Strings.
    *   `status`: String (Enum: `'active'`, `'completed'`).
    *   `participants`: Integer (Count of joined students, Default: `0`).

### 4. `teams` Collection (Decentralized Auto-Pairing)
To keep things simple, we do **not** have an in-app chat. Also, teams matched via auto-pairing have **no group owner** (decentralized).
*   **Document ID:** Auto-generated Firebase ID.
*   **Fields:**
    *   `projectType`: String (e.g., "Fintech Hackathon").
    *   `members`: Array of Strings (List of user `uid`s in the group).
    *   `externalChatLink`: String (URL for WhatsApp, Telegram, Discord). Any member can set this link. Default is `""` or `null`.
    *   `status`: String (Enum: `'forming'`, `'active'`).

### 5. `insights` Collection (Dashboard Notifications)
*   **Fields:** `targetUserId` (uid), `title`, `content`, `actionText`, `createdAt`.

## Immediate Action Items
1.  **Firebase Setup:** Finalize the Firestore database structure using the rules above.
2.  **Mock Data Generation:** Create sample tags (at least 20), user profiles, events, and a few active teams.
