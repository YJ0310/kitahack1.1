# Complete Backend & Database Requirements (Kitahack 1.6)

Based on the actual Flutter frontend screens for the Kitahack project, here are the updated requirements. The system supports three primary user roles: **Student**, **Enterprise**, and **School/University**.

## 1. Technology Architecture
*   **Frontend:** Flutter Web (`kitahack1_6`).
*   **Backend Language:** Node.js / JavaScript (or Firebase Cloud Functions).
*   **Database:** Google Firebase Firestore/Realtime DB. 
*   **Integration:** Firebase Authentication for secure User IDs, and **Google Gemini API** for data/insight analysis.

## 2. Team Roles & Responsibilities
*   **Sek Yin Jia (Frontend & Project Lead):** Handles UI/UX, GitHub configuration, and provides Google Cloud API keys (including Gemini API credits).
*   **Ruo Qian (Backend):** Modifies the base framework to manage data processing, API logic, and acts as the **AI Integrator**, using the Google Gemini API to analyze data and generate intelligent insights.
*   **Foo Jia Qian (Database):** Designs the data schema/model and generates initial mock data.

## 3. Core Operational Entities

### A. Students
*   **Focus:** Managing profiles, skills (tags), finding events, and team matching.
*   **Key Dynamics:** AI Insights feed, decentralized auto-pairing for teams, and matching score logic against events or jobs.

### B. Enterprise / Recruiters
*   **Focus:** Candidate search, monitoring hiring pipelines, and posting internships/jobs.
*   **Key Dynamics:** Searching students based on NLP string queries (e.g., "Python developer with finance background") that the backend resolves against student tags.

### C. Schools / Universities
*   **Focus:** Dashboard analytics on student trends (e.g., skill tag increases) and publishing content (events/campaigns).
*   **Key Dynamics:** Aggregating data from students to show faculty-level trends and managing the event registry.

## 4. General Backend API Requirements
*   **Authentication & Validation:** Every request must include the `uid` (Firebase User ID). The backend must validate the token before returning any sensitive data.
*   **RESTful/RPC Design:** Provide clear endpoints to handle diverse models.
    *   **GET** `/api/user/profile` (Fetch profile based on role).
    *   **GET/POST** `/api/tags` (Fetch or create standardized tags).
    *   **GET** `/api/insights` (Fetch AI-generated alerts/notifications).
    *   **GET** `/api/match/candidates` (For Enterprises to search students).
    *   **POST** `/api/match/auto-pair` (Trigger team grouping without an owner).
    *   **PUT** `/api/teams/:teamId/chatlink` (Update the external WhatsApp/Discord link for the team).
*   **Status Codes:** Standard 200 (Success), 400 (Bad Request - missing parameters), 401 (Unauthorized), 404 (Not Found), 500 (Internal Server Error).

## 5. General Database Requirements
*   **NoSQL Structure:** Utilize collections for `Users`, `Events`, `Teams`, `Tags` and `Insights`.
*   **Tag Management:** Tags are managed in a centralized collection and are categorized into three distinct types: **`development`**, **`course`**, and **`skills`**. This supports thousands of entries, ensuring spelling consistency and allowing usage tracking.
*   **Decentralized Teams:** We do NOT build a chat system. Teams have no "owner" (decentralized). Members coordinate externally by setting a `externalChatLink` (WhatsApp, Telegram, Discord).
*   **Mock Data Needs:** Crucial to unblock frontend development. Generative AI should be used to populate realistic profiles, events, tags, and mock insights.
