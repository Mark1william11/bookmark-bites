import 'package:bookmark_bites/src/presentation/theme/app_colors.dart';
import 'package:bookmark_bites/src/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key, required this.child});

  final Widget child;

  // Helper function to get the current page title
  String _getPageTitle(String location) {
    if (location.startsWith(AppRoutes.favorites)) return 'My Favorites';
    if (location.startsWith(AppRoutes.profile)) return 'My Profile';
    return 'Discover Recipes';
  }
  
  // Helper function to determine the current index from the route
  int _calculateSelectedIndex(String location) {
    if (location.startsWith(AppRoutes.favorites)) return 1;
    if (location.startsWith(AppRoutes.profile)) return 2;
    return 0; // Default to home
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _calculateSelectedIndex(location);

    return Scaffold(
      appBar: AppBar(
        // Use the helper to set the title dynamically
        title: Text(_getPageTitle(location)),
        // THE FIX: Remove the actions button completely
        actions: const [],
      ),
      body: child,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: GNav(
          // THE FIX: Add the third GButton for Profile
          tabs: const [
            GButton(icon: Icons.explore_outlined, text: 'Discover'),
            GButton(icon: Icons.favorite_border, text: 'Favorites'),
            GButton(icon: Icons.person_outline, text: 'Profile'),
          ],
          // Styling
          rippleColor: AppColors.primary.withOpacity(0.2),
          hoverColor: AppColors.primary.withOpacity(0.1),
          gap: 8,
          activeColor: Colors.white,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.primary,
          color: AppColors.textLight,
          // Functionality
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            // Check to prevent navigating to the same page again
            if (index == selectedIndex) return;

            if (index == 0) context.go(AppRoutes.home);
            if (index == 1) context.go(AppRoutes.favorites);
            if (index == 2) context.go(AppRoutes.profile);
          },
        ),
      ),
    );
  }
}