import 'package:bookmark_bites/src/logic/providers/auth_providers.dart';
import 'package:bookmark_bites/src/presentation/screens/auth/login_screen.dart';
import 'package:bookmark_bites/src/presentation/screens/auth/register_screen.dart';
import 'package:bookmark_bites/src/presentation/screens/favorites/favorites_screen.dart';
import 'package:bookmark_bites/src/presentation/screens/home/home_screen.dart';
import 'package:bookmark_bites/src/presentation/screens/recipe_detail/recipe_detail_screen.dart';
import 'package:bookmark_bites/src/presentation/widgets/main_scaffold.dart';
import 'package:bookmark_bites/src/presentation/screens/category_recipes/category_recipes_screen.dart';
import 'package:bookmark_bites/src/routing/app_routes.dart';
import 'package:bookmark_bites/src/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      // THE FIX: Use a ShellRoute for screens with the bottom nav bar
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.favorites,
            pageBuilder: (context, state) => const NoTransitionPage(child: FavoritesScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      // Standalone routes (no bottom nav bar)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/category/:categoryName',
        builder: (context, state) {
          final categoryName = state.pathParameters['categoryName']!;
          return CategoryRecipesScreen(categoryName: categoryName);
        },
      ),
      GoRoute(
        path: '/recipe/:id', // Note the path is now top-level
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RecipeDetailScreen(recipeId: id),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // Use the auth state to determine redirection.
      return authState.when(
        data: (user) {
          final isLoggedIn = user != null;
          final onAuthScreen = state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.register;

          if (isLoggedIn && onAuthScreen) {
            return AppRoutes.home;
          }

          if (!isLoggedIn && !onAuthScreen) {
            return AppRoutes.login;
          }

          return null;
        },
        loading: () => null,
        error: (_, __) => null,
      );
    },
    // We get the stream directly from the provider, not from the AsyncValue.
    refreshListenable: GoRouterRefreshStream(ref.watch(authStateChangesProvider.stream)),
  );
});

// A utility class to convert a Stream into a Listenable for GoRouter.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}