// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorBgMeta = const VerificationMeta(
    'colorBg',
  );
  @override
  late final GeneratedColumn<String> colorBg = GeneratedColumn<String>(
    'color_bg',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorFgMeta = const VerificationMeta(
    'colorFg',
  );
  @override
  late final GeneratedColumn<String> colorFg = GeneratedColumn<String>(
    'color_fg',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    name,
    icon,
    colorBg,
    colorFg,
    sortOrder,
    isDefault,
    isLocked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_bg')) {
      context.handle(
        _colorBgMeta,
        colorBg.isAcceptableOrUnknown(data['color_bg']!, _colorBgMeta),
      );
    } else if (isInserting) {
      context.missing(_colorBgMeta);
    }
    if (data.containsKey('color_fg')) {
      context.handle(
        _colorFgMeta,
        colorFg.isAcceptableOrUnknown(data['color_fg']!, _colorFgMeta),
      );
    } else if (isInserting) {
      context.missing(_colorFgMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorBg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_bg'],
      )!,
      colorFg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_fg'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String type;
  final String name;
  final String icon;
  final String colorBg;
  final String colorFg;
  final int sortOrder;
  final bool isDefault;
  final bool isLocked;
  const CategoryRow({
    required this.id,
    required this.type,
    required this.name,
    required this.icon,
    required this.colorBg,
    required this.colorFg,
    required this.sortOrder,
    required this.isDefault,
    required this.isLocked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color_bg'] = Variable<String>(colorBg);
    map['color_fg'] = Variable<String>(colorFg);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_locked'] = Variable<bool>(isLocked);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      icon: Value(icon),
      colorBg: Value(colorBg),
      colorFg: Value(colorFg),
      sortOrder: Value(sortOrder),
      isDefault: Value(isDefault),
      isLocked: Value(isLocked),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      colorBg: serializer.fromJson<String>(json['colorBg']),
      colorFg: serializer.fromJson<String>(json['colorFg']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'colorBg': serializer.toJson<String>(colorBg),
      'colorFg': serializer.toJson<String>(colorFg),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isLocked': serializer.toJson<bool>(isLocked),
    };
  }

  CategoryRow copyWith({
    int? id,
    String? type,
    String? name,
    String? icon,
    String? colorBg,
    String? colorFg,
    int? sortOrder,
    bool? isDefault,
    bool? isLocked,
  }) => CategoryRow(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorBg: colorBg ?? this.colorBg,
    colorFg: colorFg ?? this.colorFg,
    sortOrder: sortOrder ?? this.sortOrder,
    isDefault: isDefault ?? this.isDefault,
    isLocked: isLocked ?? this.isLocked,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorBg: data.colorBg.present ? data.colorBg.value : this.colorBg,
      colorFg: data.colorFg.present ? data.colorFg.value : this.colorFg,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorBg: $colorBg, ')
          ..write('colorFg: $colorFg, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDefault: $isDefault, ')
          ..write('isLocked: $isLocked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    name,
    icon,
    colorBg,
    colorFg,
    sortOrder,
    isDefault,
    isLocked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorBg == this.colorBg &&
          other.colorFg == this.colorFg &&
          other.sortOrder == this.sortOrder &&
          other.isDefault == this.isDefault &&
          other.isLocked == this.isLocked);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> name;
  final Value<String> icon;
  final Value<String> colorBg;
  final Value<String> colorFg;
  final Value<int> sortOrder;
  final Value<bool> isDefault;
  final Value<bool> isLocked;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorBg = const Value.absent(),
    this.colorFg = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isLocked = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String name,
    required String icon,
    required String colorBg,
    required String colorFg,
    this.sortOrder = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isLocked = const Value.absent(),
  }) : type = Value(type),
       name = Value(name),
       icon = Value(icon),
       colorBg = Value(colorBg),
       colorFg = Value(colorFg);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? colorBg,
    Expression<String>? colorFg,
    Expression<int>? sortOrder,
    Expression<bool>? isDefault,
    Expression<bool>? isLocked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorBg != null) 'color_bg': colorBg,
      if (colorFg != null) 'color_fg': colorFg,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDefault != null) 'is_default': isDefault,
      if (isLocked != null) 'is_locked': isLocked,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? name,
    Value<String>? icon,
    Value<String>? colorBg,
    Value<String>? colorFg,
    Value<int>? sortOrder,
    Value<bool>? isDefault,
    Value<bool>? isLocked,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorBg: colorBg ?? this.colorBg,
      colorFg: colorFg ?? this.colorFg,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorBg.present) {
      map['color_bg'] = Variable<String>(colorBg.value);
    }
    if (colorFg.present) {
      map['color_fg'] = Variable<String>(colorFg.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorBg: $colorBg, ')
          ..write('colorFg: $colorFg, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDefault: $isDefault, ')
          ..write('isLocked: $isLocked')
          ..write(')'))
        .toString();
  }
}

