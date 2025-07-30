import 'dart:io';

import 'package:bookmark_bites/src/data/services/local/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_db.g.dart';

// This annotation tells Drift to generate a class called _$AppDatabase
// which will handle the database operations.
@DriftDatabase(tables: [FavoriteRecipes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // You can add database migration strategies here in the future.
}

// This function sets up the database file in the correct location
// on the device.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bookmark_bites.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}