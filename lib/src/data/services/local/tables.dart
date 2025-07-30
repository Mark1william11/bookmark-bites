import 'package:drift/drift.dart';

// Drift table classes are suffixed with "s" by convention.
// This table will store recipes that the user has marked as favorite.
@DataClassName('FavoriteRecipe')
class FavoriteRecipes extends Table {
  // We use the meal ID from the API as our primary key.
  // It's a text column because the API provides it as a string.
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get imageUrl => text()();
  TextColumn get instructions => text()();
  TextColumn get category => text().nullable()();
  TextColumn get area => text().nullable()();
  
  // We will store the list of ingredients as a single JSON encoded string.
  // This is a common strategy for storing complex lists in a SQL database.
  TextColumn get ingredientsJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}