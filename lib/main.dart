import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TehAisApp());
}

class TehAisApp extends StatelessWidget {
  const TehAisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Teh Ais',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
