import 'package:bookmark_bites/src/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class OfflineHomeWidget extends StatelessWidget {
  const OfflineHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              "You're Offline",
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              "No internet connection found. Check your connection or enjoy your saved recipes.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.favorite_border),
              label: const Text('View My Saved Recipes'),
              onPressed: () => context.push(AppRoutes.favorites),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),
      ),
    );
  }
}