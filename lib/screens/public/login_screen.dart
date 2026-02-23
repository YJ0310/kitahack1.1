import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.hub_rounded,
                      color: AppTheme.primaryColor,
                      size: 48,
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
                      onPressed: () => _showRoleDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.textPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.g_mobiledata_rounded,
                        size: 32,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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

  void _showRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Role Prototype'),
        content: const Text(
          'Which portal would you like to view? (Demonstration purposes)',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/school');
            },
            child: const Text('School'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/enterprise');
            },
            child: const Text('Enterprise'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/student');
            },
            child: const Text('Student'),
          ),
        ],
      ),
    );
  }
}
