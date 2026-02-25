import 'package:go_router/go_router.dart';

import '../screens/public/landing_screen.dart';
import '../screens/public/login_screen.dart';

import '../widgets/responsive_shell.dart';
import '../screens/student/student_dashboard_screen.dart';
import '../screens/student/student_team_screen.dart';
import '../screens/student/student_event_screen.dart';
import '../screens/student/student_profile_screen.dart';
import '../screens/student/student_chat_screen.dart';

import '../widgets/school_shell.dart';
import '../screens/school/school_dashboard_screen.dart';
import '../screens/school/publish_content_screen.dart';
import '../screens/school/enterprise_network_screen.dart';

import '../widgets/enterprise_shell.dart';
import '../screens/enterprise/enterprise_dashboard_screen.dart';
import '../screens/enterprise/candidate_search_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // Student Routes
    ShellRoute(
      builder: (context, state, child) => ResponsiveShell(child: child),
      routes: [
        GoRoute(
          path: '/student',
          builder: (context, state) => const StudentDashboardScreen(),
        ),
        GoRoute(
          path: '/student/team',
          builder: (context, state) => const StudentTeamScreen(),
        ),
        GoRoute(
          path: '/student/event',
          builder: (context, state) => const StudentEventScreen(),
        ),
        GoRoute(
          path: '/student/profile',
          builder: (context, state) => const StudentProfileScreen(),
        ),
        GoRoute(
          path: '/student/chat',
          builder: (context, state) => const StudentChatScreen(),
        ),
      ],
    ),
    // School Routes
    ShellRoute(
      builder: (context, state, child) => SchoolShell(child: child),
      routes: [
        GoRoute(
          path: '/school',
          builder: (context, state) => const SchoolDashboardScreen(),
        ),
        GoRoute(
          path: '/school/publish',
          builder: (context, state) => const PublishContentScreen(),
        ),
        GoRoute(
          path: '/school/enterprise_network',
          builder: (context, state) => const EnterpriseNetworkScreen(),
        ),
      ],
    ),
    // Enterprise Routes
    ShellRoute(
      builder: (context, state, child) => EnterpriseShell(child: child),
      routes: [
        GoRoute(
          path: '/enterprise',
          builder: (context, state) => const EnterpriseDashboardScreen(),
        ),
        GoRoute(
          path: '/enterprise/candidates',
          builder: (context, state) => const CandidateSearchScreen(),
        ),
      ],
    ),
  ],
);
