import 'package:bookmark_bites/src/logic/providers/recipe_providers.dart';
import 'package:bookmark_bites/src/presentation/widgets/app_error_widget.dart';
import 'package:bookmark_bites/src/presentation/widgets/category_card.dart';
import 'package:bookmark_bites/src/presentation/widgets/recipe_card.dart';
import 'package:bookmark_bites/src/routing/app_routes.dart';
import 'package:bookmark_bites/src/utils/dio_exception_handler.dart';
import 'package:bookmark_bites/src/logic/providers/connectivity_provider.dart';
import 'package:bookmark_bites/src/presentation/widgets/offline_home_widget.dart';
import 'package:bookmark_bites/src/logic/providers/ui_providers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityProvider);

    // No Scaffold or AppBar needed here anymore!
    return connectivityStatus.when(
      data: (result) {
        if (result == ConnectivityResult.none) {
          return const OfflineHomeWidget();
        }
        return const _OnlineHomeView();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const _OnlineHomeView(),
    );
  }
}

class _OnlineHomeView extends ConsumerWidget {
  const _OnlineHomeView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(recipeCategoriesProvider);
    final trendingRecipesAsync = ref.watch(trendingRecipesProvider);

    // Watch our new UI state provider
    final hasAnimated = ref.watch(homeScreenHasAnimatedProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Categories', style: theme.textTheme.headlineMedium),
          ),
          categoriesAsync.when(
            data: (categories) => SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  // REMOVED the .animate() from the card itself
                  return CategoryCard(
                    imageUrl: category.strCategoryThumb,
                    name: category.strCategory,
                    onTap: () {
                      context.push(AppRoutes.category(category.strCategory));
                    },
                  );
                },
              ),
            // THE FIX: Animate the entire ListView once.
            ).animate(target: hasAnimated ? 1 : 0).fadeIn(delay: 200.ms),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) {
              final message = err is DioException ? DioExceptionHandler.getMessage(err) : 'An unexpected error occurred.';
              return AppErrorWidget(message: message, onRetry: () => ref.invalidate(recipeCategoriesProvider));
            },
          ),
          const SizedBox(height: 24),
          // Trending Recipes Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Trending Today', style: theme.textTheme.headlineMedium),
          ),
          const SizedBox(height: 16),
          trendingRecipesAsync.when(
            data: (recipes) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                // REMOVED the .animate() from the card itself
                return RecipeCard(
                  imageUrl: recipe.strMealThumb,
                  name: recipe.strMeal,
                  heroTag: 'recipe-${recipe.idMeal}',
                  onTap: () => context.push(AppRoutes.recipeDetails(recipe.idMeal)),
                );
              },
            // THE FIX: Animate the GridView once and set the state on completion.
            ).animate(
              target: hasAnimated ? 1 : 0,
              onComplete: (_) {
                // Once the animation is done, set the flag to true.
                ref.read(homeScreenHasAnimatedProvider.notifier).setHasAnimated();
              },
            ).fadeIn(delay: 400.ms),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) {
              final message = err is DioException ? DioExceptionHandler.getMessage(err) : 'An unexpected error occurred.';
              return AppErrorWidget(message: message, onRetry: () => ref.invalidate(trendingRecipesProvider));
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}