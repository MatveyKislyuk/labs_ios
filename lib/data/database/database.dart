import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

@DataClassName('Category')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Task')
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(Constant(false))();
  BoolColumn get isFavourite => boolean().withDefault(Constant(false))();
  TextColumn get categoryId => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Categories, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Future<List<Category>> getAllCategories() => select(categories).get();
  Future<void> insertCategory(CategoriesCompanion category) => into(categories).insert(category);
  Future<void> updateCategory(CategoriesCompanion category) => update(categories).replace(category);
  Future<void> deleteCategory(String id) => (delete(categories)..where((t) => t.id.equals(id))).go();

  Future<List<Task>> getTasksByCategoryId(String categoryId) =>
      (select(tasks)..where((t) => t.categoryId.equals(categoryId))).get();
  Future<void> insertTask(TasksCompanion task) => into(tasks).insert(task);
  Future<void> updateTask(TasksCompanion task) => update(tasks).replace(task);
  Future<void> deleteTask(String id) => (delete(tasks)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db4.sqlite'));
    return NativeDatabase(file);
  });
}