import 'package:bookmark_bites/src/logic/providers/recipe_providers.dart';
import 'package:bookmark_bites/src/presentation/widgets/app_error_widget.dart';
import 'package:bookmark_bites/src/presentation/widgets/recipe_card.dart';
import 'package:bookmark_bites/src/routing/app_routes.dart';
import 'package:bookmark_bites/src/utils/dio_exception_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryRecipesScreen extends ConsumerWidget {
  const CategoryRecipesScreen({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use our existing provider, passing in the category name
    final recipesAsync = ref.watch(recipesByCategoryProvider(categoryName));

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: recipesAsync.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
              child: Text('No recipes found in this category.'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(
                imageUrl: recipe.strMealThumb,
                name: recipe.strMeal,
                heroTag: 'category-recipe-${recipe.idMeal}', // Use a unique hero prefix
                onTap: () {
                  context.push(AppRoutes.recipeDetails(recipe.idMeal));
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final message = err is DioException ? DioExceptionHandler.getMessage(err) : 'An unexpected error occurred.';
          return AppErrorWidget(
            message: message,
            onRetry: () => ref.invalidate(recipesByCategoryProvider(categoryName)),
          );
        },
      ),
    );
  }
}