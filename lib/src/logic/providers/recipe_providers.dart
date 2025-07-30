import 'package:bookmark_bites/src/data/models/recipe.dart';
import 'package:bookmark_bites/src/data/models/recipe_category.dart';
import 'package:bookmark_bites/src/data/repositories/recipe_repository.dart';
import 'package:bookmark_bites/src/data/services/api_service.dart';
import 'package:bookmark_bites/src/data/services/local/db/app_db.dart';
import 'package:bookmark_bites/src/data/services/mealdb_repository.dart';
import 'package:bookmark_bites/src/logic/providers/database_providers.dart';
import 'package:bookmark_bites/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recipe_providers.g.dart';

// Provider for the Dio instance
@riverpod
Dio dio(DioRef ref) {
  return Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
}

// Provider for the ApiService
@riverpod
ApiService apiService(ApiServiceRef ref) {
  return ApiService(ref.watch(dioProvider));
}

// Provider for the RecipeRepository
@riverpod
RecipeRepository recipeRepository(RecipeRepositoryRef ref) {
  // Now providing both dependencies
  return MealDBRepository(
    ref.watch(apiServiceProvider),
    ref.watch(favoriteRecipesDaoProvider),
  );
}

// A FutureProvider to fetch the list of recipe categories
@riverpod
Future<List<RecipeCategory>> recipeCategories(RecipeCategoriesRef ref) {
  final recipeRepo = ref.watch(recipeRepositoryProvider);
  return recipeRepo.getRecipeCategories();
}

// A FutureProvider to fetch recipes by category. We use .family to pass in the category name.
// We will also fetch 'Seafood' as the default list for the home screen.
@riverpod
Future<List<RecipeSummary>> recipesByCategory(RecipesByCategoryRef ref, String category) {
  final recipeRepo = ref.watch(recipeRepositoryProvider);
  return recipeRepo.getRecipesByCategory(category);
}

// Provider to fetch a default list of recipes for the home screen
@riverpod
Future<List<RecipeSummary>> trendingRecipes(TrendingRecipesRef ref) {
  return ref.watch(recipesByCategoryProvider('Seafood').future);
}

// A FutureProvider to fetch a single recipe's details by its ID.
@riverpod
Future<Recipe> recipeById(RecipeByIdRef ref, String id) {
  final recipeRepo = ref.watch(recipeRepositoryProvider);
  return recipeRepo.getRecipeById(id);
}

@riverpod
Stream<bool> isFavorite(IsFavoriteRef ref, String id) {
  final recipeRepo = ref.watch(recipeRepositoryProvider);
  return recipeRepo.isFavoriteStream(id);
}

@riverpod
Stream<List<FavoriteRecipe>> favorites(FavoritesRef ref) {
  final recipeRepo = ref.watch(recipeRepositoryProvider);
  return recipeRepo.getFavoritesStream();
}