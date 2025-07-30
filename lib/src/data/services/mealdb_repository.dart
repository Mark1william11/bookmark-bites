import 'dart:convert';
import 'package:bookmark_bites/src/data/models/recipe.dart';
import 'package:bookmark_bites/src/data/models/recipe_category.dart';
import 'package:bookmark_bites/src/data/repositories/recipe_repository.dart';
import 'package:bookmark_bites/src/data/services/api_service.dart';
import 'package:bookmark_bites/src/data/services/local/db/app_db.dart';
import 'package:bookmark_bites/src/data/services/local/db/favorite_recipes_dao.dart';
import 'package:bookmark_bites/src/utils/constants.dart';

class MealDBRepository implements RecipeRepository {
  MealDBRepository(this._apiService, this._dao);

  final ApiService _apiService;
  final FavoriteRecipesDao _dao;

  // Helper method to convert a database object to a model object
  Recipe _mapFavoriteToRecipe(FavoriteRecipe fav) {
    // Decode the JSON string back into a list of ingredients
    final List<dynamic> ingredientsJson = jsonDecode(fav.ingredientsJson);
    final ingredients = ingredientsJson
        .map((i) => Ingredient(name: i['name'], measure: i['measure']))
        .toList();

    return Recipe(
      idMeal: fav.id,
      strMeal: fav.name,
      strMealThumb: fav.imageUrl,
      strInstructions: fav.instructions,
      strCategory: fav.category,
      strArea: fav.area,
      ingredients: ingredients,
      strDrinkAlternate: null, // These fields are not stored locally
      strTags: null,
      strYoutube: null,
    );
  }

  @override
  Future<List<RecipeCategory>> getRecipeCategories() async {
    final data = await _apiService.get(ApiConstants.categories);
    final response = CategoriesResponse.fromJson(data);
    return response.categories;
  }

  @override
  Future<List<RecipeSummary>> getRecipesByCategory(String categoryName) async {
    final data = await _apiService.get(
      ApiConstants.filterByCategory,
      queryParameters: {'c': categoryName},
    );
    final response = MealsResponse.fromJson(data);
    return response.meals;
  }

  // --- THE MAIN FIX IS HERE ---
  @override
  Future<Recipe> getRecipeById(String id) async {
    // 1. Try to get the recipe from the local database first.
    final favorite = await _dao.getFavorite(id);

    if (favorite != null) {
      // 2. If it exists locally, map it to our model and return it.
      return _mapFavoriteToRecipe(favorite);
    } else {
      // 3. If not, fetch from the API as before.
      final data = await _apiService.get(
        ApiConstants.lookupRecipeById,
        queryParameters: {'i': id},
      );
      final response = FullRecipeResponse.fromJson(data);
      if (response.meals.isEmpty) {
        throw Exception('Recipe not found');
      }
      return response.meals.first;
    }
  }

  @override
  Future<void> addFavorite(Recipe recipe) {
    return _dao.addFavorite(recipe);
  }

  @override
  Stream<List<FavoriteRecipe>> getFavoritesStream() {
    return _dao.watchFavorites();
  }

  @override
  Stream<bool> isFavoriteStream(String id) {
    return _dao.isFavorite(id);
  }

  @override
  Future<void> removeFavorite(String id) {
    return _dao.removeFavorite(id);
  }
}