import 'package:bookmark_bites/src/data/models/recipe.dart';
import 'package:bookmark_bites/src/logic/providers/recipe_providers.dart';
import 'package:bookmark_bites/src/presentation/widgets/info_chip.dart';
import 'package:bookmark_bites/src/presentation/widgets/ingredient_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bookmark_bites/src/presentation/widgets/app_error_widget.dart';
import 'package:bookmark_bites/src/utils/dio_exception_handler.dart';
import 'package:dio/dio.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeByIdProvider(recipeId));
    final theme = Theme.of(context);
    final isFavoriteAsync = ref.watch(isFavoriteProvider(recipeId));

    return Scaffold(
      floatingActionButton: isFavoriteAsync.when(
        data: (isFavorite) {
          return FloatingActionButton(
            onPressed: () {
              // We need the full recipe object to save it.
              final recipe = recipeAsync.value;
              if (recipe != null) {
                final repo = ref.read(recipeRepositoryProvider);
                if (isFavorite) {
                  repo.removeFavorite(recipeId);
                } else {
                  repo.addFavorite(recipe);
                }
              }
            },
            backgroundColor: theme.colorScheme.primary,
            child: Animate(
              // Use Animate to swap icons with a nice effect
              key: ValueKey(isFavorite), // A key is crucial for Animate to detect changes
              effects: const [
                ScaleEffect(duration: Duration(milliseconds: 300)),
                FadeEffect(duration: Duration(milliseconds: 300)),
              ],
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          );
        },
        loading: () => const SizedBox(), // Show nothing while loading
        error: (err, stack) {
          final message = err is DioException ? DioExceptionHandler.getMessage(err) : 'An unexpected error occurred.';
          return AppErrorWidget(
            message: message,
            // Invalidate the specific family provider to retry
            onRetry: () => ref.invalidate(recipeByIdProvider(recipeId)),
          );
        },
      ),
      body: recipeAsync.when(
        data: (recipe) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              stretch: true, // Adds a nice stretch effect on overscroll
              backgroundColor: theme.colorScheme.primary, // Collapsed background color
              foregroundColor: Colors.white, // Color of the back arrow and other icons
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                centerTitle: true,
                title: Text(
                  recipe.strMeal,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'recipe-$recipeId',
                      flightShuttleBuilder: (
                        flightContext,
                        animation,
                        flightDirection,
                        fromHeroContext,
                        toHeroContext,
                      ) {
                        // We return the destination hero's child, ensuring it's the same widget.
                        return toHeroContext.widget;
                      },
                      child: CachedNetworkImage(
                        imageUrl: recipe.strMealThumb,
                        fit: BoxFit.cover,placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                          stops: [0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // THE FIX: Added spacing for "breathing room".
                    const SizedBox(height: 24),
                    _buildInfoChips(recipe),
                    const SizedBox(height: 24),
                    _buildSectionTitle(theme, 'Ingredients'),
                    _buildIngredientsList(recipe.ingredients),
                    const SizedBox(height: 24),
                    _buildSectionTitle(theme, 'Instructions'),
                    // THE FIX: Call our new instructions formatter.
                    _buildInstructionsList(theme, recipe.strInstructions),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ).animate().fadeIn(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildInfoChips(Recipe recipe) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (recipe.strArea != null) InfoChip(label: recipe.strArea!, icon: Icons.public),
        if (recipe.strCategory != null) InfoChip(label: recipe.strCategory!, icon: Icons.category),
        if (recipe.strTags != null) ...recipe.strTags!.split(',').map((tag) => InfoChip(label: tag.trim())).toList(),
      ],
    ).animate().slideX(delay: 200.ms, begin: -1);
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.headlineSmall,
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildIngredientsList(List<Ingredient> ingredients) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return IngredientTile(
          measure: ingredient.measure,
          name: ingredient.name,
        ).animate().fadeIn(delay: (400 + index * 50).ms).slideX(begin: -0.5);
      },
    );
  }
  
  // THE FIX: A new widget to format instructions into a numbered list.
  Widget _buildInstructionsList(ThemeData theme, String instructions) {
    // The API uses \r\n to separate steps. We split by it.
    final steps = instructions.split('\r\n').where((s) => s.trim().isNotEmpty).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: List.generate(steps.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    steps[index].trim(),
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                ),
              ],
            ),
          );
        }).animate(interval: 100.ms).fadeIn(delay: 500.ms),
      ),
    );
  }
}