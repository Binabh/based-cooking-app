import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file, logStatements: true);
  });
}

class Recipes extends Table {
  TextColumn get filename => text()();
  TextColumn get title => text()();
  TextColumn get tags => text()();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {filename};
}

@DriftDatabase(tables: [Recipes], daos: [RecipeDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}

@DriftAccessor(tables: [Recipes])
class RecipeDao extends DatabaseAccessor<AppDatabase> with _$RecipeDaoMixin {
  RecipeDao(AppDatabase attachedDatabase) : super(attachedDatabase);
  Stream<List<Recipe>> watchAllRecipes(String title, String tag) =>
      (select(recipes)
            ..where((tbl) => tbl.title.contains(title))
            ..where((tbl) => tbl.tags.contains(tag)))
          .watch();
  Future<List<Recipe>> getAllRecipes() => select(recipes).get();
  Future insertRecipe(RecipesCompanion recipe) =>
      into(recipes).insert(recipe, mode: InsertMode.replace);
  Future deleteRecipe(Recipe recipe) => delete(recipes).delete(recipe);
}

final AppDatabase db = AppDatabase();
