import 'dart:convert';
import 'package:bookmark_bites/src/data/models/recipe.dart' as model;
import 'package:bookmark_bites/src/data/services/local/db/app_db.dart';
import 'package:bookmark_bites/src/data/services/local/tables.dart';
import 'package:drift/drift.dart';

part 'favorite_recipes_dao.g.dart';

// The @DriftAccessor annotation tells Drift to generate a class that will implement
// the methods in this class by talking to the database.
@DriftAccessor(tables: [FavoriteRecipes])
class FavoriteRecipesDao extends DatabaseAccessor<AppDatabase> with _$FavoriteRecipesDaoMixin {
  FavoriteRecipesDao(super.db);

  // Watches the favorites table for changes and returns a stream of all favorites.
  // This is powerful because our UI can listen to this stream and update automatically.
  Stream<List<FavoriteRecipe>> watchFavorites() => select(favoriteRecipes).watch();

  // Watches a single recipe by its ID to see if it's a favorite.
  Stream<bool> isFavorite(String id) {
    return (select(favoriteRecipes)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull()
        .map((recipe) => recipe != null);
  }

  // Adds a new recipe to the favorites table.
  Future<void> addFavorite(model.Recipe recipe) {
    return into(favoriteRecipes).insert(
      FavoriteRecipesCompanion.insert(
        id: recipe.idMeal,
        name: recipe.strMeal,
        imageUrl: recipe.strMealThumb,
        instructions: recipe.strInstructions,
        category: Value(recipe.strCategory),
        area: Value(recipe.strArea),
        // Encode the ingredients list into a JSON string for storage.
        ingredientsJson: jsonEncode(recipe.ingredients.map((i) => {'name': i.name, 'measure': i.measure}).toList()),
      ),
      mode: InsertMode.replace, // If a recipe with the same ID exists, overwrite it.
    );
  }

  // Removes a recipe from the favorites table.
  Future<void> removeFavorite(String id) {
    return (delete(favoriteRecipes)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<FavoriteRecipe?> getFavorite(String id) {
    return (select(favoriteRecipes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}