class $WalletsTable extends Wallets with TableInfo<$WalletsTable, WalletRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, sortOrder, isArchived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class WalletRow extends DataClass implements Insertable<WalletRow> {
  final int id;
  final String name;
  final String icon;
  final int sortOrder;
  final bool isArchived;
  const WalletRow({
    required this.id,
    required this.name,
    required this.icon,
    required this.sortOrder,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      sortOrder: Value(sortOrder),
      isArchived: Value(isArchived),
    );
  }

  factory WalletRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  WalletRow copyWith({
    int? id,
    String? name,
    String? icon,
    int? sortOrder,
    bool? isArchived,
  }) => WalletRow(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    isArchived: isArchived ?? this.isArchived,
  );
  WalletRow copyWithCompanion(WalletsCompanion data) {
    return WalletRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, sortOrder, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.isArchived == this.isArchived);
}

class WalletsCompanion extends UpdateCompanion<WalletRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> sortOrder;
  final Value<bool> isArchived;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  WalletsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon);
  static Insertable<WalletRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  WalletsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? sortOrder,
    Value<bool>? isArchived,
  }) {
    return WalletsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $RecurringRulesTable extends RecurringRules
    with TableInfo<$RecurringRulesTable, RecurringRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wallets (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta(
    'dayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextRunAtMeta = const VerificationMeta(
    'nextRunAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRunAt = GeneratedColumn<DateTime>(
    'next_run_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    amountCents,
    categoryId,
    walletId,
    note,
    frequency,
    dayOfMonth,
    nextRunAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringRuleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
        _dayOfMonthMeta,
        dayOfMonth.isAcceptableOrUnknown(
          data['day_of_month']!,
          _dayOfMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dayOfMonthMeta);
    }
    if (data.containsKey('next_run_at')) {
      context.handle(
        _nextRunAtMeta,
        nextRunAt.isAcceptableOrUnknown(data['next_run_at']!, _nextRunAtMeta),
      );
    } else if (isInserting) {
      context.missing(_nextRunAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringRuleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      dayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_month'],
      )!,
      nextRunAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_run_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $RecurringRulesTable createAlias(String alias) {
    return $RecurringRulesTable(attachedDatabase, alias);
  }
}

class RecurringRuleRow extends DataClass
    implements Insertable<RecurringRuleRow> {
  final int id;
  final String type;
  final int amountCents;
  final int categoryId;
  final int walletId;
  final String? note;
  final String frequency;
  final int dayOfMonth;
  final DateTime nextRunAt;
  final bool isActive;
  const RecurringRuleRow({
    required this.id,
    required this.type,
    required this.amountCents,
    required this.categoryId,
    required this.walletId,
    this.note,
    required this.frequency,
    required this.dayOfMonth,
    required this.nextRunAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['amount_cents'] = Variable<int>(amountCents);
    map['category_id'] = Variable<int>(categoryId);
    map['wallet_id'] = Variable<int>(walletId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['frequency'] = Variable<String>(frequency);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    map['next_run_at'] = Variable<DateTime>(nextRunAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RecurringRulesCompanion toCompanion(bool nullToAbsent) {
    return RecurringRulesCompanion(
      id: Value(id),
      type: Value(type),
      amountCents: Value(amountCents),
      categoryId: Value(categoryId),
      walletId: Value(walletId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      frequency: Value(frequency),
      dayOfMonth: Value(dayOfMonth),
      nextRunAt: Value(nextRunAt),
      isActive: Value(isActive),
    );
  }

  factory RecurringRuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringRuleRow(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      walletId: serializer.fromJson<int>(json['walletId']),
      note: serializer.fromJson<String?>(json['note']),
      frequency: serializer.fromJson<String>(json['frequency']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      nextRunAt: serializer.fromJson<DateTime>(json['nextRunAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'amountCents': serializer.toJson<int>(amountCents),
      'categoryId': serializer.toJson<int>(categoryId),
      'walletId': serializer.toJson<int>(walletId),
      'note': serializer.toJson<String?>(note),
      'frequency': serializer.toJson<String>(frequency),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'nextRunAt': serializer.toJson<DateTime>(nextRunAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  RecurringRuleRow copyWith({
    int? id,
    String? type,
    int? amountCents,
    int? categoryId,
    int? walletId,
    Value<String?> note = const Value.absent(),
    String? frequency,
    int? dayOfMonth,
    DateTime? nextRunAt,
    bool? isActive,
  }) => RecurringRuleRow(
    id: id ?? this.id,
    type: type ?? this.type,
    amountCents: amountCents ?? this.amountCents,
    categoryId: categoryId ?? this.categoryId,
    walletId: walletId ?? this.walletId,
    note: note.present ? note.value : this.note,
    frequency: frequency ?? this.frequency,
    dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    nextRunAt: nextRunAt ?? this.nextRunAt,
    isActive: isActive ?? this.isActive,
  );
  RecurringRuleRow copyWithCompanion(RecurringRulesCompanion data) {
    return RecurringRuleRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      note: data.note.present ? data.note.value : this.note,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      dayOfMonth: data.dayOfMonth.present
          ? data.dayOfMonth.value
          : this.dayOfMonth,
      nextRunAt: data.nextRunAt.present ? data.nextRunAt.value : this.nextRunAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRuleRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('walletId: $walletId, ')
          ..write('note: $note, ')
          ..write('frequency: $frequency, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('nextRunAt: $nextRunAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    amountCents,
    categoryId,
    walletId,
    note,
    frequency,
    dayOfMonth,
    nextRunAt,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringRuleRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.amountCents == this.amountCents &&
          other.categoryId == this.categoryId &&
          other.walletId == this.walletId &&
          other.note == this.note &&
          other.frequency == this.frequency &&
          other.dayOfMonth == this.dayOfMonth &&
          other.nextRunAt == this.nextRunAt &&
          other.isActive == this.isActive);
}

class RecurringRulesCompanion extends UpdateCompanion<RecurringRuleRow> {
  final Value<int> id;
  final Value<String> type;
  final Value<int> amountCents;
  final Value<int> categoryId;
  final Value<int> walletId;
  final Value<String?> note;
  final Value<String> frequency;
  final Value<int> dayOfMonth;
  final Value<DateTime> nextRunAt;
  final Value<bool> isActive;
  const RecurringRulesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.note = const Value.absent(),
    this.frequency = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.nextRunAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  RecurringRulesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required int amountCents,
    required int categoryId,
    required int walletId,
    this.note = const Value.absent(),
    this.frequency = const Value.absent(),
    required int dayOfMonth,
    required DateTime nextRunAt,
    this.isActive = const Value.absent(),
  }) : type = Value(type),
       amountCents = Value(amountCents),
       categoryId = Value(categoryId),
       walletId = Value(walletId),
       dayOfMonth = Value(dayOfMonth),
       nextRunAt = Value(nextRunAt);
  static Insertable<RecurringRuleRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? amountCents,
    Expression<int>? categoryId,
    Expression<int>? walletId,
    Expression<String>? note,
    Expression<String>? frequency,
    Expression<int>? dayOfMonth,
    Expression<DateTime>? nextRunAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amountCents != null) 'amount_cents': amountCents,
      if (categoryId != null) 'category_id': categoryId,
      if (walletId != null) 'wallet_id': walletId,
      if (note != null) 'note': note,
      if (frequency != null) 'frequency': frequency,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (nextRunAt != null) 'next_run_at': nextRunAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  RecurringRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<int>? amountCents,
    Value<int>? categoryId,
    Value<int>? walletId,
    Value<String?>? note,
    Value<String>? frequency,
    Value<int>? dayOfMonth,
    Value<DateTime>? nextRunAt,
    Value<bool>? isActive,
  }) {
    return RecurringRulesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amountCents: amountCents ?? this.amountCents,
      categoryId: categoryId ?? this.categoryId,
      walletId: walletId ?? this.walletId,
      note: note ?? this.note,
      frequency: frequency ?? this.frequency,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      nextRunAt: nextRunAt ?? this.nextRunAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (nextRunAt.present) {
      map['next_run_at'] = Variable<DateTime>(nextRunAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRulesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('walletId: $walletId, ')
          ..write('note: $note, ')
          ..write('frequency: $frequency, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('nextRunAt: $nextRunAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wallets (id)',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurringRuleIdMeta = const VerificationMeta(
    'recurringRuleId',
  );
  @override
  late final GeneratedColumn<int> recurringRuleId = GeneratedColumn<int>(
    'recurring_rule_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurring_rules (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    amountCents,
    categoryId,
    walletId,
    occurredAt,
    note,
    receiptPath,
    recurringRuleId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    if (data.containsKey('recurring_rule_id')) {
      context.handle(
        _recurringRuleIdMeta,
        recurringRuleId.isAcceptableOrUnknown(
          data['recurring_rule_id']!,
          _recurringRuleIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
      recurringRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurring_rule_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TxRow extends DataClass implements Insertable<TxRow> {
  final int id;
  final String type;
  final int amountCents;
  final int categoryId;
  final int walletId;
  final DateTime occurredAt;
  final String? note;
  final String? receiptPath;
  final int? recurringRuleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TxRow({
    required this.id,
    required this.type,
    required this.amountCents,
    required this.categoryId,
    required this.walletId,
    required this.occurredAt,
    this.note,
    this.receiptPath,
    this.recurringRuleId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['amount_cents'] = Variable<int>(amountCents);
    map['category_id'] = Variable<int>(categoryId);
    map['wallet_id'] = Variable<int>(walletId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    if (!nullToAbsent || recurringRuleId != null) {
      map['recurring_rule_id'] = Variable<int>(recurringRuleId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      type: Value(type),
      amountCents: Value(amountCents),
      categoryId: Value(categoryId),
      walletId: Value(walletId),
      occurredAt: Value(occurredAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      recurringRuleId: recurringRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringRuleId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TxRow(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      walletId: serializer.fromJson<int>(json['walletId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      note: serializer.fromJson<String?>(json['note']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      recurringRuleId: serializer.fromJson<int?>(json['recurringRuleId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'amountCents': serializer.toJson<int>(amountCents),
      'categoryId': serializer.toJson<int>(categoryId),
      'walletId': serializer.toJson<int>(walletId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'note': serializer.toJson<String?>(note),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'recurringRuleId': serializer.toJson<int?>(recurringRuleId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TxRow copyWith({
    int? id,
    String? type,
    int? amountCents,
    int? categoryId,
    int? walletId,
    DateTime? occurredAt,
    Value<String?> note = const Value.absent(),
    Value<String?> receiptPath = const Value.absent(),
    Value<int?> recurringRuleId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TxRow(
    id: id ?? this.id,
    type: type ?? this.type,
    amountCents: amountCents ?? this.amountCents,
    categoryId: categoryId ?? this.categoryId,
    walletId: walletId ?? this.walletId,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note.present ? note.value : this.note,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    recurringRuleId: recurringRuleId.present
        ? recurringRuleId.value
        : this.recurringRuleId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TxRow copyWithCompanion(TransactionsCompanion data) {
    return TxRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      note: data.note.present ? data.note.value : this.note,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
      recurringRuleId: data.recurringRuleId.present
          ? data.recurringRuleId.value
          : this.recurringRuleId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TxRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('walletId: $walletId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    amountCents,
    categoryId,
    walletId,
    occurredAt,
    note,
    receiptPath,
    recurringRuleId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TxRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.amountCents == this.amountCents &&
          other.categoryId == this.categoryId &&
          other.walletId == this.walletId &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.receiptPath == this.receiptPath &&
          other.recurringRuleId == this.recurringRuleId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TxRow> {
  final Value<int> id;
  final Value<String> type;
  final Value<int> amountCents;
  final Value<int> categoryId;
  final Value<int> walletId;
  final Value<DateTime> occurredAt;
  final Value<String?> note;
  final Value<String?> receiptPath;
  final Value<int?> recurringRuleId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.recurringRuleId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required int amountCents,
    required int categoryId,
    required int walletId,
    required DateTime occurredAt,
    this.note = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.recurringRuleId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : type = Value(type),
       amountCents = Value(amountCents),
       categoryId = Value(categoryId),
       walletId = Value(walletId),
       occurredAt = Value(occurredAt);
  static Insertable<TxRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? amountCents,
    Expression<int>? categoryId,
    Expression<int>? walletId,
    Expression<DateTime>? occurredAt,
    Expression<String>? note,
    Expression<String>? receiptPath,
    Expression<int>? recurringRuleId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amountCents != null) 'amount_cents': amountCents,
      if (categoryId != null) 'category_id': categoryId,
      if (walletId != null) 'wallet_id': walletId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (note != null) 'note': note,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (recurringRuleId != null) 'recurring_rule_id': recurringRuleId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<int>? amountCents,
    Value<int>? categoryId,
    Value<int>? walletId,
    Value<DateTime>? occurredAt,
    Value<String?>? note,
    Value<String?>? receiptPath,
    Value<int?>? recurringRuleId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amountCents: amountCents ?? this.amountCents,
      categoryId: categoryId ?? this.categoryId,
      walletId: walletId ?? this.walletId,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      receiptPath: receiptPath ?? this.receiptPath,
      recurringRuleId: recurringRuleId ?? this.recurringRuleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (recurringRuleId.present) {
      map['recurring_rule_id'] = Variable<int>(recurringRuleId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('walletId: $walletId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('month'),
  );
  static const VerificationMeta _limitCentsMeta = const VerificationMeta(
    'limitCents',
  );
  @override
  late final GeneratedColumn<int> limitCents = GeneratedColumn<int>(
    'limit_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    period,
    limitCents,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('limit_cents')) {
      context.handle(
        _limitCentsMeta,
        limitCents.isAcceptableOrUnknown(data['limit_cents']!, _limitCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_limitCentsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      limitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final int id;
  final int? categoryId;
  final String period;
  final int limitCents;
  final DateTime createdAt;
  const BudgetRow({
    required this.id,
    this.categoryId,
    required this.period,
    required this.limitCents,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['period'] = Variable<String>(period);
    map['limit_cents'] = Variable<int>(limitCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      period: Value(period),
      limitCents: Value(limitCents),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      period: serializer.fromJson<String>(json['period']),
      limitCents: serializer.fromJson<int>(json['limitCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int?>(categoryId),
      'period': serializer.toJson<String>(period),
      'limitCents': serializer.toJson<int>(limitCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BudgetRow copyWith({
    int? id,
    Value<int?> categoryId = const Value.absent(),
    String? period,
    int? limitCents,
    DateTime? createdAt,
  }) => BudgetRow(
    id: id ?? this.id,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    period: period ?? this.period,
    limitCents: limitCents ?? this.limitCents,
    createdAt: createdAt ?? this.createdAt,
  );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      period: data.period.present ? data.period.value : this.period,
      limitCents: data.limitCents.present
          ? data.limitCents.value
          : this.limitCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('period: $period, ')
          ..write('limitCents: $limitCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, period, limitCents, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.period == this.period &&
          other.limitCents == this.limitCents &&
          other.createdAt == this.createdAt);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<int> id;
  final Value<int?> categoryId;
  final Value<String> period;
  final Value<int> limitCents;
  final Value<DateTime> createdAt;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.period = const Value.absent(),
    this.limitCents = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.period = const Value.absent(),
    required int limitCents,
    this.createdAt = const Value.absent(),
  }) : limitCents = Value(limitCents);
  static Insertable<BudgetRow> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? period,
    Expression<int>? limitCents,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (period != null) 'period': period,
      if (limitCents != null) 'limit_cents': limitCents,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<int?>? categoryId,
    Value<String>? period,
    Value<int>? limitCents,
    Value<DateTime>? createdAt,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      period: period ?? this.period,
      limitCents: limitCents ?? this.limitCents,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (limitCents.present) {
      map['limit_cents'] = Variable<int>(limitCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('period: $period, ')
          ..write('limitCents: $limitCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $RecurringRulesTable recurringRules = $RecurringRulesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final Index idxTxOccurred = Index(
    'idx_tx_occurred',
    'CREATE INDEX idx_tx_occurred ON transactions (occurred_at)',
  );
  late final Index idxTxCatOccurred = Index(
    'idx_tx_cat_occurred',
    'CREATE INDEX idx_tx_cat_occurred ON transactions (category_id, occurred_at)',
  );
  late final Index idxTxTypeOccurred = Index(
    'idx_tx_type_occurred',
    'CREATE INDEX idx_tx_type_occurred ON transactions (type, occurred_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    wallets,
    recurringRules,
    transactions,
    budgets,
    idxTxOccurred,
    idxTxCatOccurred,
    idxTxTypeOccurred,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String type,
  required String name,
  required String icon,
  required String colorBg,
  required String colorFg,
  Value<int> sortOrder,
  Value<bool> isDefault,
  Value<bool> isLocked,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> type,
  Value<String> name,
  Value<String> icon,
  Value<String> colorBg,
  Value<String> colorFg,
  Value<int> sortOrder,
  Value<bool> isDefault,
  Value<bool> isLocked,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecurringRulesTable, List<RecurringRuleRow>>
  _recurringRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurringRules,
    aliasName: 'categories__id__recurring_rules__category_id',
  );

  $$RecurringRulesTableProcessedTableManager get recurringRulesRefs {
    final manager = $$RecurringRulesTableTableManager(
      $_db,
      $_db.recurringRules,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurringRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<TxRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetsTable, List<BudgetRow>> _budgetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.budgets,
    aliasName: 'categories__id__budgets__category_id',
  );

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorBg => $composableBuilder(
    column: $table.colorBg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorFg => $composableBuilder(
    column: $table.colorFg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recurringRulesRefs(
    Expression<bool> Function($$RecurringRulesTableFilterComposer f) f,
  ) {
    final $$RecurringRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableFilterComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetsRefs(
    Expression<bool> Function($$BudgetsTableFilterComposer f) f,
  ) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorBg => $composableBuilder(
    column: $table.colorBg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorFg => $composableBuilder(
    column: $table.colorFg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get colorBg =>
      $composableBuilder(column: $table.colorBg, builder: (column) => column);

  GeneratedColumn<String> get colorFg =>
      $composableBuilder(column: $table.colorFg, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  Expression<T> recurringRulesRefs<T extends Object>(
    Expression<T> Function($$RecurringRulesTableAnnotationComposer a) f,
  ) {
    final $$RecurringRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({
            bool recurringRulesRefs,
            bool transactionsRefs,
            bool budgetsRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> colorBg = const Value.absent(),
                Value<String> colorFg = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                type: type,
                name: name,
                icon: icon,
                colorBg: colorBg,
                colorFg: colorFg,
                sortOrder: sortOrder,
                isDefault: isDefault,
                isLocked: isLocked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String name,
                required String icon,
                required String colorBg,
                required String colorFg,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                type: type,
                name: name,
                icon: icon,
                colorBg: colorBg,
                colorFg: colorFg,
                sortOrder: sortOrder,
                isDefault: isDefault,
                isLocked: isLocked,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recurringRulesRefs = false,
                transactionsRefs = false,
                budgetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurringRulesRefs) db.recurringRules,
                    if (transactionsRefs) db.transactions,
                    if (budgetsRefs) db.budgets,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurringRulesRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          RecurringRuleRow,
                          $RecurringRulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._recurringRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringRulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          TxRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (budgetsRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          BudgetRow,
                          $BudgetsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._budgetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({
        bool recurringRulesRefs,
        bool transactionsRefs,
        bool budgetsRefs,
      })
    >;
typedef $$WalletsTableCreateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  required String name,
  required String icon,
  Value<int> sortOrder,
  Value<bool> isArchived,
});
typedef $$WalletsTableUpdateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> icon,
  Value<int> sortOrder,
  Value<bool> isArchived,
});

final class $$WalletsTableReferences
    extends BaseReferences<_$AppDatabase, $WalletsTable, WalletRow> {
  $$WalletsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecurringRulesTable, List<RecurringRuleRow>>
  _recurringRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurringRules,
    aliasName: 'wallets__id__recurring_rules__wallet_id',
  );

  $$RecurringRulesTableProcessedTableManager get recurringRulesRefs {
    final manager = $$RecurringRulesTableTableManager(
      $_db,
      $_db.recurringRules,
    ).filter((f) => f.walletId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurringRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<TxRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'wallets__id__transactions__wallet_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.walletId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WalletsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recurringRulesRefs(
    Expression<bool> Function($$RecurringRulesTableFilterComposer f) f,
  ) {
    final $$RecurringRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.walletId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableFilterComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.walletId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  Expression<T> recurringRulesRefs<T extends Object>(
    Expression<T> Function($$RecurringRulesTableAnnotationComposer a) f,
  ) {
    final $$RecurringRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.walletId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.walletId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WalletsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletsTable,
          WalletRow,
          $$WalletsTableFilterComposer,
          $$WalletsTableOrderingComposer,
          $$WalletsTableAnnotationComposer,
          $$WalletsTableCreateCompanionBuilder,
          $$WalletsTableUpdateCompanionBuilder,
          (WalletRow, $$WalletsTableReferences),
          WalletRow,
          PrefetchHooks Function({
            bool recurringRulesRefs,
            bool transactionsRefs,
          })
        > {
  $$WalletsTableTableManager(_$AppDatabase db, $WalletsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => WalletsCompanion(
                id: id,
                name: name,
                icon: icon,
                sortOrder: sortOrder,
                isArchived: isArchived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String icon,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => WalletsCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                sortOrder: sortOrder,
                isArchived: isArchived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WalletsTable, WalletRow>(table),
                  $$WalletsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({recurringRulesRefs = false, transactionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurringRulesRefs) db.recurringRules,
                    if (transactionsRefs) db.transactions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurringRulesRefs)
                        await $_getPrefetchedDataByColumns<
                          WalletRow,
                          $WalletsTable,
                          RecurringRuleRow,
                          $RecurringRulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WalletsTableReferences
                              ._recurringRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WalletsTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringRulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'wallet_id',
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          WalletRow,
                          $WalletsTable,
                          TxRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WalletsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WalletsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'wallet_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WalletsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletsTable,
      WalletRow,
      $$WalletsTableFilterComposer,
      $$WalletsTableOrderingComposer,
      $$WalletsTableAnnotationComposer,
      $$WalletsTableCreateCompanionBuilder,
      $$WalletsTableUpdateCompanionBuilder,
      (WalletRow, $$WalletsTableReferences),
      WalletRow,
      PrefetchHooks Function({bool recurringRulesRefs, bool transactionsRefs})
    >;
typedef $$RecurringRulesTableCreateCompanionBuilder =
    RecurringRulesCompanion Function({
      Value<int> id,
      required String type,
      required int amountCents,
      required int categoryId,
      required int walletId,
      Value<String?> note,
      Value<String> frequency,
      required int dayOfMonth,
      required DateTime nextRunAt,
      Value<bool> isActive,
    });
typedef $$RecurringRulesTableUpdateCompanionBuilder =
    RecurringRulesCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<int> amountCents,
      Value<int> categoryId,
      Value<int> walletId,
      Value<String?> note,
      Value<String> frequency,
      Value<int> dayOfMonth,
      Value<DateTime> nextRunAt,
      Value<bool> isActive,
    });

final class $$RecurringRulesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RecurringRulesTable, RecurringRuleRow> {
  $$RecurringRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('recurring_rules__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WalletsTable _walletIdTable(_$AppDatabase db) =>
      db.wallets.createAlias('recurring_rules__wallet_id__wallets__id');

  $$WalletsTableProcessedTableManager get walletId {
    final $_column = $_itemColumn<int>('wallet_id')!;

    final manager = $$WalletsTableTableManager(
      $_db,
      $_db.wallets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<TxRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'recurring_rules__id__transactions__recurring_rule_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.recurringRuleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecurringRulesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRunAt => $composableBuilder(
    column: $table.nextRunAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WalletsTableFilterComposer get walletId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.wallets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableFilterComposer(
            $db: $db,
            $table: $db.wallets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.recurringRuleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurringRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRunAt => $composableBuilder(
    column: $table.nextRunAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WalletsTableOrderingComposer get walletId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.wallets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableOrderingComposer(
            $db: $db,
            $table: $db.wallets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRunAt =>
      $composableBuilder(column: $table.nextRunAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WalletsTableAnnotationComposer get walletId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.wallets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableAnnotationComposer(
            $db: $db,
            $table: $db.wallets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.recurringRuleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurringRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringRulesTable,
          RecurringRuleRow,
          $$RecurringRulesTableFilterComposer,
          $$RecurringRulesTableOrderingComposer,
          $$RecurringRulesTableAnnotationComposer,
          $$RecurringRulesTableCreateCompanionBuilder,
          $$RecurringRulesTableUpdateCompanionBuilder,
          (RecurringRuleRow, $$RecurringRulesTableReferences),
          RecurringRuleRow,
          PrefetchHooks Function({
            bool categoryId,
            bool walletId,
            bool transactionsRefs,
          })
        > {
  $$RecurringRulesTableTableManager(
    _$AppDatabase db,
    $RecurringRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> dayOfMonth = const Value.absent(),
                Value<DateTime> nextRunAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => RecurringRulesCompanion(
                id: id,
                type: type,
                amountCents: amountCents,
                categoryId: categoryId,
                walletId: walletId,
                note: note,
                frequency: frequency,
                dayOfMonth: dayOfMonth,
                nextRunAt: nextRunAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required int amountCents,
                required int categoryId,
                required int walletId,
                Value<String?> note = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                required int dayOfMonth,
                required DateTime nextRunAt,
                Value<bool> isActive = const Value.absent(),
              }) => RecurringRulesCompanion.insert(
                id: id,
                type: type,
                amountCents: amountCents,
                categoryId: categoryId,
                walletId: walletId,
                note: note,
                frequency: frequency,
                dayOfMonth: dayOfMonth,
                nextRunAt: nextRunAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecurringRulesTable, RecurringRuleRow>(table),
                  $$RecurringRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                walletId = false,
                transactionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$RecurringRulesTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$RecurringRulesTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (walletId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.walletId,
                            referencedTable: $$RecurringRulesTableReferences
                                ._walletIdTable(db),
                            referencedColumn: $$RecurringRulesTableReferences
                                ._walletIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          RecurringRuleRow,
                          $RecurringRulesTable,
                          TxRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RecurringRulesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecurringRulesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'recurring_rule_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecurringRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringRulesTable,
      RecurringRuleRow,
      $$RecurringRulesTableFilterComposer,
      $$RecurringRulesTableOrderingComposer,
      $$RecurringRulesTableAnnotationComposer,
      $$RecurringRulesTableCreateCompanionBuilder,
      $$RecurringRulesTableUpdateCompanionBuilder,
      (RecurringRuleRow, $$RecurringRulesTableReferences),
      RecurringRuleRow,
      PrefetchHooks Function({
        bool categoryId,
        bool walletId,
        bool transactionsRefs,
      })
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required String type,
      required int amountCents,
      required int categoryId,
      required int walletId,
      required DateTime occurredAt,
      Value<String?> note,
      Value<String?> receiptPath,
      Value<int?> recurringRuleId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<int> amountCents,
      Value<int> categoryId,
      Value<int> walletId,
      Value<DateTime> occurredAt,
      Value<String?> note,
      Value<String?> receiptPath,
      Value<int?> recurringRuleId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, TxRow> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WalletsTable _walletIdTable(_$AppDatabase db) =>
      db.wallets.createAlias('transactions__wallet_id__wallets__id');

  $$WalletsTableProcessedTableManager get walletId {
    final $_column = $_itemColumn<int>('wallet_id')!;

    final manager = $$WalletsTableTableManager(
      $_db,
      $_db.wallets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecurringRulesTable _recurringRuleIdTable(_$AppDatabase db) => db
      .recurringRules
      .createAlias('transactions__recurring_rule_id__recurring_rules__id');

  $$RecurringRulesTableProcessedTableManager? get recurringRuleId {
    final $_column = $_itemColumn<int>('recurring_rule_id');
    if ($_column == null) return null;
    final manager = $$RecurringRulesTableTableManager(
      $_db,
      $_db.recurringRules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurringRuleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WalletsTableFilterComposer get walletId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.wallets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableFilterComposer(
            $db: $db,
            $table: $db.wallets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurringRulesTableFilterComposer get recurringRuleId {
    final $$RecurringRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringRuleId,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableFilterComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WalletsTableOrderingComposer get walletId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.wallets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableOrderingComposer(
            $db: $db,
            $table: $db.wallets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurringRulesTableOrderingComposer get recurringRuleId {
    final $$RecurringRulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringRuleId,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableOrderingComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WalletsTableAnnotationComposer get walletId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.wallets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableAnnotationComposer(
            $db: $db,
            $table: $db.wallets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurringRulesTableAnnotationComposer get recurringRuleId {
    final $$RecurringRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringRuleId,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TxRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (TxRow, $$TransactionsTableReferences),
          TxRow,
          PrefetchHooks Function({
            bool categoryId,
            bool walletId,
            bool recurringRuleId,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<int?> recurringRuleId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                type: type,
                amountCents: amountCents,
                categoryId: categoryId,
                walletId: walletId,
                occurredAt: occurredAt,
                note: note,
                receiptPath: receiptPath,
                recurringRuleId: recurringRuleId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required int amountCents,
                required int categoryId,
                required int walletId,
                required DateTime occurredAt,
                Value<String?> note = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<int?> recurringRuleId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                type: type,
                amountCents: amountCents,
                categoryId: categoryId,
                walletId: walletId,
                occurredAt: occurredAt,
                note: note,
                receiptPath: receiptPath,
                recurringRuleId: recurringRuleId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TxRow>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                walletId = false,
                recurringRuleId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TransactionsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (walletId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.walletId,
                            referencedTable: $$TransactionsTableReferences
                                ._walletIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._walletIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (recurringRuleId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.recurringRuleId,
                            referencedTable: $$TransactionsTableReferences
                                ._recurringRuleIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._recurringRuleIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TxRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (TxRow, $$TransactionsTableReferences),
      TxRow,
      PrefetchHooks Function({
        bool categoryId,
        bool walletId,
        bool recurringRuleId,
      })
    >;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  Value<int> id,
  Value<int?> categoryId,
  Value<String> period,
  required int limitCents,
  Value<DateTime> createdAt,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<int> id,
  Value<int?> categoryId,
  Value<String> period,
  Value<int> limitCents,
  Value<DateTime> createdAt,
});

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('budgets__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limitCents => $composableBuilder(
    column: $table.limitCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limitCents => $composableBuilder(
    column: $table.limitCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get limitCents => $composableBuilder(
    column: $table.limitCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetRow,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (BudgetRow, $$BudgetsTableReferences),
          BudgetRow,
          PrefetchHooks Function({bool categoryId})
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> limitCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                categoryId: categoryId,
                period: period,
                limitCents: limitCents,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> period = const Value.absent(),
                required int limitCents,
                Value<DateTime> createdAt = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                categoryId: categoryId,
                period: period,
                limitCents: limitCents,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetRow>(table),
                  $$BudgetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$BudgetsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$BudgetsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetRow,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetRow, $$BudgetsTableReferences),
      BudgetRow,
      PrefetchHooks Function({bool categoryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$RecurringRulesTableTableManager get recurringRules =>
      $$RecurringRulesTableTableManager(_db, _db.recurringRules);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
}
