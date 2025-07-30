import 'package:bookmark_bites/src/logic/providers/auth_providers.dart';
import 'package:bookmark_bites/src/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Get the current user's data from our existing auth provider
    final user = ref.watch(authStateChangesProvider).value;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.person_pin, size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            if (user != null && user.email != null)
              Text(
                user.email!,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
            const SizedBox(height: 8),
            Text(
              'Currently Signed In',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error, // Use a more indicative color
              ),
              onPressed: () {
                // Show a confirmation dialog before logging out
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text('Sign Out', style: TextStyle(color: AppColors.error)),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            ref.read(authNotifierProvider.notifier).signOut();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}