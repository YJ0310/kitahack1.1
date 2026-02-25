# Backend Developer Manual (Kitahack 1.6)
**Assignee:** Ruo Qian

Welcome to the backend API development phase for the Kitahack ecosystem! Our system serves three distinct frontend portals: **Student, Enterprise, and School**.

## Overview
Your APIs will serve a Flutter web frontend and negotiate transactions with Google Firebase. Your primary task is supplying endpoints that handle data retrieval, tag-based search matching, team generation operations, and most importantly, integrating the **Google Gemini API** to run intelligent analyses on our logic.

## Core Required APIs

### 1. Tag Management (Centralized)
Because tags can reach thousands of entries, we manage them globally.
*   **`GET /api/tags/search`**
    *   **Query Params:** `?q=py&type=skills` (type is optional to filter).
    *   **Action:** Returns a list of standardized tags (e.g., "Python", "PyTorch") for the frontend auto-complete dropdown.
*   **`POST /api/tags`**
    *   **Payload:** `{ "name": "Machine Learning", "type": "skills" }`
    *   **Action:** Creates a new tag with its specific category (`development`, `course`, or `skills`) if it doesn't already exist, and increments its `useCount`.

### 2. User Profile Management
*   **`GET /api/profile/:uid`**
    *   **Action:** Fetches the profile data based on role.
*   **`PUT /api/profile/student/tags`**
    *   **Payload:** `{ "tags": ["Python", "UI/UX"] }`
    *   **Action:** Updates the student's skills array. This should also ensure those tags exist in the centralized `tags` collection.

### 3. Events & Content Publishing
*   **`POST /api/events/publish`**
    *   **Payload:** `{ "title": "...", "type": "hackathon", "tags": ["Fintech"] }`
    *   **Action:** Creates a new event in the database.
*   **`GET /api/events?tags=Fintech,UI`**
    *   **Action:** Returns a list of events filtered by requested tags.

### 4. Decentralized Team Auto-Pairing (Crucial Updates)
We do not use internal chats, and teams made via auto-pairing have no "owner".
*   **`POST /api/match/auto-pair`**
    *   **Payload:** `{ "userId": "...", "targetEventId": "..." }`
    *   **Action:** The backend finds other students with `autoPairingEnabled=true` for similar tags. It groups them and creates a new document in the `teams` collection containing their `uid`s.
*   **`PUT /api/teams/:teamId/chatlink`**
    *   **Payload:** `{ "userId": "...", "externalChatLink": "https://chat.whatsapp.com/..." }`
    *   **Action:** Any user inside the `members` array of the team can submit a link to their WhatsApp/Discord group. The backend validates they belong to the team and saves the link.

### 5. Candidate Search (Enterprises)
*   **`GET /api/match/candidates`**
    *   **Query Params:** `?query=Python developer` or `?tags=Python,Finance`
    *   **Action:** Calculates a `matchScore` based on tag overlap with students and returns sorted profiles with a `matchReason`.

### 6. AI Data Analysis (Gemini API Integration)
This is your key analytical responsibility. Instead of relying purely on hardcoded math, you will use the **Google Gemini API** (using credits provided by Yin Jia) to analyze data dynamically.
*   **Generate Dashboard Insights:** Develop scripts that periodically read student tags and school events, feed them into a Gemini prompt, and ask Gemini to write personalized `insights` (e.g., "We noticed you are learning Python, based on current job trends..."). 
*   **Natural Language Processing:** Use Gemini to power the enterprise candidate search intelligently. For example, if an enterprise searches "Looking for someone good with data", Gemini can calculate which student tags (like `sql`, `python`, `analytics`) best match the loose string query.
*   **Storage:** Always save the resulting analysis into the `insights` collection so the frontend can read them rapidly without re-calling the API every time the page loads.

## Critical Rules to Follow
1.  **Asynchronous Database Operations:** Always use `await` when querying Firebase. Do not return HTTP responses until the database read/write is confirmed.
2.  **Error Handling:** Use HTTP `400` if the frontend forgets a required payload field (like `tags`), and `404` if a requested `uid` or event doesn't exist.
