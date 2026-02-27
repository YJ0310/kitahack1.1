import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome Back',
                    style: Theme.of(
                      context,
                    ).textTheme.displayMedium?.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to your Teh Ais account',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : () => _handleGoogleSignIn(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardTheme.color,
                        foregroundColor: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.1),
                          ),
                        ),
                        elevation: 0,
                      ),
                      icon: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.g_mobiledata_rounded,
                              size: 32,
                              color: Colors.red,
                            ),
                      label: Text(
                        _loading ? 'Signing in...' : 'Continue with Google',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dev mode bypass
                  TextButton(
                    onPressed: _loading ? null : () => _showDevDialog(context),
                    child: Text(
                      'Dev Mode (prototype)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Home'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    setState(() => _loading = true);
    try {
      await AuthService().signInWithGoogle();
      if (!context.mounted) return;
      _showRoleDialog(context, fromGoogle: true);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showRoleDialog(BuildContext context, {bool fromGoogle = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(fromGoogle
            ? 'Welcome! Select your role'
            : 'Select Role (Prototype)'),
        content: Text(fromGoogle
            ? 'Which portal would you like to access?'
            : 'Which portal would you like to view? (Demonstration purposes)'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              AuthService().setRole('School');
              if (!fromGoogle) {
                await AuthService().signInDev(role: 'School');
              }
              if (context.mounted) context.go('/school');
            },
            child: const Text('School'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              AuthService().setRole('Enterprise');
              if (!fromGoogle) {
                await AuthService().signInDev(role: 'Enterprise');
              }
              if (context.mounted) context.go('/enterprise');
            },
            child: const Text('Enterprise'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              AuthService().setRole('Student');
              if (!fromGoogle) {
                await AuthService().signInDev(role: 'Student');
              }
              if (context.mounted) context.go('/student');
            },
            child: const Text('Student'),
          ),
        ],
      ),
    );
  }

  void _showDevDialog(BuildContext context) {
    _showRoleDialog(context, fromGoogle: false);
  }
}

