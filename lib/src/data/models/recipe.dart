import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

// Model for a recipe shown in a list (e.g., search results by category)
// This class is simple and can be fully generated.
@freezed
class RecipeSummary with _$RecipeSummary {
  const factory RecipeSummary({
    required String idMeal,
    required String strMeal,
    required String strMealThumb,
  }) = _RecipeSummary;

  factory RecipeSummary.fromJson(Map<String, dynamic> json) =>
      _$RecipeSummaryFromJson(json);
}

// Wrapper class for a list of recipe summaries
// This class is also simple and can be fully generated.
@freezed
class MealsResponse with _$MealsResponse {
  const factory MealsResponse({
    required List<RecipeSummary> meals,
  }) = _MealsResponse;

  factory MealsResponse.fromJson(Map<String, dynamic> json) =>
      _$MealsResponseFromJson(json);
}

// A simple model for an ingredient.
// It needs a standard fromJson factory so other classes can use it.
@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String name,
    required String measure,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

// Model for a full recipe with all details
// This class has a custom fromJson, so we don't use the generator for it.
@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String idMeal,
    required String strMeal,
    required String? strDrinkAlternate,
    required String? strCategory,
    required String? strArea,
    required String strInstructions,
    required String strMealThumb,
    required String? strTags,
    required String? strYoutube,
    required List<Ingredient> ingredients,
  }) = _Recipe;

  // The custom factory to handle the API's messy ingredient format.
  // This is the single source of truth for creating a Recipe object.
  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        // Here, we can't call Ingredient.fromJson because we don't have a map for it.
        // We create it directly.
        ingredients.add(Ingredient(name: ingredient, measure: measure ?? ''));
      }
    }
    return Recipe(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strDrinkAlternate: json['strDrinkAlternate'] as String?,
      strCategory: json['strCategory'] as String?,
      strArea: json['strArea'] as String?,
      strInstructions: json['strInstructions'] as String,
      strMealThumb: json['strMealThumb'] as String,
      strTags: json['strTags'] as String?,
      strYoutube: json['strYoutube'] as String?,
      ingredients: ingredients,
    );
  }
}

// Wrapper for the full recipe response.
// Because it contains a List<Recipe>, which has a custom fromJson,
// we MUST write this factory manually.
@freezed
class FullRecipeResponse with _$FullRecipeResponse {
    const factory FullRecipeResponse({
      required List<Recipe> meals,
    }) = _FullRecipeResponse;

    factory FullRecipeResponse.fromJson(Map<String, dynamic> json) {
      // Manually map over the 'meals' list and call our custom Recipe.fromJson for each item.
      return FullRecipeResponse(
        meals: (json['meals'] as List<dynamic>)
            .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
}