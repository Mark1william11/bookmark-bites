import 'package:bookmark_bites/src/data/services/local/db/app_db.dart';
import 'package:bookmark_bites/src/data/services/local/db/favorite_recipes_dao.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

// Provider to expose a single instance of the AppDatabase.
// We use @Riverpod(keepAlive: true) because the database connection
// should stay open for the entire lifecycle of the app.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}

// Provider to expose the DAO for our favorites table.
// It depends on the main database provider.
@riverpod
FavoriteRecipesDao favoriteRecipesDao(FavoriteRecipesDaoRef ref) {
  return FavoriteRecipesDao(ref.watch(appDatabaseProvider));
}