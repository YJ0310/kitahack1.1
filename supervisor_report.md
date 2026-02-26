# Project Status Report: Kitahack 1.6 (Teh Ais Portal)

**Date**: February 26, 2026
**Prepared by**: Sek Yin Jia (Frontend & Project Lead)
**To**: Supervisor

## 1. Executive Summary
The **Kitahack 1.6** project (Teh Ais Student Portal) is progressing on schedule with significant milestones achieved in frontend stability, UI/UX redesign, and deployment infrastructure. The platform successfully supports the three primary user roles (**Students**, **Enterprises/Recruiters**, and **Schools/Universities**) under a unified, premium design system. The core architecture—combining a Flutter Web frontend with a Firebase/Node.js backend—is active, incorporating the Google Gemini API for intelligent candidate tagging and matching insights.

## 2. Background & Problem Statement 
According to recent reports, institutional data fragmentation and communication silos heavily restrict interdisciplinary learning and efficient recruitment. At UM, students seeking cross-disciplinary partners for academic projects—such as a Finance student needing an IT student for data visualization, or an Engineering student needing coding assistance—currently rely on fragmented social media channels. 

This creates a significant **collaboration bottleneck**. There is a pressing need for a structured, automated platform that can accurately verify student skills and facilitate highly efficient, cross-disciplinary matching without the overhead of heavy social networking.

## 3. Our Solution & Market Differentiation
The Teh Ais Portal resolves this bottleneck by acting as an **AI-driven Interdisciplinary Talent Matching and Collaboration Platform**. 

**Why we stand out:**
Unlike traditional platforms (like LinkedIn or standard university forums) which suffer from bloated social networking features and generic job boards, our platform is purpose-built for the academic and early-career ecosystem. Key differentiators include:
*   **Decentralized Pairing**: We focus entirely on project/event execution. There are no "friends lists" or endless feeds; students match, connect via external links (WhatsApp/Discord), and build.
*   **AI-Driven Precision**: Instead of manual searching, our platform utilizes the Google Gemini API to parse natural language requests (e.g., "Need an IT student proficient in Python for a Finance project") and instantly recommends the top 5-10 candidates based on a weighted scoring mechanism (Skills 40%, Major 30%, Experience 20%, Custom Tags 10%).
*   **Unified Institutional Ecosystem**: We integrate the three pillars of the university ecosystem. Students find teams, Recruiters find hyper-specific talent through AI filtering, and Schools receive actionable analytics on talent distribution and skill trends.

## 4. How It Works (Mechanism of Action)
The platform operates on a streamlined, three-tier architecture:
1.  **Automated Profiling**: Students log in securely (via Siswamail authentication), and the system automatically structures their major, coursework, and skills into an "AI Skill Profile."
2.  **Natural Language Parsing**: Users (Students or Recruiters) input their needs in natural language. The Gemini API extracts the core requirements (required major, core skills, experience level).
3.  **Weighted Database Matching**: The backend queries the Firestore database, filtering candidates through our centralized taxonomy of `development`, `course`, and `skills` tags. The engine ranks candidates and pushes the best matches directly to the requester's "AI Insights" feed.

## 5. Market & Environmental Impact (SDG Alignment)
The Teh Ais Portal is explicitly designed to align with and advance the United Nations Sustainable Development Goals (SDGs):
*   **SDG 17 (Partnerships for the Goals)**: By breaking down faculty silos, we foster interdisciplinary academic and technical partnerships directly within the campus.
*   **SDG 4 (Quality Education)**: We enhance practical learning and academic depth through shared resources and peer-to-peer skill exchanges.
*   **SDG 8 (Decent Work and Economic Growth)**: By moving away from unstructured resumes to verified, transparent skill profiles, we drastically reduce the cost of campus recruiting for enterprises and ensure fairer, skill-based internship matching for students.

## 6. Recent Accomplishments & Milestones

### A. Frontend Architecture & UI Enhancements
*   **Student Dashboard Redesign**: Simplified the primary student dashboard, removing cluttered statistical grids to prominently feature the "Connect" and "AI Summary" functions for a focused user experience.
*   **Team & Peer Matching (Handover Design)**: Successfully integrated the premium handover design (`teh-ais-student-portal-handover`) into the team-finding feature (`student_team_screen.dart`). Complex UI nesting constraints were addressed to securely implement decentralized auto-pairing.
*   **Unified Enterprise & School Portals**: Upgraded the Enterprise (Recruiter) and School dashboards to mirror the premium aesthetic established in the Student Portal, ensuring a cohesive multi-portal experience.
*   **Interactive Global Dialogs**: Deployed highly functional, interactive dialogs and menus across all three portals. These modules fluently manage essential operations like profile searches, event publishing, invitations, and detailed viewing.

### B. Infrastructure & Deployment
*   **Production Deployment**: The refined web frontend, along with the custom "Firepass" tool, has been successfully deployed to **Firebase Hosting**.
*   **Backend Stability**: Configured and corrected API routing specifically for v2 Cloud Functions, established required authentication, and implemented robust cache-busting configurations to guarantee the delivery of new builds.
*   **Version Control**: The most stable version of our UI logic and integrated services has been committed and forcefully updated to the `main` GitHub branch to serve as our primary source of truth.

## 7. Immediate Next Steps
1.  **Backend Logic refinement**: Finalize comprehensive real-time connections from Flutter back to the generalized `Tags` and `Insights` Firestore collections.
2.  **AI Testing**: Conduct end-to-end verification of the Google Gemini AI insight feed and NLP-based recruiter search functionalities.
3.  **Mock Data Consistency**: Verify that the generative mock profiles and structured events map correctly across all frontend logic flows.

---
*Please let me know if you would like me to schedule a complete walkthrough of the deployed platform.*
