// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Recipe extends DataClass implements Insertable<Recipe> {
  final String filename;
  final String title;
  final String tags;
  final bool isFavourite;
  Recipe(
      {required this.filename,
      required this.title,
      required this.tags,
      required this.isFavourite});
  factory Recipe.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Recipe(
      filename: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}filename'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      tags: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tags'])!,
      isFavourite: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_favourite'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['filename'] = Variable<String>(filename);
    map['title'] = Variable<String>(title);
    map['tags'] = Variable<String>(tags);
    map['is_favourite'] = Variable<bool>(isFavourite);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      filename: Value(filename),
      title: Value(title),
      tags: Value(tags),
      isFavourite: Value(isFavourite),
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      filename: serializer.fromJson<String>(json['filename']),
      title: serializer.fromJson<String>(json['title']),
      tags: serializer.fromJson<String>(json['tags']),
      isFavourite: serializer.fromJson<bool>(json['isFavourite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'filename': serializer.toJson<String>(filename),
      'title': serializer.toJson<String>(title),
      'tags': serializer.toJson<String>(tags),
      'isFavourite': serializer.toJson<bool>(isFavourite),
    };
  }

  Recipe copyWith(
          {String? filename, String? title, String? tags, bool? isFavourite}) =>
      Recipe(
        filename: filename ?? this.filename,
        title: title ?? this.title,
        tags: tags ?? this.tags,
        isFavourite: isFavourite ?? this.isFavourite,
      );
  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('filename: $filename, ')
          ..write('title: $title, ')
          ..write('tags: $tags, ')
          ..write('isFavourite: $isFavourite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(filename, title, tags, isFavourite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.filename == this.filename &&
          other.title == this.title &&
          other.tags == this.tags &&
          other.isFavourite == this.isFavourite);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> filename;
  final Value<String> title;
  final Value<String> tags;
  final Value<bool> isFavourite;
  const RecipesCompanion({
    this.filename = const Value.absent(),
    this.title = const Value.absent(),
    this.tags = const Value.absent(),
    this.isFavourite = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String filename,
    required String title,
    required String tags,
    this.isFavourite = const Value.absent(),
  })  : filename = Value(filename),
        title = Value(title),
        tags = Value(tags);
  static Insertable<Recipe> custom({
    Expression<String>? filename,
    Expression<String>? title,
    Expression<String>? tags,
    Expression<bool>? isFavourite,
  }) {
    return RawValuesInsertable({
      if (filename != null) 'filename': filename,
      if (title != null) 'title': title,
      if (tags != null) 'tags': tags,
      if (isFavourite != null) 'is_favourite': isFavourite,
    });
  }

  RecipesCompanion copyWith(
      {Value<String>? filename,
      Value<String>? title,
      Value<String>? tags,
      Value<bool>? isFavourite}) {
    return RecipesCompanion(
      filename: filename ?? this.filename,
      title: title ?? this.title,
      tags: tags ?? this.tags,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (isFavourite.present) {
      map['is_favourite'] = Variable<bool>(isFavourite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('filename: $filename, ')
          ..write('title: $title, ')
          ..write('tags: $tags, ')
          ..write('isFavourite: $isFavourite')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _filenameMeta = const VerificationMeta('filename');
  @override
  late final GeneratedColumn<String?> filename = GeneratedColumn<String?>(
      'filename', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String?> tags = GeneratedColumn<String?>(
      'tags', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _isFavouriteMeta =
      const VerificationMeta('isFavourite');
  @override
  late final GeneratedColumn<bool?> isFavourite = GeneratedColumn<bool?>(
      'is_favourite', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_favourite IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [filename, title, tags, isFavourite];
  @override
  String get aliasedName => _alias ?? 'recipes';
  @override
  String get actualTableName => 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<Recipe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('filename')) {
      context.handle(_filenameMeta,
          filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta));
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('is_favourite')) {
      context.handle(
          _isFavouriteMeta,
          isFavourite.isAcceptableOrUnknown(
              data['is_favourite']!, _isFavouriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {filename};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Recipe.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final RecipeDao recipeDao = RecipeDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [recipes];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$RecipeDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecipesTable get recipes => attachedDatabase.recipes;
}
