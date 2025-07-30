import 'package:bookmark_bites/src/data/models/recipe.dart';
import 'package:bookmark_bites/src/data/models/recipe_category.dart';
import 'package:bookmark_bites/src/data/services/local/db/app_db.dart'; // Import FavoriteRecipe

abstract class RecipeRepository {
  // Remote API methods
  Future<List<RecipeCategory>> getRecipeCategories();
  Future<List<RecipeSummary>> getRecipesByCategory(String categoryName);
  Future<Recipe> getRecipeById(String id);

  // Local Database methods
  Stream<List<FavoriteRecipe>> getFavoritesStream();
  Stream<bool> isFavoriteStream(String id);
  Future<void> addFavorite(Recipe recipe);
  Future<void> removeFavorite(String id);
}