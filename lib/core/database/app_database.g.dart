// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String id;
  final String status;
  const SyncOutboxData({required this.id, required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['status'] = Variable<String>(status);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(id: Value(id), status: Value(status));
  }

  factory SyncOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<String>(json['id']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'status': serializer.toJson<String>(status),
    };
  }

  SyncOutboxData copyWith({String? id, String? status}) =>
      SyncOutboxData(id: id ?? this.id, status: status ?? this.status);
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.status == this.status);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> id;
  final Value<String> status;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? id,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, StoredCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class StoredCategory extends DataClass implements Insertable<StoredCategory> {
  final String id;
  final String name;
  const StoredCategory({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(id: Value(id), name: Value(name));
  }

  factory StoredCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  StoredCategory copyWith({String? id, String? name}) =>
      StoredCategory(id: id ?? this.id, name: name ?? this.name);
  StoredCategory copyWithCompanion(CategoriesTableCompanion data) {
    return StoredCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredCategory(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredCategory &&
          other.id == this.id &&
          other.name == this.name);
}

class CategoriesTableCompanion extends UpdateCompanion<StoredCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<StoredCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, StoredProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stockQuantityMeta = const VerificationMeta(
    'stockQuantity',
  );
  @override
  late final GeneratedColumn<int> stockQuantity = GeneratedColumn<int>(
    'stock_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockStatusMeta = const VerificationMeta(
    'stockStatus',
  );
  @override
  late final GeneratedColumn<String> stockStatus = GeneratedColumn<String>(
    'stock_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAvailableForSaleMeta =
      const VerificationMeta('isAvailableForSale');
  @override
  late final GeneratedColumn<bool> isAvailableForSale = GeneratedColumn<bool>(
    'is_available_for_sale',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available_for_sale" IN (0, 1))',
    ),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _remoteUpdatedAtMeta = const VerificationMeta(
    'remoteUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> remoteUpdatedAt =
      GeneratedColumn<DateTime>(
        'remote_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    sku,
    brand,
    price,
    stockQuantity,
    stockStatus,
    isAvailableForSale,
    imageUrl,
    categoryId,
    remoteUpdatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(
        _stockQuantityMeta,
        stockQuantity.isAcceptableOrUnknown(
          data['stock_quantity']!,
          _stockQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stockQuantityMeta);
    }
    if (data.containsKey('stock_status')) {
      context.handle(
        _stockStatusMeta,
        stockStatus.isAcceptableOrUnknown(
          data['stock_status']!,
          _stockStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stockStatusMeta);
    }
    if (data.containsKey('is_available_for_sale')) {
      context.handle(
        _isAvailableForSaleMeta,
        isAvailableForSale.isAcceptableOrUnknown(
          data['is_available_for_sale']!,
          _isAvailableForSaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isAvailableForSaleMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
        _remoteUpdatedAtMeta,
        remoteUpdatedAt.isAcceptableOrUnknown(
          data['remote_updated_at']!,
          _remoteUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      stockQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_quantity'],
      )!,
      stockStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stock_status'],
      )!,
      isAvailableForSale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available_for_sale'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remote_updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class StoredProduct extends DataClass implements Insertable<StoredProduct> {
  final String id;
  final String name;
  final String sku;
  final String? brand;
  final double? price;
  final int stockQuantity;
  final String stockStatus;
  final bool isAvailableForSale;
  final String? imageUrl;
  final String? categoryId;
  final DateTime? remoteUpdatedAt;
  final DateTime? deletedAt;
  const StoredProduct({
    required this.id,
    required this.name,
    required this.sku,
    this.brand,
    this.price,
    required this.stockQuantity,
    required this.stockStatus,
    required this.isAvailableForSale,
    this.imageUrl,
    this.categoryId,
    this.remoteUpdatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sku'] = Variable<String>(sku);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    map['stock_quantity'] = Variable<int>(stockQuantity);
    map['stock_status'] = Variable<String>(stockStatus);
    map['is_available_for_sale'] = Variable<bool>(isAvailableForSale);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || remoteUpdatedAt != null) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      name: Value(name),
      sku: Value(sku),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      stockQuantity: Value(stockQuantity),
      stockStatus: Value(stockStatus),
      isAvailableForSale: Value(isAvailableForSale),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      remoteUpdatedAt: remoteUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUpdatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory StoredProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredProduct(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sku: serializer.fromJson<String>(json['sku']),
      brand: serializer.fromJson<String?>(json['brand']),
      price: serializer.fromJson<double?>(json['price']),
      stockQuantity: serializer.fromJson<int>(json['stockQuantity']),
      stockStatus: serializer.fromJson<String>(json['stockStatus']),
      isAvailableForSale: serializer.fromJson<bool>(json['isAvailableForSale']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      remoteUpdatedAt: serializer.fromJson<DateTime?>(json['remoteUpdatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sku': serializer.toJson<String>(sku),
      'brand': serializer.toJson<String?>(brand),
      'price': serializer.toJson<double?>(price),
      'stockQuantity': serializer.toJson<int>(stockQuantity),
      'stockStatus': serializer.toJson<String>(stockStatus),
      'isAvailableForSale': serializer.toJson<bool>(isAvailableForSale),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'categoryId': serializer.toJson<String?>(categoryId),
      'remoteUpdatedAt': serializer.toJson<DateTime?>(remoteUpdatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  StoredProduct copyWith({
    String? id,
    String? name,
    String? sku,
    Value<String?> brand = const Value.absent(),
    Value<double?> price = const Value.absent(),
    int? stockQuantity,
    String? stockStatus,
    bool? isAvailableForSale,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<DateTime?> remoteUpdatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => StoredProduct(
    id: id ?? this.id,
    name: name ?? this.name,
    sku: sku ?? this.sku,
    brand: brand.present ? brand.value : this.brand,
    price: price.present ? price.value : this.price,
    stockQuantity: stockQuantity ?? this.stockQuantity,
    stockStatus: stockStatus ?? this.stockStatus,
    isAvailableForSale: isAvailableForSale ?? this.isAvailableForSale,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    remoteUpdatedAt: remoteUpdatedAt.present
        ? remoteUpdatedAt.value
        : this.remoteUpdatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  StoredProduct copyWithCompanion(ProductsTableCompanion data) {
    return StoredProduct(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sku: data.sku.present ? data.sku.value : this.sku,
      brand: data.brand.present ? data.brand.value : this.brand,
      price: data.price.present ? data.price.value : this.price,
      stockQuantity: data.stockQuantity.present
          ? data.stockQuantity.value
          : this.stockQuantity,
      stockStatus: data.stockStatus.present
          ? data.stockStatus.value
          : this.stockStatus,
      isAvailableForSale: data.isAvailableForSale.present
          ? data.isAvailableForSale.value
          : this.isAvailableForSale,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredProduct(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('brand: $brand, ')
          ..write('price: $price, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('stockStatus: $stockStatus, ')
          ..write('isAvailableForSale: $isAvailableForSale, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('categoryId: $categoryId, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sku,
    brand,
    price,
    stockQuantity,
    stockStatus,
    isAvailableForSale,
    imageUrl,
    categoryId,
    remoteUpdatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredProduct &&
          other.id == this.id &&
          other.name == this.name &&
          other.sku == this.sku &&
          other.brand == this.brand &&
          other.price == this.price &&
          other.stockQuantity == this.stockQuantity &&
          other.stockStatus == this.stockStatus &&
          other.isAvailableForSale == this.isAvailableForSale &&
          other.imageUrl == this.imageUrl &&
          other.categoryId == this.categoryId &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.deletedAt == this.deletedAt);
}

class ProductsTableCompanion extends UpdateCompanion<StoredProduct> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> sku;
  final Value<String?> brand;
  final Value<double?> price;
  final Value<int> stockQuantity;
  final Value<String> stockStatus;
  final Value<bool> isAvailableForSale;
  final Value<String?> imageUrl;
  final Value<String?> categoryId;
  final Value<DateTime?> remoteUpdatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sku = const Value.absent(),
    this.brand = const Value.absent(),
    this.price = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.stockStatus = const Value.absent(),
    this.isAvailableForSale = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    required String id,
    required String name,
    required String sku,
    this.brand = const Value.absent(),
    this.price = const Value.absent(),
    required int stockQuantity,
    required String stockStatus,
    required bool isAvailableForSale,
    this.imageUrl = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sku = Value(sku),
       stockQuantity = Value(stockQuantity),
       stockStatus = Value(stockStatus),
       isAvailableForSale = Value(isAvailableForSale);
  static Insertable<StoredProduct> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? sku,
    Expression<String>? brand,
    Expression<double>? price,
    Expression<int>? stockQuantity,
    Expression<String>? stockStatus,
    Expression<bool>? isAvailableForSale,
    Expression<String>? imageUrl,
    Expression<String>? categoryId,
    Expression<DateTime>? remoteUpdatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sku != null) 'sku': sku,
      if (brand != null) 'brand': brand,
      if (price != null) 'price': price,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (stockStatus != null) 'stock_status': stockStatus,
      if (isAvailableForSale != null)
        'is_available_for_sale': isAvailableForSale,
      if (imageUrl != null) 'image_url': imageUrl,
      if (categoryId != null) 'category_id': categoryId,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? sku,
    Value<String?>? brand,
    Value<double?>? price,
    Value<int>? stockQuantity,
    Value<String>? stockStatus,
    Value<bool>? isAvailableForSale,
    Value<String?>? imageUrl,
    Value<String?>? categoryId,
    Value<DateTime?>? remoteUpdatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      stockStatus: stockStatus ?? this.stockStatus,
      isAvailableForSale: isAvailableForSale ?? this.isAvailableForSale,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<int>(stockQuantity.value);
    }
    if (stockStatus.present) {
      map['stock_status'] = Variable<String>(stockStatus.value);
    }
    if (isAvailableForSale.present) {
      map['is_available_for_sale'] = Variable<bool>(isAvailableForSale.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('brand: $brand, ')
          ..write('price: $price, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('stockStatus: $stockStatus, ')
          ..write('isAvailableForSale: $isAvailableForSale, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('categoryId: $categoryId, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DashboardSnapshotsTableTable extends DashboardSnapshotsTable
    with TableInfo<$DashboardSnapshotsTableTable, StoredDashboardSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardSnapshotsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeKeyMeta = const VerificationMeta(
    'scopeKey',
  );
  @override
  late final GeneratedColumn<String> scopeKey = GeneratedColumn<String>(
    'scope_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupByMeta = const VerificationMeta(
    'groupBy',
  );
  @override
  late final GeneratedColumn<String> groupBy = GeneratedColumn<String>(
    'group_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<String> revision = GeneratedColumn<String>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceDateMeta = const VerificationMeta(
    'referenceDate',
  );
  @override
  late final GeneratedColumn<String> referenceDate = GeneratedColumn<String>(
    'reference_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _webDashboardUrlMeta = const VerificationMeta(
    'webDashboardUrl',
  );
  @override
  late final GeneratedColumn<String> webDashboardUrl = GeneratedColumn<String>(
    'web_dashboard_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canViewFinancialMeta = const VerificationMeta(
    'canViewFinancial',
  );
  @override
  late final GeneratedColumn<bool> canViewFinancial = GeneratedColumn<bool>(
    'can_view_financial',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("can_view_financial" IN (0, 1))',
    ),
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    scopeKey,
    period,
    groupBy,
    page,
    revision,
    generatedAt,
    referenceDate,
    webDashboardUrl,
    canViewFinancial,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboard_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredDashboardSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope_key')) {
      context.handle(
        _scopeKeyMeta,
        scopeKey.isAcceptableOrUnknown(data['scope_key']!, _scopeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeKeyMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('group_by')) {
      context.handle(
        _groupByMeta,
        groupBy.isAcceptableOrUnknown(data['group_by']!, _groupByMeta),
      );
    } else if (isInserting) {
      context.missing(_groupByMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('reference_date')) {
      context.handle(
        _referenceDateMeta,
        referenceDate.isAcceptableOrUnknown(
          data['reference_date']!,
          _referenceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceDateMeta);
    }
    if (data.containsKey('web_dashboard_url')) {
      context.handle(
        _webDashboardUrlMeta,
        webDashboardUrl.isAcceptableOrUnknown(
          data['web_dashboard_url']!,
          _webDashboardUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_webDashboardUrlMeta);
    }
    if (data.containsKey('can_view_financial')) {
      context.handle(
        _canViewFinancialMeta,
        canViewFinancial.isAcceptableOrUnknown(
          data['can_view_financial']!,
          _canViewFinancialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canViewFinancialMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scopeKey};
  @override
  StoredDashboardSnapshot map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredDashboardSnapshot(
      scopeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_key'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      groupBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_by'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
      referenceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_date'],
      )!,
      webDashboardUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}web_dashboard_url'],
      )!,
      canViewFinancial: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}can_view_financial'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $DashboardSnapshotsTableTable createAlias(String alias) {
    return $DashboardSnapshotsTableTable(attachedDatabase, alias);
  }
}

class StoredDashboardSnapshot extends DataClass
    implements Insertable<StoredDashboardSnapshot> {
  final String scopeKey;
  final String period;
  final String groupBy;
  final int page;
  final String revision;
  final DateTime generatedAt;
  final String referenceDate;
  final String webDashboardUrl;
  final bool canViewFinancial;

  /// Serialized storage detail. JSON must not cross the data-layer boundary.
  final String payloadJson;
  const StoredDashboardSnapshot({
    required this.scopeKey,
    required this.period,
    required this.groupBy,
    required this.page,
    required this.revision,
    required this.generatedAt,
    required this.referenceDate,
    required this.webDashboardUrl,
    required this.canViewFinancial,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope_key'] = Variable<String>(scopeKey);
    map['period'] = Variable<String>(period);
    map['group_by'] = Variable<String>(groupBy);
    map['page'] = Variable<int>(page);
    map['revision'] = Variable<String>(revision);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['reference_date'] = Variable<String>(referenceDate);
    map['web_dashboard_url'] = Variable<String>(webDashboardUrl);
    map['can_view_financial'] = Variable<bool>(canViewFinancial);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  DashboardSnapshotsTableCompanion toCompanion(bool nullToAbsent) {
    return DashboardSnapshotsTableCompanion(
      scopeKey: Value(scopeKey),
      period: Value(period),
      groupBy: Value(groupBy),
      page: Value(page),
      revision: Value(revision),
      generatedAt: Value(generatedAt),
      referenceDate: Value(referenceDate),
      webDashboardUrl: Value(webDashboardUrl),
      canViewFinancial: Value(canViewFinancial),
      payloadJson: Value(payloadJson),
    );
  }

  factory StoredDashboardSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredDashboardSnapshot(
      scopeKey: serializer.fromJson<String>(json['scopeKey']),
      period: serializer.fromJson<String>(json['period']),
      groupBy: serializer.fromJson<String>(json['groupBy']),
      page: serializer.fromJson<int>(json['page']),
      revision: serializer.fromJson<String>(json['revision']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      referenceDate: serializer.fromJson<String>(json['referenceDate']),
      webDashboardUrl: serializer.fromJson<String>(json['webDashboardUrl']),
      canViewFinancial: serializer.fromJson<bool>(json['canViewFinancial']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scopeKey': serializer.toJson<String>(scopeKey),
      'period': serializer.toJson<String>(period),
      'groupBy': serializer.toJson<String>(groupBy),
      'page': serializer.toJson<int>(page),
      'revision': serializer.toJson<String>(revision),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'referenceDate': serializer.toJson<String>(referenceDate),
      'webDashboardUrl': serializer.toJson<String>(webDashboardUrl),
      'canViewFinancial': serializer.toJson<bool>(canViewFinancial),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  StoredDashboardSnapshot copyWith({
    String? scopeKey,
    String? period,
    String? groupBy,
    int? page,
    String? revision,
    DateTime? generatedAt,
    String? referenceDate,
    String? webDashboardUrl,
    bool? canViewFinancial,
    String? payloadJson,
  }) => StoredDashboardSnapshot(
    scopeKey: scopeKey ?? this.scopeKey,
    period: period ?? this.period,
    groupBy: groupBy ?? this.groupBy,
    page: page ?? this.page,
    revision: revision ?? this.revision,
    generatedAt: generatedAt ?? this.generatedAt,
    referenceDate: referenceDate ?? this.referenceDate,
    webDashboardUrl: webDashboardUrl ?? this.webDashboardUrl,
    canViewFinancial: canViewFinancial ?? this.canViewFinancial,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  StoredDashboardSnapshot copyWithCompanion(
    DashboardSnapshotsTableCompanion data,
  ) {
    return StoredDashboardSnapshot(
      scopeKey: data.scopeKey.present ? data.scopeKey.value : this.scopeKey,
      period: data.period.present ? data.period.value : this.period,
      groupBy: data.groupBy.present ? data.groupBy.value : this.groupBy,
      page: data.page.present ? data.page.value : this.page,
      revision: data.revision.present ? data.revision.value : this.revision,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      referenceDate: data.referenceDate.present
          ? data.referenceDate.value
          : this.referenceDate,
      webDashboardUrl: data.webDashboardUrl.present
          ? data.webDashboardUrl.value
          : this.webDashboardUrl,
      canViewFinancial: data.canViewFinancial.present
          ? data.canViewFinancial.value
          : this.canViewFinancial,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredDashboardSnapshot(')
          ..write('scopeKey: $scopeKey, ')
          ..write('period: $period, ')
          ..write('groupBy: $groupBy, ')
          ..write('page: $page, ')
          ..write('revision: $revision, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('referenceDate: $referenceDate, ')
          ..write('webDashboardUrl: $webDashboardUrl, ')
          ..write('canViewFinancial: $canViewFinancial, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    scopeKey,
    period,
    groupBy,
    page,
    revision,
    generatedAt,
    referenceDate,
    webDashboardUrl,
    canViewFinancial,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredDashboardSnapshot &&
          other.scopeKey == this.scopeKey &&
          other.period == this.period &&
          other.groupBy == this.groupBy &&
          other.page == this.page &&
          other.revision == this.revision &&
          other.generatedAt == this.generatedAt &&
          other.referenceDate == this.referenceDate &&
          other.webDashboardUrl == this.webDashboardUrl &&
          other.canViewFinancial == this.canViewFinancial &&
          other.payloadJson == this.payloadJson);
}

class DashboardSnapshotsTableCompanion
    extends UpdateCompanion<StoredDashboardSnapshot> {
  final Value<String> scopeKey;
  final Value<String> period;
  final Value<String> groupBy;
  final Value<int> page;
  final Value<String> revision;
  final Value<DateTime> generatedAt;
  final Value<String> referenceDate;
  final Value<String> webDashboardUrl;
  final Value<bool> canViewFinancial;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const DashboardSnapshotsTableCompanion({
    this.scopeKey = const Value.absent(),
    this.period = const Value.absent(),
    this.groupBy = const Value.absent(),
    this.page = const Value.absent(),
    this.revision = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.referenceDate = const Value.absent(),
    this.webDashboardUrl = const Value.absent(),
    this.canViewFinancial = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DashboardSnapshotsTableCompanion.insert({
    required String scopeKey,
    required String period,
    required String groupBy,
    required int page,
    required String revision,
    required DateTime generatedAt,
    required String referenceDate,
    required String webDashboardUrl,
    required bool canViewFinancial,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : scopeKey = Value(scopeKey),
       period = Value(period),
       groupBy = Value(groupBy),
       page = Value(page),
       revision = Value(revision),
       generatedAt = Value(generatedAt),
       referenceDate = Value(referenceDate),
       webDashboardUrl = Value(webDashboardUrl),
       canViewFinancial = Value(canViewFinancial),
       payloadJson = Value(payloadJson);
  static Insertable<StoredDashboardSnapshot> custom({
    Expression<String>? scopeKey,
    Expression<String>? period,
    Expression<String>? groupBy,
    Expression<int>? page,
    Expression<String>? revision,
    Expression<DateTime>? generatedAt,
    Expression<String>? referenceDate,
    Expression<String>? webDashboardUrl,
    Expression<bool>? canViewFinancial,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scopeKey != null) 'scope_key': scopeKey,
      if (period != null) 'period': period,
      if (groupBy != null) 'group_by': groupBy,
      if (page != null) 'page': page,
      if (revision != null) 'revision': revision,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (referenceDate != null) 'reference_date': referenceDate,
      if (webDashboardUrl != null) 'web_dashboard_url': webDashboardUrl,
      if (canViewFinancial != null) 'can_view_financial': canViewFinancial,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DashboardSnapshotsTableCompanion copyWith({
    Value<String>? scopeKey,
    Value<String>? period,
    Value<String>? groupBy,
    Value<int>? page,
    Value<String>? revision,
    Value<DateTime>? generatedAt,
    Value<String>? referenceDate,
    Value<String>? webDashboardUrl,
    Value<bool>? canViewFinancial,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return DashboardSnapshotsTableCompanion(
      scopeKey: scopeKey ?? this.scopeKey,
      period: period ?? this.period,
      groupBy: groupBy ?? this.groupBy,
      page: page ?? this.page,
      revision: revision ?? this.revision,
      generatedAt: generatedAt ?? this.generatedAt,
      referenceDate: referenceDate ?? this.referenceDate,
      webDashboardUrl: webDashboardUrl ?? this.webDashboardUrl,
      canViewFinancial: canViewFinancial ?? this.canViewFinancial,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scopeKey.present) {
      map['scope_key'] = Variable<String>(scopeKey.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (groupBy.present) {
      map['group_by'] = Variable<String>(groupBy.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (revision.present) {
      map['revision'] = Variable<String>(revision.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (referenceDate.present) {
      map['reference_date'] = Variable<String>(referenceDate.value);
    }
    if (webDashboardUrl.present) {
      map['web_dashboard_url'] = Variable<String>(webDashboardUrl.value);
    }
    if (canViewFinancial.present) {
      map['can_view_financial'] = Variable<bool>(canViewFinancial.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardSnapshotsTableCompanion(')
          ..write('scopeKey: $scopeKey, ')
          ..write('period: $period, ')
          ..write('groupBy: $groupBy, ')
          ..write('page: $page, ')
          ..write('revision: $revision, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('referenceDate: $referenceDate, ')
          ..write('webDashboardUrl: $webDashboardUrl, ')
          ..write('canViewFinancial: $canViewFinancial, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncCollectionsTableTable extends SyncCollectionsTable
    with TableInfo<$SyncCollectionsTableTable, StoredSyncCollection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCollectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _collectionMeta = const VerificationMeta(
    'collection',
  );
  @override
  late final GeneratedColumn<String> collection = GeneratedColumn<String>(
    'collection',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkpointMeta = const VerificationMeta(
    'checkpoint',
  );
  @override
  late final GeneratedColumn<String> checkpoint = GeneratedColumn<String>(
    'checkpoint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetCheckpointMeta = const VerificationMeta(
    'targetCheckpoint',
  );
  @override
  late final GeneratedColumn<String> targetCheckpoint = GeneratedColumn<String>(
    'target_checkpoint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<String> revision = GeneratedColumn<String>(
    'revision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSuccessAtMeta = const VerificationMeta(
    'lastSuccessAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSuccessAt =
      GeneratedColumn<DateTime>(
        'last_success_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isBootstrappedMeta = const VerificationMeta(
    'isBootstrapped',
  );
  @override
  late final GeneratedColumn<bool> isBootstrapped = GeneratedColumn<bool>(
    'is_bootstrapped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bootstrapped" IN (0, 1))',
    ),
  );
  static const VerificationMeta _totalReceivedMeta = const VerificationMeta(
    'totalReceived',
  );
  @override
  late final GeneratedColumn<int> totalReceived = GeneratedColumn<int>(
    'total_received',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    collection,
    mode,
    cursor,
    checkpoint,
    targetCheckpoint,
    revision,
    lastSuccessAt,
    isBootstrapped,
    totalReceived,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredSyncCollection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('collection')) {
      context.handle(
        _collectionMeta,
        collection.isAcceptableOrUnknown(data['collection']!, _collectionMeta),
      );
    } else if (isInserting) {
      context.missing(_collectionMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    }
    if (data.containsKey('checkpoint')) {
      context.handle(
        _checkpointMeta,
        checkpoint.isAcceptableOrUnknown(data['checkpoint']!, _checkpointMeta),
      );
    }
    if (data.containsKey('target_checkpoint')) {
      context.handle(
        _targetCheckpointMeta,
        targetCheckpoint.isAcceptableOrUnknown(
          data['target_checkpoint']!,
          _targetCheckpointMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('last_success_at')) {
      context.handle(
        _lastSuccessAtMeta,
        lastSuccessAt.isAcceptableOrUnknown(
          data['last_success_at']!,
          _lastSuccessAtMeta,
        ),
      );
    }
    if (data.containsKey('is_bootstrapped')) {
      context.handle(
        _isBootstrappedMeta,
        isBootstrapped.isAcceptableOrUnknown(
          data['is_bootstrapped']!,
          _isBootstrappedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isBootstrappedMeta);
    }
    if (data.containsKey('total_received')) {
      context.handle(
        _totalReceivedMeta,
        totalReceived.isAcceptableOrUnknown(
          data['total_received']!,
          _totalReceivedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalReceivedMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {collection};
  @override
  StoredSyncCollection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredSyncCollection(
      collection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cursor'],
      ),
      checkpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkpoint'],
      ),
      targetCheckpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_checkpoint'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision'],
      ),
      lastSuccessAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_success_at'],
      ),
      isBootstrapped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bootstrapped'],
      )!,
      totalReceived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_received'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $SyncCollectionsTableTable createAlias(String alias) {
    return $SyncCollectionsTableTable(attachedDatabase, alias);
  }
}

class StoredSyncCollection extends DataClass
    implements Insertable<StoredSyncCollection> {
  final String collection;
  final String mode;
  final String? cursor;
  final String? checkpoint;
  final String? targetCheckpoint;
  final String? revision;
  final DateTime? lastSuccessAt;
  final bool isBootstrapped;
  final int totalReceived;
  final String? lastError;
  const StoredSyncCollection({
    required this.collection,
    required this.mode,
    this.cursor,
    this.checkpoint,
    this.targetCheckpoint,
    this.revision,
    this.lastSuccessAt,
    required this.isBootstrapped,
    required this.totalReceived,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['collection'] = Variable<String>(collection);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || cursor != null) {
      map['cursor'] = Variable<String>(cursor);
    }
    if (!nullToAbsent || checkpoint != null) {
      map['checkpoint'] = Variable<String>(checkpoint);
    }
    if (!nullToAbsent || targetCheckpoint != null) {
      map['target_checkpoint'] = Variable<String>(targetCheckpoint);
    }
    if (!nullToAbsent || revision != null) {
      map['revision'] = Variable<String>(revision);
    }
    if (!nullToAbsent || lastSuccessAt != null) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt);
    }
    map['is_bootstrapped'] = Variable<bool>(isBootstrapped);
    map['total_received'] = Variable<int>(totalReceived);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncCollectionsTableCompanion toCompanion(bool nullToAbsent) {
    return SyncCollectionsTableCompanion(
      collection: Value(collection),
      mode: Value(mode),
      cursor: cursor == null && nullToAbsent
          ? const Value.absent()
          : Value(cursor),
      checkpoint: checkpoint == null && nullToAbsent
          ? const Value.absent()
          : Value(checkpoint),
      targetCheckpoint: targetCheckpoint == null && nullToAbsent
          ? const Value.absent()
          : Value(targetCheckpoint),
      revision: revision == null && nullToAbsent
          ? const Value.absent()
          : Value(revision),
      lastSuccessAt: lastSuccessAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessAt),
      isBootstrapped: Value(isBootstrapped),
      totalReceived: Value(totalReceived),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory StoredSyncCollection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredSyncCollection(
      collection: serializer.fromJson<String>(json['collection']),
      mode: serializer.fromJson<String>(json['mode']),
      cursor: serializer.fromJson<String?>(json['cursor']),
      checkpoint: serializer.fromJson<String?>(json['checkpoint']),
      targetCheckpoint: serializer.fromJson<String?>(json['targetCheckpoint']),
      revision: serializer.fromJson<String?>(json['revision']),
      lastSuccessAt: serializer.fromJson<DateTime?>(json['lastSuccessAt']),
      isBootstrapped: serializer.fromJson<bool>(json['isBootstrapped']),
      totalReceived: serializer.fromJson<int>(json['totalReceived']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'collection': serializer.toJson<String>(collection),
      'mode': serializer.toJson<String>(mode),
      'cursor': serializer.toJson<String?>(cursor),
      'checkpoint': serializer.toJson<String?>(checkpoint),
      'targetCheckpoint': serializer.toJson<String?>(targetCheckpoint),
      'revision': serializer.toJson<String?>(revision),
      'lastSuccessAt': serializer.toJson<DateTime?>(lastSuccessAt),
      'isBootstrapped': serializer.toJson<bool>(isBootstrapped),
      'totalReceived': serializer.toJson<int>(totalReceived),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  StoredSyncCollection copyWith({
    String? collection,
    String? mode,
    Value<String?> cursor = const Value.absent(),
    Value<String?> checkpoint = const Value.absent(),
    Value<String?> targetCheckpoint = const Value.absent(),
    Value<String?> revision = const Value.absent(),
    Value<DateTime?> lastSuccessAt = const Value.absent(),
    bool? isBootstrapped,
    int? totalReceived,
    Value<String?> lastError = const Value.absent(),
  }) => StoredSyncCollection(
    collection: collection ?? this.collection,
    mode: mode ?? this.mode,
    cursor: cursor.present ? cursor.value : this.cursor,
    checkpoint: checkpoint.present ? checkpoint.value : this.checkpoint,
    targetCheckpoint: targetCheckpoint.present
        ? targetCheckpoint.value
        : this.targetCheckpoint,
    revision: revision.present ? revision.value : this.revision,
    lastSuccessAt: lastSuccessAt.present
        ? lastSuccessAt.value
        : this.lastSuccessAt,
    isBootstrapped: isBootstrapped ?? this.isBootstrapped,
    totalReceived: totalReceived ?? this.totalReceived,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  StoredSyncCollection copyWithCompanion(SyncCollectionsTableCompanion data) {
    return StoredSyncCollection(
      collection: data.collection.present
          ? data.collection.value
          : this.collection,
      mode: data.mode.present ? data.mode.value : this.mode,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
      checkpoint: data.checkpoint.present
          ? data.checkpoint.value
          : this.checkpoint,
      targetCheckpoint: data.targetCheckpoint.present
          ? data.targetCheckpoint.value
          : this.targetCheckpoint,
      revision: data.revision.present ? data.revision.value : this.revision,
      lastSuccessAt: data.lastSuccessAt.present
          ? data.lastSuccessAt.value
          : this.lastSuccessAt,
      isBootstrapped: data.isBootstrapped.present
          ? data.isBootstrapped.value
          : this.isBootstrapped,
      totalReceived: data.totalReceived.present
          ? data.totalReceived.value
          : this.totalReceived,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredSyncCollection(')
          ..write('collection: $collection, ')
          ..write('mode: $mode, ')
          ..write('cursor: $cursor, ')
          ..write('checkpoint: $checkpoint, ')
          ..write('targetCheckpoint: $targetCheckpoint, ')
          ..write('revision: $revision, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('isBootstrapped: $isBootstrapped, ')
          ..write('totalReceived: $totalReceived, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    collection,
    mode,
    cursor,
    checkpoint,
    targetCheckpoint,
    revision,
    lastSuccessAt,
    isBootstrapped,
    totalReceived,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredSyncCollection &&
          other.collection == this.collection &&
          other.mode == this.mode &&
          other.cursor == this.cursor &&
          other.checkpoint == this.checkpoint &&
          other.targetCheckpoint == this.targetCheckpoint &&
          other.revision == this.revision &&
          other.lastSuccessAt == this.lastSuccessAt &&
          other.isBootstrapped == this.isBootstrapped &&
          other.totalReceived == this.totalReceived &&
          other.lastError == this.lastError);
}

class SyncCollectionsTableCompanion
    extends UpdateCompanion<StoredSyncCollection> {
  final Value<String> collection;
  final Value<String> mode;
  final Value<String?> cursor;
  final Value<String?> checkpoint;
  final Value<String?> targetCheckpoint;
  final Value<String?> revision;
  final Value<DateTime?> lastSuccessAt;
  final Value<bool> isBootstrapped;
  final Value<int> totalReceived;
  final Value<String?> lastError;
  final Value<int> rowid;
  const SyncCollectionsTableCompanion({
    this.collection = const Value.absent(),
    this.mode = const Value.absent(),
    this.cursor = const Value.absent(),
    this.checkpoint = const Value.absent(),
    this.targetCheckpoint = const Value.absent(),
    this.revision = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.isBootstrapped = const Value.absent(),
    this.totalReceived = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCollectionsTableCompanion.insert({
    required String collection,
    required String mode,
    this.cursor = const Value.absent(),
    this.checkpoint = const Value.absent(),
    this.targetCheckpoint = const Value.absent(),
    this.revision = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    required bool isBootstrapped,
    required int totalReceived,
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : collection = Value(collection),
       mode = Value(mode),
       isBootstrapped = Value(isBootstrapped),
       totalReceived = Value(totalReceived);
  static Insertable<StoredSyncCollection> custom({
    Expression<String>? collection,
    Expression<String>? mode,
    Expression<String>? cursor,
    Expression<String>? checkpoint,
    Expression<String>? targetCheckpoint,
    Expression<String>? revision,
    Expression<DateTime>? lastSuccessAt,
    Expression<bool>? isBootstrapped,
    Expression<int>? totalReceived,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (collection != null) 'collection': collection,
      if (mode != null) 'mode': mode,
      if (cursor != null) 'cursor': cursor,
      if (checkpoint != null) 'checkpoint': checkpoint,
      if (targetCheckpoint != null) 'target_checkpoint': targetCheckpoint,
      if (revision != null) 'revision': revision,
      if (lastSuccessAt != null) 'last_success_at': lastSuccessAt,
      if (isBootstrapped != null) 'is_bootstrapped': isBootstrapped,
      if (totalReceived != null) 'total_received': totalReceived,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCollectionsTableCompanion copyWith({
    Value<String>? collection,
    Value<String>? mode,
    Value<String?>? cursor,
    Value<String?>? checkpoint,
    Value<String?>? targetCheckpoint,
    Value<String?>? revision,
    Value<DateTime?>? lastSuccessAt,
    Value<bool>? isBootstrapped,
    Value<int>? totalReceived,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return SyncCollectionsTableCompanion(
      collection: collection ?? this.collection,
      mode: mode ?? this.mode,
      cursor: cursor ?? this.cursor,
      checkpoint: checkpoint ?? this.checkpoint,
      targetCheckpoint: targetCheckpoint ?? this.targetCheckpoint,
      revision: revision ?? this.revision,
      lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
      isBootstrapped: isBootstrapped ?? this.isBootstrapped,
      totalReceived: totalReceived ?? this.totalReceived,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (collection.present) {
      map['collection'] = Variable<String>(collection.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<String>(cursor.value);
    }
    if (checkpoint.present) {
      map['checkpoint'] = Variable<String>(checkpoint.value);
    }
    if (targetCheckpoint.present) {
      map['target_checkpoint'] = Variable<String>(targetCheckpoint.value);
    }
    if (revision.present) {
      map['revision'] = Variable<String>(revision.value);
    }
    if (lastSuccessAt.present) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt.value);
    }
    if (isBootstrapped.present) {
      map['is_bootstrapped'] = Variable<bool>(isBootstrapped.value);
    }
    if (totalReceived.present) {
      map['total_received'] = Variable<int>(totalReceived.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCollectionsTableCompanion(')
          ..write('collection: $collection, ')
          ..write('mode: $mode, ')
          ..write('cursor: $cursor, ')
          ..write('checkpoint: $checkpoint, ')
          ..write('targetCheckpoint: $targetCheckpoint, ')
          ..write('revision: $revision, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('isBootstrapped: $isBootstrapped, ')
          ..write('totalReceived: $totalReceived, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $DashboardSnapshotsTableTable dashboardSnapshotsTable =
      $DashboardSnapshotsTableTable(this);
  late final $SyncCollectionsTableTable syncCollectionsTable =
      $SyncCollectionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    syncOutbox,
    categoriesTable,
    productsTable,
    dashboardSnapshotsTable,
    syncCollectionsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('products', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String id,
      required String status,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> id,
      Value<String> status,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxData,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxData,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
          ),
          SyncOutboxData,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(id: id, status: status, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncOutboxTable, SyncOutboxData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncOutboxTable,
                    SyncOutboxData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxData,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxData,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
      ),
      SyncOutboxData,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

final class $$CategoriesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $CategoriesTableTable, StoredCategory> {
  $$CategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ProductsTableTable, List<StoredProduct>>
  _productsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productsTable,
    aliasName: 'categories__id__products__category_id',
  );

  $$ProductsTableTableProcessedTableManager get productsTableRefs {
    final manager = $$ProductsTableTableTableManager(
      $_db,
      $_db.productsTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productsTableRefs(
    Expression<bool> Function($$ProductsTableTableFilterComposer f) f,
  ) {
    final $$ProductsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableFilterComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> productsTableRefs<T extends Object>(
    Expression<T> Function($$ProductsTableTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          StoredCategory,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (StoredCategory, $$CategoriesTableTableReferences),
          StoredCategory,
          PrefetchHooks Function({bool productsTableRefs})
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTableTable, StoredCategory>(table),
                  $$CategoriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productsTableRefs) db.productsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsTableRefs)
                    await $_getPrefetchedData<
                      StoredCategory,
                      $CategoriesTableTable,
                      StoredProduct
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableTableReferences
                          ._productsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).productsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      StoredCategory,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (StoredCategory, $$CategoriesTableTableReferences),
      StoredCategory,
      PrefetchHooks Function({bool productsTableRefs})
    >;
typedef $$ProductsTableTableCreateCompanionBuilder =
    ProductsTableCompanion Function({
      required String id,
      required String name,
      required String sku,
      Value<String?> brand,
      Value<double?> price,
      required int stockQuantity,
      required String stockStatus,
      required bool isAvailableForSale,
      Value<String?> imageUrl,
      Value<String?> categoryId,
      Value<DateTime?> remoteUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableTableUpdateCompanionBuilder =
    ProductsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> sku,
      Value<String?> brand,
      Value<double?> price,
      Value<int> stockQuantity,
      Value<String> stockStatus,
      Value<bool> isAvailableForSale,
      Value<String?> imageUrl,
      Value<String?> categoryId,
      Value<DateTime?> remoteUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$ProductsTableTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTableTable, StoredProduct> {
  $$ProductsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) =>
      db.categoriesTable.createAlias('products__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stockStatus => $composableBuilder(
    column: $table.stockStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailableForSale => $composableBuilder(
    column: $table.isAvailableForSale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stockStatus => $composableBuilder(
    column: $table.stockStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailableForSale => $composableBuilder(
    column: $table.isAvailableForSale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stockStatus => $composableBuilder(
    column: $table.stockStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAvailableForSale => $composableBuilder(
    column: $table.isAvailableForSale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTableTable,
          StoredProduct,
          $$ProductsTableTableFilterComposer,
          $$ProductsTableTableOrderingComposer,
          $$ProductsTableTableAnnotationComposer,
          $$ProductsTableTableCreateCompanionBuilder,
          $$ProductsTableTableUpdateCompanionBuilder,
          (StoredProduct, $$ProductsTableTableReferences),
          StoredProduct,
          PrefetchHooks Function({bool categoryId})
        > {
  $$ProductsTableTableTableManager(_$AppDatabase db, $ProductsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> sku = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<int> stockQuantity = const Value.absent(),
                Value<String> stockStatus = const Value.absent(),
                Value<bool> isAvailableForSale = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<DateTime?> remoteUpdatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion(
                id: id,
                name: name,
                sku: sku,
                brand: brand,
                price: price,
                stockQuantity: stockQuantity,
                stockStatus: stockStatus,
                isAvailableForSale: isAvailableForSale,
                imageUrl: imageUrl,
                categoryId: categoryId,
                remoteUpdatedAt: remoteUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String sku,
                Value<String?> brand = const Value.absent(),
                Value<double?> price = const Value.absent(),
                required int stockQuantity,
                required String stockStatus,
                required bool isAvailableForSale,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<DateTime?> remoteUpdatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion.insert(
                id: id,
                name: name,
                sku: sku,
                brand: brand,
                price: price,
                stockQuantity: stockQuantity,
                stockStatus: stockStatus,
                isAvailableForSale: isAvailableForSale,
                imageUrl: imageUrl,
                categoryId: categoryId,
                remoteUpdatedAt: remoteUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductsTableTable, StoredProduct>(table),
                  $$ProductsTableTableReferences(db, table, e),
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
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$ProductsTableTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$ProductsTableTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$ProductsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTableTable,
      StoredProduct,
      $$ProductsTableTableFilterComposer,
      $$ProductsTableTableOrderingComposer,
      $$ProductsTableTableAnnotationComposer,
      $$ProductsTableTableCreateCompanionBuilder,
      $$ProductsTableTableUpdateCompanionBuilder,
      (StoredProduct, $$ProductsTableTableReferences),
      StoredProduct,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$DashboardSnapshotsTableTableCreateCompanionBuilder =
    DashboardSnapshotsTableCompanion Function({
      required String scopeKey,
      required String period,
      required String groupBy,
      required int page,
      required String revision,
      required DateTime generatedAt,
      required String referenceDate,
      required String webDashboardUrl,
      required bool canViewFinancial,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$DashboardSnapshotsTableTableUpdateCompanionBuilder =
    DashboardSnapshotsTableCompanion Function({
      Value<String> scopeKey,
      Value<String> period,
      Value<String> groupBy,
      Value<int> page,
      Value<String> revision,
      Value<DateTime> generatedAt,
      Value<String> referenceDate,
      Value<String> webDashboardUrl,
      Value<bool> canViewFinancial,
      Value<String> payloadJson,
      Value<int> rowid,
    });

class $$DashboardSnapshotsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DashboardSnapshotsTableTable> {
  $$DashboardSnapshotsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scopeKey => $composableBuilder(
    column: $table.scopeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupBy => $composableBuilder(
    column: $table.groupBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceDate => $composableBuilder(
    column: $table.referenceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get webDashboardUrl => $composableBuilder(
    column: $table.webDashboardUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get canViewFinancial => $composableBuilder(
    column: $table.canViewFinancial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DashboardSnapshotsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DashboardSnapshotsTableTable> {
  $$DashboardSnapshotsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scopeKey => $composableBuilder(
    column: $table.scopeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupBy => $composableBuilder(
    column: $table.groupBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceDate => $composableBuilder(
    column: $table.referenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get webDashboardUrl => $composableBuilder(
    column: $table.webDashboardUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get canViewFinancial => $composableBuilder(
    column: $table.canViewFinancial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DashboardSnapshotsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DashboardSnapshotsTableTable> {
  $$DashboardSnapshotsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scopeKey =>
      $composableBuilder(column: $table.scopeKey, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get groupBy =>
      $composableBuilder(column: $table.groupBy, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<String> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceDate => $composableBuilder(
    column: $table.referenceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get webDashboardUrl => $composableBuilder(
    column: $table.webDashboardUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get canViewFinancial => $composableBuilder(
    column: $table.canViewFinancial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$DashboardSnapshotsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DashboardSnapshotsTableTable,
          StoredDashboardSnapshot,
          $$DashboardSnapshotsTableTableFilterComposer,
          $$DashboardSnapshotsTableTableOrderingComposer,
          $$DashboardSnapshotsTableTableAnnotationComposer,
          $$DashboardSnapshotsTableTableCreateCompanionBuilder,
          $$DashboardSnapshotsTableTableUpdateCompanionBuilder,
          (
            StoredDashboardSnapshot,
            BaseReferences<
              _$AppDatabase,
              $DashboardSnapshotsTableTable,
              StoredDashboardSnapshot
            >,
          ),
          StoredDashboardSnapshot,
          PrefetchHooks Function()
        > {
  $$DashboardSnapshotsTableTableTableManager(
    _$AppDatabase db,
    $DashboardSnapshotsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DashboardSnapshotsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DashboardSnapshotsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DashboardSnapshotsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> scopeKey = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<String> groupBy = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<String> revision = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<String> referenceDate = const Value.absent(),
                Value<String> webDashboardUrl = const Value.absent(),
                Value<bool> canViewFinancial = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DashboardSnapshotsTableCompanion(
                scopeKey: scopeKey,
                period: period,
                groupBy: groupBy,
                page: page,
                revision: revision,
                generatedAt: generatedAt,
                referenceDate: referenceDate,
                webDashboardUrl: webDashboardUrl,
                canViewFinancial: canViewFinancial,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String scopeKey,
                required String period,
                required String groupBy,
                required int page,
                required String revision,
                required DateTime generatedAt,
                required String referenceDate,
                required String webDashboardUrl,
                required bool canViewFinancial,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => DashboardSnapshotsTableCompanion.insert(
                scopeKey: scopeKey,
                period: period,
                groupBy: groupBy,
                page: page,
                revision: revision,
                generatedAt: generatedAt,
                referenceDate: referenceDate,
                webDashboardUrl: webDashboardUrl,
                canViewFinancial: canViewFinancial,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $DashboardSnapshotsTableTable,
                    StoredDashboardSnapshot
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DashboardSnapshotsTableTable,
                    StoredDashboardSnapshot
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DashboardSnapshotsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DashboardSnapshotsTableTable,
      StoredDashboardSnapshot,
      $$DashboardSnapshotsTableTableFilterComposer,
      $$DashboardSnapshotsTableTableOrderingComposer,
      $$DashboardSnapshotsTableTableAnnotationComposer,
      $$DashboardSnapshotsTableTableCreateCompanionBuilder,
      $$DashboardSnapshotsTableTableUpdateCompanionBuilder,
      (
        StoredDashboardSnapshot,
        BaseReferences<
          _$AppDatabase,
          $DashboardSnapshotsTableTable,
          StoredDashboardSnapshot
        >,
      ),
      StoredDashboardSnapshot,
      PrefetchHooks Function()
    >;
typedef $$SyncCollectionsTableTableCreateCompanionBuilder =
    SyncCollectionsTableCompanion Function({
      required String collection,
      required String mode,
      Value<String?> cursor,
      Value<String?> checkpoint,
      Value<String?> targetCheckpoint,
      Value<String?> revision,
      Value<DateTime?> lastSuccessAt,
      required bool isBootstrapped,
      required int totalReceived,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$SyncCollectionsTableTableUpdateCompanionBuilder =
    SyncCollectionsTableCompanion Function({
      Value<String> collection,
      Value<String> mode,
      Value<String?> cursor,
      Value<String?> checkpoint,
      Value<String?> targetCheckpoint,
      Value<String?> revision,
      Value<DateTime?> lastSuccessAt,
      Value<bool> isBootstrapped,
      Value<int> totalReceived,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$SyncCollectionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCollectionsTableTable> {
  $$SyncCollectionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkpoint => $composableBuilder(
    column: $table.checkpoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetCheckpoint => $composableBuilder(
    column: $table.targetCheckpoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBootstrapped => $composableBuilder(
    column: $table.isBootstrapped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReceived => $composableBuilder(
    column: $table.totalReceived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCollectionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCollectionsTableTable> {
  $$SyncCollectionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkpoint => $composableBuilder(
    column: $table.checkpoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetCheckpoint => $composableBuilder(
    column: $table.targetCheckpoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBootstrapped => $composableBuilder(
    column: $table.isBootstrapped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReceived => $composableBuilder(
    column: $table.totalReceived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCollectionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCollectionsTableTable> {
  $$SyncCollectionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);

  GeneratedColumn<String> get checkpoint => $composableBuilder(
    column: $table.checkpoint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetCheckpoint => $composableBuilder(
    column: $table.targetCheckpoint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSuccessAt => $composableBuilder(
    column: $table.lastSuccessAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBootstrapped => $composableBuilder(
    column: $table.isBootstrapped,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalReceived => $composableBuilder(
    column: $table.totalReceived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncCollectionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCollectionsTableTable,
          StoredSyncCollection,
          $$SyncCollectionsTableTableFilterComposer,
          $$SyncCollectionsTableTableOrderingComposer,
          $$SyncCollectionsTableTableAnnotationComposer,
          $$SyncCollectionsTableTableCreateCompanionBuilder,
          $$SyncCollectionsTableTableUpdateCompanionBuilder,
          (
            StoredSyncCollection,
            BaseReferences<
              _$AppDatabase,
              $SyncCollectionsTableTable,
              StoredSyncCollection
            >,
          ),
          StoredSyncCollection,
          PrefetchHooks Function()
        > {
  $$SyncCollectionsTableTableTableManager(
    _$AppDatabase db,
    $SyncCollectionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCollectionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCollectionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SyncCollectionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> collection = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> cursor = const Value.absent(),
                Value<String?> checkpoint = const Value.absent(),
                Value<String?> targetCheckpoint = const Value.absent(),
                Value<String?> revision = const Value.absent(),
                Value<DateTime?> lastSuccessAt = const Value.absent(),
                Value<bool> isBootstrapped = const Value.absent(),
                Value<int> totalReceived = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCollectionsTableCompanion(
                collection: collection,
                mode: mode,
                cursor: cursor,
                checkpoint: checkpoint,
                targetCheckpoint: targetCheckpoint,
                revision: revision,
                lastSuccessAt: lastSuccessAt,
                isBootstrapped: isBootstrapped,
                totalReceived: totalReceived,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String collection,
                required String mode,
                Value<String?> cursor = const Value.absent(),
                Value<String?> checkpoint = const Value.absent(),
                Value<String?> targetCheckpoint = const Value.absent(),
                Value<String?> revision = const Value.absent(),
                Value<DateTime?> lastSuccessAt = const Value.absent(),
                required bool isBootstrapped,
                required int totalReceived,
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCollectionsTableCompanion.insert(
                collection: collection,
                mode: mode,
                cursor: cursor,
                checkpoint: checkpoint,
                targetCheckpoint: targetCheckpoint,
                revision: revision,
                lastSuccessAt: lastSuccessAt,
                isBootstrapped: isBootstrapped,
                totalReceived: totalReceived,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncCollectionsTableTable, StoredSyncCollection>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncCollectionsTableTable,
                    StoredSyncCollection
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCollectionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCollectionsTableTable,
      StoredSyncCollection,
      $$SyncCollectionsTableTableFilterComposer,
      $$SyncCollectionsTableTableOrderingComposer,
      $$SyncCollectionsTableTableAnnotationComposer,
      $$SyncCollectionsTableTableCreateCompanionBuilder,
      $$SyncCollectionsTableTableUpdateCompanionBuilder,
      (
        StoredSyncCollection,
        BaseReferences<
          _$AppDatabase,
          $SyncCollectionsTableTable,
          StoredSyncCollection
        >,
      ),
      StoredSyncCollection,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$DashboardSnapshotsTableTableTableManager get dashboardSnapshotsTable =>
      $$DashboardSnapshotsTableTableTableManager(
        _db,
        _db.dashboardSnapshotsTable,
      );
  $$SyncCollectionsTableTableTableManager get syncCollectionsTable =>
      $$SyncCollectionsTableTableTableManager(_db, _db.syncCollectionsTable);
}
