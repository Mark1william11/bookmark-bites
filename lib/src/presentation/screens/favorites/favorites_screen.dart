import 'package:bookmark_bites/src/logic/providers/recipe_providers.dart';
import 'package:bookmark_bites/src/presentation/widgets/recipe_card.dart';
import 'package:bookmark_bites/src/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return favoritesAsync.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
              child: Text(
                'You have no favorite recipes yet.\nStart exploring and save some!',
                textAlign: TextAlign.center,
              ),
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
                imageUrl: recipe.imageUrl,
                name: recipe.name,
                // Pass the unique recipe ID as the heroTag here as well
                heroTag: 'recipe-${recipe.id}',
                onTap: () {
                  context.push(AppRoutes.recipeDetails(recipe.id));
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}