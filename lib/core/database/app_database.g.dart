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
  static const VerificationMeta _clientRequestIdMeta = const VerificationMeta(
    'clientRequestId',
  );
  @override
  late final GeneratedColumn<String> clientRequestId = GeneratedColumn<String>(
    'client_request_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('legacy_unknown'),
  );
  static const VerificationMeta _localOperationIdMeta = const VerificationMeta(
    'localOperationId',
  );
  @override
  late final GeneratedColumn<String> localOperationId = GeneratedColumn<String>(
    'local_operation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
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
  static const VerificationMeta _remoteIntentIdMeta = const VerificationMeta(
    'remoteIntentId',
  );
  @override
  late final GeneratedColumn<String> remoteIntentId = GeneratedColumn<String>(
    'remote_intent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteSaleIdMeta = const VerificationMeta(
    'remoteSaleId',
  );
  @override
  late final GeneratedColumn<String> remoteSaleId = GeneratedColumn<String>(
    'remote_sale_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proposalJsonMeta = const VerificationMeta(
    'proposalJson',
  );
  @override
  late final GeneratedColumn<String> proposalJson = GeneratedColumn<String>(
    'proposal_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proposalRevisionMeta = const VerificationMeta(
    'proposalRevision',
  );
  @override
  late final GeneratedColumn<int> proposalRevision = GeneratedColumn<int>(
    'proposal_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _confirmationTokenMeta = const VerificationMeta(
    'confirmationToken',
  );
  @override
  late final GeneratedColumn<String> confirmationToken =
      GeneratedColumn<String>(
        'confirmation_token',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientRequestId,
    operationType,
    localOperationId,
    payloadJson,
    payloadVersion,
    status,
    attempts,
    nextAttemptAt,
    lastError,
    remoteIntentId,
    remoteSaleId,
    proposalJson,
    proposalRevision,
    confirmationToken,
    createdAt,
    updatedAt,
  ];
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
    if (data.containsKey('client_request_id')) {
      context.handle(
        _clientRequestIdMeta,
        clientRequestId.isAcceptableOrUnknown(
          data['client_request_id']!,
          _clientRequestIdMeta,
        ),
      );
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    }
    if (data.containsKey('local_operation_id')) {
      context.handle(
        _localOperationIdMeta,
        localOperationId.isAcceptableOrUnknown(
          data['local_operation_id']!,
          _localOperationIdMeta,
        ),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('remote_intent_id')) {
      context.handle(
        _remoteIntentIdMeta,
        remoteIntentId.isAcceptableOrUnknown(
          data['remote_intent_id']!,
          _remoteIntentIdMeta,
        ),
      );
    }
    if (data.containsKey('remote_sale_id')) {
      context.handle(
        _remoteSaleIdMeta,
        remoteSaleId.isAcceptableOrUnknown(
          data['remote_sale_id']!,
          _remoteSaleIdMeta,
        ),
      );
    }
    if (data.containsKey('proposal_json')) {
      context.handle(
        _proposalJsonMeta,
        proposalJson.isAcceptableOrUnknown(
          data['proposal_json']!,
          _proposalJsonMeta,
        ),
      );
    }
    if (data.containsKey('proposal_revision')) {
      context.handle(
        _proposalRevisionMeta,
        proposalRevision.isAcceptableOrUnknown(
          data['proposal_revision']!,
          _proposalRevisionMeta,
        ),
      );
    }
    if (data.containsKey('confirmation_token')) {
      context.handle(
        _confirmationTokenMeta,
        confirmationToken.isAcceptableOrUnknown(
          data['confirmation_token']!,
          _confirmationTokenMeta,
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
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientRequestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_request_id'],
      ),
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      localOperationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_operation_id'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      payloadVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payload_version'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      remoteIntentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_intent_id'],
      ),
      remoteSaleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_sale_id'],
      ),
      proposalJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proposal_json'],
      ),
      proposalRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proposal_revision'],
      )!,
      confirmationToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmation_token'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String id;
  final String? clientRequestId;
  final String operationType;
  final String? localOperationId;
  final String payloadJson;
  final int payloadVersion;
  final String status;
  final int attempts;
  final DateTime? nextAttemptAt;
  final String? lastError;
  final String? remoteIntentId;
  final String? remoteSaleId;
  final String? proposalJson;
  final int proposalRevision;
  final String? confirmationToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const SyncOutboxData({
    required this.id,
    this.clientRequestId,
    required this.operationType,
    this.localOperationId,
    required this.payloadJson,
    required this.payloadVersion,
    required this.status,
    required this.attempts,
    this.nextAttemptAt,
    this.lastError,
    this.remoteIntentId,
    this.remoteSaleId,
    this.proposalJson,
    required this.proposalRevision,
    this.confirmationToken,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || clientRequestId != null) {
      map['client_request_id'] = Variable<String>(clientRequestId);
    }
    map['operation_type'] = Variable<String>(operationType);
    if (!nullToAbsent || localOperationId != null) {
      map['local_operation_id'] = Variable<String>(localOperationId);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['payload_version'] = Variable<int>(payloadVersion);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || remoteIntentId != null) {
      map['remote_intent_id'] = Variable<String>(remoteIntentId);
    }
    if (!nullToAbsent || remoteSaleId != null) {
      map['remote_sale_id'] = Variable<String>(remoteSaleId);
    }
    if (!nullToAbsent || proposalJson != null) {
      map['proposal_json'] = Variable<String>(proposalJson);
    }
    map['proposal_revision'] = Variable<int>(proposalRevision);
    if (!nullToAbsent || confirmationToken != null) {
      map['confirmation_token'] = Variable<String>(confirmationToken);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      clientRequestId: clientRequestId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientRequestId),
      operationType: Value(operationType),
      localOperationId: localOperationId == null && nullToAbsent
          ? const Value.absent()
          : Value(localOperationId),
      payloadJson: Value(payloadJson),
      payloadVersion: Value(payloadVersion),
      status: Value(status),
      attempts: Value(attempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      remoteIntentId: remoteIntentId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteIntentId),
      remoteSaleId: remoteSaleId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteSaleId),
      proposalJson: proposalJson == null && nullToAbsent
          ? const Value.absent()
          : Value(proposalJson),
      proposalRevision: Value(proposalRevision),
      confirmationToken: confirmationToken == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmationToken),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory SyncOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<String>(json['id']),
      clientRequestId: serializer.fromJson<String?>(json['clientRequestId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      localOperationId: serializer.fromJson<String?>(json['localOperationId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      remoteIntentId: serializer.fromJson<String?>(json['remoteIntentId']),
      remoteSaleId: serializer.fromJson<String?>(json['remoteSaleId']),
      proposalJson: serializer.fromJson<String?>(json['proposalJson']),
      proposalRevision: serializer.fromJson<int>(json['proposalRevision']),
      confirmationToken: serializer.fromJson<String?>(
        json['confirmationToken'],
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientRequestId': serializer.toJson<String?>(clientRequestId),
      'operationType': serializer.toJson<String>(operationType),
      'localOperationId': serializer.toJson<String?>(localOperationId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'remoteIntentId': serializer.toJson<String?>(remoteIntentId),
      'remoteSaleId': serializer.toJson<String?>(remoteSaleId),
      'proposalJson': serializer.toJson<String?>(proposalJson),
      'proposalRevision': serializer.toJson<int>(proposalRevision),
      'confirmationToken': serializer.toJson<String?>(confirmationToken),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  SyncOutboxData copyWith({
    String? id,
    Value<String?> clientRequestId = const Value.absent(),
    String? operationType,
    Value<String?> localOperationId = const Value.absent(),
    String? payloadJson,
    int? payloadVersion,
    String? status,
    int? attempts,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    Value<String?> remoteIntentId = const Value.absent(),
    Value<String?> remoteSaleId = const Value.absent(),
    Value<String?> proposalJson = const Value.absent(),
    int? proposalRevision,
    Value<String?> confirmationToken = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => SyncOutboxData(
    id: id ?? this.id,
    clientRequestId: clientRequestId.present
        ? clientRequestId.value
        : this.clientRequestId,
    operationType: operationType ?? this.operationType,
    localOperationId: localOperationId.present
        ? localOperationId.value
        : this.localOperationId,
    payloadJson: payloadJson ?? this.payloadJson,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    remoteIntentId: remoteIntentId.present
        ? remoteIntentId.value
        : this.remoteIntentId,
    remoteSaleId: remoteSaleId.present ? remoteSaleId.value : this.remoteSaleId,
    proposalJson: proposalJson.present ? proposalJson.value : this.proposalJson,
    proposalRevision: proposalRevision ?? this.proposalRevision,
    confirmationToken: confirmationToken.present
        ? confirmationToken.value
        : this.confirmationToken,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      clientRequestId: data.clientRequestId.present
          ? data.clientRequestId.value
          : this.clientRequestId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      localOperationId: data.localOperationId.present
          ? data.localOperationId.value
          : this.localOperationId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      payloadVersion: data.payloadVersion.present
          ? data.payloadVersion.value
          : this.payloadVersion,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      remoteIntentId: data.remoteIntentId.present
          ? data.remoteIntentId.value
          : this.remoteIntentId,
      remoteSaleId: data.remoteSaleId.present
          ? data.remoteSaleId.value
          : this.remoteSaleId,
      proposalJson: data.proposalJson.present
          ? data.proposalJson.value
          : this.proposalJson,
      proposalRevision: data.proposalRevision.present
          ? data.proposalRevision.value
          : this.proposalRevision,
      confirmationToken: data.confirmationToken.present
          ? data.confirmationToken.value
          : this.confirmationToken,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('clientRequestId: $clientRequestId, ')
          ..write('operationType: $operationType, ')
          ..write('localOperationId: $localOperationId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('remoteIntentId: $remoteIntentId, ')
          ..write('remoteSaleId: $remoteSaleId, ')
          ..write('proposalJson: $proposalJson, ')
          ..write('proposalRevision: $proposalRevision, ')
          ..write('confirmationToken: $confirmationToken, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientRequestId,
    operationType,
    localOperationId,
    payloadJson,
    payloadVersion,
    status,
    attempts,
    nextAttemptAt,
    lastError,
    remoteIntentId,
    remoteSaleId,
    proposalJson,
    proposalRevision,
    confirmationToken,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.clientRequestId == this.clientRequestId &&
          other.operationType == this.operationType &&
          other.localOperationId == this.localOperationId &&
          other.payloadJson == this.payloadJson &&
          other.payloadVersion == this.payloadVersion &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.remoteIntentId == this.remoteIntentId &&
          other.remoteSaleId == this.remoteSaleId &&
          other.proposalJson == this.proposalJson &&
          other.proposalRevision == this.proposalRevision &&
          other.confirmationToken == this.confirmationToken &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> id;
  final Value<String?> clientRequestId;
  final Value<String> operationType;
  final Value<String?> localOperationId;
  final Value<String> payloadJson;
  final Value<int> payloadVersion;
  final Value<String> status;
  final Value<int> attempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<String?> remoteIntentId;
  final Value<String?> remoteSaleId;
  final Value<String?> proposalJson;
  final Value<int> proposalRevision;
  final Value<String?> confirmationToken;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.clientRequestId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.localOperationId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.remoteIntentId = const Value.absent(),
    this.remoteSaleId = const Value.absent(),
    this.proposalJson = const Value.absent(),
    this.proposalRevision = const Value.absent(),
    this.confirmationToken = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    this.clientRequestId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.localOperationId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    required String status,
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.remoteIntentId = const Value.absent(),
    this.remoteSaleId = const Value.absent(),
    this.proposalJson = const Value.absent(),
    this.proposalRevision = const Value.absent(),
    this.confirmationToken = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? id,
    Expression<String>? clientRequestId,
    Expression<String>? operationType,
    Expression<String>? localOperationId,
    Expression<String>? payloadJson,
    Expression<int>? payloadVersion,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<String>? remoteIntentId,
    Expression<String>? remoteSaleId,
    Expression<String>? proposalJson,
    Expression<int>? proposalRevision,
    Expression<String>? confirmationToken,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientRequestId != null) 'client_request_id': clientRequestId,
      if (operationType != null) 'operation_type': operationType,
      if (localOperationId != null) 'local_operation_id': localOperationId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (remoteIntentId != null) 'remote_intent_id': remoteIntentId,
      if (remoteSaleId != null) 'remote_sale_id': remoteSaleId,
      if (proposalJson != null) 'proposal_json': proposalJson,
      if (proposalRevision != null) 'proposal_revision': proposalRevision,
      if (confirmationToken != null) 'confirmation_token': confirmationToken,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? id,
    Value<String?>? clientRequestId,
    Value<String>? operationType,
    Value<String?>? localOperationId,
    Value<String>? payloadJson,
    Value<int>? payloadVersion,
    Value<String>? status,
    Value<int>? attempts,
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? lastError,
    Value<String?>? remoteIntentId,
    Value<String?>? remoteSaleId,
    Value<String?>? proposalJson,
    Value<int>? proposalRevision,
    Value<String?>? confirmationToken,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      clientRequestId: clientRequestId ?? this.clientRequestId,
      operationType: operationType ?? this.operationType,
      localOperationId: localOperationId ?? this.localOperationId,
      payloadJson: payloadJson ?? this.payloadJson,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      remoteIntentId: remoteIntentId ?? this.remoteIntentId,
      remoteSaleId: remoteSaleId ?? this.remoteSaleId,
      proposalJson: proposalJson ?? this.proposalJson,
      proposalRevision: proposalRevision ?? this.proposalRevision,
      confirmationToken: confirmationToken ?? this.confirmationToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientRequestId.present) {
      map['client_request_id'] = Variable<String>(clientRequestId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (localOperationId.present) {
      map['local_operation_id'] = Variable<String>(localOperationId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (remoteIntentId.present) {
      map['remote_intent_id'] = Variable<String>(remoteIntentId.value);
    }
    if (remoteSaleId.present) {
      map['remote_sale_id'] = Variable<String>(remoteSaleId.value);
    }
    if (proposalJson.present) {
      map['proposal_json'] = Variable<String>(proposalJson.value);
    }
    if (proposalRevision.present) {
      map['proposal_revision'] = Variable<int>(proposalRevision.value);
    }
    if (confirmationToken.present) {
      map['confirmation_token'] = Variable<String>(confirmationToken.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
          ..write('clientRequestId: $clientRequestId, ')
          ..write('operationType: $operationType, ')
          ..write('localOperationId: $localOperationId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('remoteIntentId: $remoteIntentId, ')
          ..write('remoteSaleId: $remoteSaleId, ')
          ..write('proposalJson: $proposalJson, ')
          ..write('proposalRevision: $proposalRevision, ')
          ..write('confirmationToken: $confirmationToken, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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

class $SyncLocksTableTable extends SyncLocksTable
    with TableInfo<$SyncLocksTableTable, StoredSyncLock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLocksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acquiredAtMeta = const VerificationMeta(
    'acquiredAt',
  );
  @override
  late final GeneratedColumn<int> acquiredAt = GeneratedColumn<int>(
    'acquired_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [name, ownerId, acquiredAt, expiresAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_locks';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredSyncLock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('acquired_at')) {
      context.handle(
        _acquiredAtMeta,
        acquiredAt.isAcceptableOrUnknown(data['acquired_at']!, _acquiredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_acquiredAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  StoredSyncLock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredSyncLock(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      acquiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}acquired_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $SyncLocksTableTable createAlias(String alias) {
    return $SyncLocksTableTable(attachedDatabase, alias);
  }
}

class StoredSyncLock extends DataClass implements Insertable<StoredSyncLock> {
  final String name;
  final String ownerId;
  final int acquiredAt;
  final int expiresAt;
  const StoredSyncLock({
    required this.name,
    required this.ownerId,
    required this.acquiredAt,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['owner_id'] = Variable<String>(ownerId);
    map['acquired_at'] = Variable<int>(acquiredAt);
    map['expires_at'] = Variable<int>(expiresAt);
    return map;
  }

  SyncLocksTableCompanion toCompanion(bool nullToAbsent) {
    return SyncLocksTableCompanion(
      name: Value(name),
      ownerId: Value(ownerId),
      acquiredAt: Value(acquiredAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory StoredSyncLock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredSyncLock(
      name: serializer.fromJson<String>(json['name']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      acquiredAt: serializer.fromJson<int>(json['acquiredAt']),
      expiresAt: serializer.fromJson<int>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'ownerId': serializer.toJson<String>(ownerId),
      'acquiredAt': serializer.toJson<int>(acquiredAt),
      'expiresAt': serializer.toJson<int>(expiresAt),
    };
  }

  StoredSyncLock copyWith({
    String? name,
    String? ownerId,
    int? acquiredAt,
    int? expiresAt,
  }) => StoredSyncLock(
    name: name ?? this.name,
    ownerId: ownerId ?? this.ownerId,
    acquiredAt: acquiredAt ?? this.acquiredAt,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  StoredSyncLock copyWithCompanion(SyncLocksTableCompanion data) {
    return StoredSyncLock(
      name: data.name.present ? data.name.value : this.name,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      acquiredAt: data.acquiredAt.present
          ? data.acquiredAt.value
          : this.acquiredAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredSyncLock(')
          ..write('name: $name, ')
          ..write('ownerId: $ownerId, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, ownerId, acquiredAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredSyncLock &&
          other.name == this.name &&
          other.ownerId == this.ownerId &&
          other.acquiredAt == this.acquiredAt &&
          other.expiresAt == this.expiresAt);
}

class SyncLocksTableCompanion extends UpdateCompanion<StoredSyncLock> {
  final Value<String> name;
  final Value<String> ownerId;
  final Value<int> acquiredAt;
  final Value<int> expiresAt;
  final Value<int> rowid;
  const SyncLocksTableCompanion({
    this.name = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.acquiredAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncLocksTableCompanion.insert({
    required String name,
    required String ownerId,
    required int acquiredAt,
    required int expiresAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       ownerId = Value(ownerId),
       acquiredAt = Value(acquiredAt),
       expiresAt = Value(expiresAt);
  static Insertable<StoredSyncLock> custom({
    Expression<String>? name,
    Expression<String>? ownerId,
    Expression<int>? acquiredAt,
    Expression<int>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (ownerId != null) 'owner_id': ownerId,
      if (acquiredAt != null) 'acquired_at': acquiredAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncLocksTableCompanion copyWith({
    Value<String>? name,
    Value<String>? ownerId,
    Value<int>? acquiredAt,
    Value<int>? expiresAt,
    Value<int>? rowid,
  }) {
    return SyncLocksTableCompanion(
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (acquiredAt.present) {
      map['acquired_at'] = Variable<int>(acquiredAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLocksTableCompanion(')
          ..write('name: $name, ')
          ..write('ownerId: $ownerId, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSalesTableTable extends LocalSalesTable
    with TableInfo<$LocalSalesTableTable, StoredLocalSale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSalesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientRequestIdMeta = const VerificationMeta(
    'clientRequestId',
  );
  @override
  late final GeneratedColumn<String> clientRequestId = GeneratedColumn<String>(
    'client_request_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientNameMeta = const VerificationMeta(
    'clientName',
  );
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soldAtMeta = const VerificationMeta('soldAt');
  @override
  late final GeneratedColumn<DateTime> soldAt = GeneratedColumn<DateTime>(
    'sold_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientRequestId,
    clientId,
    clientName,
    soldAt,
    timezone,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredLocalSale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_request_id')) {
      context.handle(
        _clientRequestIdMeta,
        clientRequestId.isAcceptableOrUnknown(
          data['client_request_id']!,
          _clientRequestIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientRequestIdMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('client_name')) {
      context.handle(
        _clientNameMeta,
        clientName.isAcceptableOrUnknown(data['client_name']!, _clientNameMeta),
      );
    } else if (isInserting) {
      context.missing(_clientNameMeta);
    }
    if (data.containsKey('sold_at')) {
      context.handle(
        _soldAtMeta,
        soldAt.isAcceptableOrUnknown(data['sold_at']!, _soldAtMeta),
      );
    } else if (isInserting) {
      context.missing(_soldAtMeta);
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredLocalSale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredLocalSale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientRequestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_request_id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      clientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_name'],
      )!,
      soldAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sold_at'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
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
  $LocalSalesTableTable createAlias(String alias) {
    return $LocalSalesTableTable(attachedDatabase, alias);
  }
}

class StoredLocalSale extends DataClass implements Insertable<StoredLocalSale> {
  final String id;
  final String clientRequestId;
  final String clientId;
  final String clientName;
  final DateTime soldAt;
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StoredLocalSale({
    required this.id,
    required this.clientRequestId,
    required this.clientId,
    required this.clientName,
    required this.soldAt,
    required this.timezone,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_request_id'] = Variable<String>(clientRequestId);
    map['client_id'] = Variable<String>(clientId);
    map['client_name'] = Variable<String>(clientName);
    map['sold_at'] = Variable<DateTime>(soldAt);
    map['timezone'] = Variable<String>(timezone);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalSalesTableCompanion toCompanion(bool nullToAbsent) {
    return LocalSalesTableCompanion(
      id: Value(id),
      clientRequestId: Value(clientRequestId),
      clientId: Value(clientId),
      clientName: Value(clientName),
      soldAt: Value(soldAt),
      timezone: Value(timezone),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StoredLocalSale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredLocalSale(
      id: serializer.fromJson<String>(json['id']),
      clientRequestId: serializer.fromJson<String>(json['clientRequestId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      clientName: serializer.fromJson<String>(json['clientName']),
      soldAt: serializer.fromJson<DateTime>(json['soldAt']),
      timezone: serializer.fromJson<String>(json['timezone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientRequestId': serializer.toJson<String>(clientRequestId),
      'clientId': serializer.toJson<String>(clientId),
      'clientName': serializer.toJson<String>(clientName),
      'soldAt': serializer.toJson<DateTime>(soldAt),
      'timezone': serializer.toJson<String>(timezone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StoredLocalSale copyWith({
    String? id,
    String? clientRequestId,
    String? clientId,
    String? clientName,
    DateTime? soldAt,
    String? timezone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => StoredLocalSale(
    id: id ?? this.id,
    clientRequestId: clientRequestId ?? this.clientRequestId,
    clientId: clientId ?? this.clientId,
    clientName: clientName ?? this.clientName,
    soldAt: soldAt ?? this.soldAt,
    timezone: timezone ?? this.timezone,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StoredLocalSale copyWithCompanion(LocalSalesTableCompanion data) {
    return StoredLocalSale(
      id: data.id.present ? data.id.value : this.id,
      clientRequestId: data.clientRequestId.present
          ? data.clientRequestId.value
          : this.clientRequestId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      clientName: data.clientName.present
          ? data.clientName.value
          : this.clientName,
      soldAt: data.soldAt.present ? data.soldAt.value : this.soldAt,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredLocalSale(')
          ..write('id: $id, ')
          ..write('clientRequestId: $clientRequestId, ')
          ..write('clientId: $clientId, ')
          ..write('clientName: $clientName, ')
          ..write('soldAt: $soldAt, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientRequestId,
    clientId,
    clientName,
    soldAt,
    timezone,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredLocalSale &&
          other.id == this.id &&
          other.clientRequestId == this.clientRequestId &&
          other.clientId == this.clientId &&
          other.clientName == this.clientName &&
          other.soldAt == this.soldAt &&
          other.timezone == this.timezone &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalSalesTableCompanion extends UpdateCompanion<StoredLocalSale> {
  final Value<String> id;
  final Value<String> clientRequestId;
  final Value<String> clientId;
  final Value<String> clientName;
  final Value<DateTime> soldAt;
  final Value<String> timezone;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalSalesTableCompanion({
    this.id = const Value.absent(),
    this.clientRequestId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.clientName = const Value.absent(),
    this.soldAt = const Value.absent(),
    this.timezone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSalesTableCompanion.insert({
    required String id,
    required String clientRequestId,
    required String clientId,
    required String clientName,
    required DateTime soldAt,
    required String timezone,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientRequestId = Value(clientRequestId),
       clientId = Value(clientId),
       clientName = Value(clientName),
       soldAt = Value(soldAt),
       timezone = Value(timezone),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StoredLocalSale> custom({
    Expression<String>? id,
    Expression<String>? clientRequestId,
    Expression<String>? clientId,
    Expression<String>? clientName,
    Expression<DateTime>? soldAt,
    Expression<String>? timezone,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientRequestId != null) 'client_request_id': clientRequestId,
      if (clientId != null) 'client_id': clientId,
      if (clientName != null) 'client_name': clientName,
      if (soldAt != null) 'sold_at': soldAt,
      if (timezone != null) 'timezone': timezone,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSalesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? clientRequestId,
    Value<String>? clientId,
    Value<String>? clientName,
    Value<DateTime>? soldAt,
    Value<String>? timezone,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalSalesTableCompanion(
      id: id ?? this.id,
      clientRequestId: clientRequestId ?? this.clientRequestId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      soldAt: soldAt ?? this.soldAt,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientRequestId.present) {
      map['client_request_id'] = Variable<String>(clientRequestId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (soldAt.present) {
      map['sold_at'] = Variable<DateTime>(soldAt.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSalesTableCompanion(')
          ..write('id: $id, ')
          ..write('clientRequestId: $clientRequestId, ')
          ..write('clientId: $clientId, ')
          ..write('clientName: $clientName, ')
          ..write('soldAt: $soldAt, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSaleItemsTableTable extends LocalSaleItemsTable
    with TableInfo<$LocalSaleItemsTableTable, StoredLocalSaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSaleItemsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_sales (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productSkuMeta = const VerificationMeta(
    'productSku',
  );
  @override
  late final GeneratedColumn<String> productSku = GeneratedColumn<String>(
    'product_sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _historicalUnitPriceMeta =
      const VerificationMeta('historicalUnitPrice');
  @override
  late final GeneratedColumn<double> historicalUnitPrice =
      GeneratedColumn<double>(
        'historical_unit_price',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    productName,
    productSku,
    quantity,
    historicalUnitPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sale_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredLocalSaleItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('product_sku')) {
      context.handle(
        _productSkuMeta,
        productSku.isAcceptableOrUnknown(data['product_sku']!, _productSkuMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('historical_unit_price')) {
      context.handle(
        _historicalUnitPriceMeta,
        historicalUnitPrice.isAcceptableOrUnknown(
          data['historical_unit_price']!,
          _historicalUnitPriceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredLocalSaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredLocalSaleItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      productSku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_sku'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      historicalUnitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}historical_unit_price'],
      ),
    );
  }

  @override
  $LocalSaleItemsTableTable createAlias(String alias) {
    return $LocalSaleItemsTableTable(attachedDatabase, alias);
  }
}

class StoredLocalSaleItem extends DataClass
    implements Insertable<StoredLocalSaleItem> {
  final int id;
  final String saleId;
  final String productId;
  final String productName;
  final String? productSku;
  final int quantity;
  final double? historicalUnitPrice;
  const StoredLocalSaleItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    this.productSku,
    required this.quantity,
    this.historicalUnitPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || productSku != null) {
      map['product_sku'] = Variable<String>(productSku);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || historicalUnitPrice != null) {
      map['historical_unit_price'] = Variable<double>(historicalUnitPrice);
    }
    return map;
  }

  LocalSaleItemsTableCompanion toCompanion(bool nullToAbsent) {
    return LocalSaleItemsTableCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      productName: Value(productName),
      productSku: productSku == null && nullToAbsent
          ? const Value.absent()
          : Value(productSku),
      quantity: Value(quantity),
      historicalUnitPrice: historicalUnitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(historicalUnitPrice),
    );
  }

  factory StoredLocalSaleItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredLocalSaleItem(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      productSku: serializer.fromJson<String?>(json['productSku']),
      quantity: serializer.fromJson<int>(json['quantity']),
      historicalUnitPrice: serializer.fromJson<double?>(
        json['historicalUnitPrice'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'productSku': serializer.toJson<String?>(productSku),
      'quantity': serializer.toJson<int>(quantity),
      'historicalUnitPrice': serializer.toJson<double?>(historicalUnitPrice),
    };
  }

  StoredLocalSaleItem copyWith({
    int? id,
    String? saleId,
    String? productId,
    String? productName,
    Value<String?> productSku = const Value.absent(),
    int? quantity,
    Value<double?> historicalUnitPrice = const Value.absent(),
  }) => StoredLocalSaleItem(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    productSku: productSku.present ? productSku.value : this.productSku,
    quantity: quantity ?? this.quantity,
    historicalUnitPrice: historicalUnitPrice.present
        ? historicalUnitPrice.value
        : this.historicalUnitPrice,
  );
  StoredLocalSaleItem copyWithCompanion(LocalSaleItemsTableCompanion data) {
    return StoredLocalSaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      productSku: data.productSku.present
          ? data.productSku.value
          : this.productSku,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      historicalUnitPrice: data.historicalUnitPrice.present
          ? data.historicalUnitPrice.value
          : this.historicalUnitPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredLocalSaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productSku: $productSku, ')
          ..write('quantity: $quantity, ')
          ..write('historicalUnitPrice: $historicalUnitPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    productId,
    productName,
    productSku,
    quantity,
    historicalUnitPrice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredLocalSaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.productSku == this.productSku &&
          other.quantity == this.quantity &&
          other.historicalUnitPrice == this.historicalUnitPrice);
}

class LocalSaleItemsTableCompanion
    extends UpdateCompanion<StoredLocalSaleItem> {
  final Value<int> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<String?> productSku;
  final Value<int> quantity;
  final Value<double?> historicalUnitPrice;
  const LocalSaleItemsTableCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.productSku = const Value.absent(),
    this.quantity = const Value.absent(),
    this.historicalUnitPrice = const Value.absent(),
  });
  LocalSaleItemsTableCompanion.insert({
    this.id = const Value.absent(),
    required String saleId,
    required String productId,
    required String productName,
    this.productSku = const Value.absent(),
    required int quantity,
    this.historicalUnitPrice = const Value.absent(),
  }) : saleId = Value(saleId),
       productId = Value(productId),
       productName = Value(productName),
       quantity = Value(quantity);
  static Insertable<StoredLocalSaleItem> custom({
    Expression<int>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<String>? productSku,
    Expression<int>? quantity,
    Expression<double>? historicalUnitPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (productSku != null) 'product_sku': productSku,
      if (quantity != null) 'quantity': quantity,
      if (historicalUnitPrice != null)
        'historical_unit_price': historicalUnitPrice,
    });
  }

  LocalSaleItemsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? saleId,
    Value<String>? productId,
    Value<String>? productName,
    Value<String?>? productSku,
    Value<int>? quantity,
    Value<double?>? historicalUnitPrice,
  }) {
    return LocalSaleItemsTableCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productSku: productSku ?? this.productSku,
      quantity: quantity ?? this.quantity,
      historicalUnitPrice: historicalUnitPrice ?? this.historicalUnitPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (productSku.present) {
      map['product_sku'] = Variable<String>(productSku.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (historicalUnitPrice.present) {
      map['historical_unit_price'] = Variable<double>(
        historicalUnitPrice.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSaleItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productSku: $productSku, ')
          ..write('quantity: $quantity, ')
          ..write('historicalUnitPrice: $historicalUnitPrice')
          ..write(')'))
        .toString();
  }
}

class $ClientsTableTable extends ClientsTable
    with TableInfo<$ClientsTableTable, StoredClient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, city, state];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredClient> instance, {
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
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredClient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredClient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
    );
  }

  @override
  $ClientsTableTable createAlias(String alias) {
    return $ClientsTableTable(attachedDatabase, alias);
  }
}

class StoredClient extends DataClass implements Insertable<StoredClient> {
  final String id;
  final String name;
  final String? city;
  final String? state;
  const StoredClient({
    required this.id,
    required this.name,
    this.city,
    this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    return map;
  }

  ClientsTableCompanion toCompanion(bool nullToAbsent) {
    return ClientsTableCompanion(
      id: Value(id),
      name: Value(name),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
    );
  }

  factory StoredClient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredClient(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
    };
  }

  StoredClient copyWith({
    String? id,
    String? name,
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
  }) => StoredClient(
    id: id ?? this.id,
    name: name ?? this.name,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
  );
  StoredClient copyWithCompanion(ClientsTableCompanion data) {
    return StoredClient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredClient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, city, state);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredClient &&
          other.id == this.id &&
          other.name == this.name &&
          other.city == this.city &&
          other.state == this.state);
}

class ClientsTableCompanion extends UpdateCompanion<StoredClient> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> city;
  final Value<String?> state;
  final Value<int> rowid;
  const ClientsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsTableCompanion.insert({
    required String id,
    required String name,
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<StoredClient> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? city,
    Expression<String>? state,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? city,
    Value<String?>? state,
    Value<int>? rowid,
  }) {
    return ClientsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      state: state ?? this.state,
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
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClientSnapshotEntriesTableTable extends ClientSnapshotEntriesTable
    with
        TableInfo<
          $ClientSnapshotEntriesTableTable,
          ClientSnapshotEntriesTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientSnapshotEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _snapshotUpperBoundIdMeta =
      const VerificationMeta('snapshotUpperBoundId');
  @override
  late final GeneratedColumn<int> snapshotUpperBoundId = GeneratedColumn<int>(
    'snapshot_upper_bound_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [snapshotUpperBoundId, clientId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'client_snapshot_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientSnapshotEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('snapshot_upper_bound_id')) {
      context.handle(
        _snapshotUpperBoundIdMeta,
        snapshotUpperBoundId.isAcceptableOrUnknown(
          data['snapshot_upper_bound_id']!,
          _snapshotUpperBoundIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotUpperBoundIdMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {snapshotUpperBoundId, clientId};
  @override
  ClientSnapshotEntriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientSnapshotEntriesTableData(
      snapshotUpperBoundId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snapshot_upper_bound_id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
    );
  }

  @override
  $ClientSnapshotEntriesTableTable createAlias(String alias) {
    return $ClientSnapshotEntriesTableTable(attachedDatabase, alias);
  }
}

class ClientSnapshotEntriesTableData extends DataClass
    implements Insertable<ClientSnapshotEntriesTableData> {
  final int snapshotUpperBoundId;
  final String clientId;
  const ClientSnapshotEntriesTableData({
    required this.snapshotUpperBoundId,
    required this.clientId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['snapshot_upper_bound_id'] = Variable<int>(snapshotUpperBoundId);
    map['client_id'] = Variable<String>(clientId);
    return map;
  }

  ClientSnapshotEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return ClientSnapshotEntriesTableCompanion(
      snapshotUpperBoundId: Value(snapshotUpperBoundId),
      clientId: Value(clientId),
    );
  }

  factory ClientSnapshotEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientSnapshotEntriesTableData(
      snapshotUpperBoundId: serializer.fromJson<int>(
        json['snapshotUpperBoundId'],
      ),
      clientId: serializer.fromJson<String>(json['clientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'snapshotUpperBoundId': serializer.toJson<int>(snapshotUpperBoundId),
      'clientId': serializer.toJson<String>(clientId),
    };
  }

  ClientSnapshotEntriesTableData copyWith({
    int? snapshotUpperBoundId,
    String? clientId,
  }) => ClientSnapshotEntriesTableData(
    snapshotUpperBoundId: snapshotUpperBoundId ?? this.snapshotUpperBoundId,
    clientId: clientId ?? this.clientId,
  );
  ClientSnapshotEntriesTableData copyWithCompanion(
    ClientSnapshotEntriesTableCompanion data,
  ) {
    return ClientSnapshotEntriesTableData(
      snapshotUpperBoundId: data.snapshotUpperBoundId.present
          ? data.snapshotUpperBoundId.value
          : this.snapshotUpperBoundId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientSnapshotEntriesTableData(')
          ..write('snapshotUpperBoundId: $snapshotUpperBoundId, ')
          ..write('clientId: $clientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(snapshotUpperBoundId, clientId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientSnapshotEntriesTableData &&
          other.snapshotUpperBoundId == this.snapshotUpperBoundId &&
          other.clientId == this.clientId);
}

class ClientSnapshotEntriesTableCompanion
    extends UpdateCompanion<ClientSnapshotEntriesTableData> {
  final Value<int> snapshotUpperBoundId;
  final Value<String> clientId;
  final Value<int> rowid;
  const ClientSnapshotEntriesTableCompanion({
    this.snapshotUpperBoundId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientSnapshotEntriesTableCompanion.insert({
    required int snapshotUpperBoundId,
    required String clientId,
    this.rowid = const Value.absent(),
  }) : snapshotUpperBoundId = Value(snapshotUpperBoundId),
       clientId = Value(clientId);
  static Insertable<ClientSnapshotEntriesTableData> custom({
    Expression<int>? snapshotUpperBoundId,
    Expression<String>? clientId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (snapshotUpperBoundId != null)
        'snapshot_upper_bound_id': snapshotUpperBoundId,
      if (clientId != null) 'client_id': clientId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientSnapshotEntriesTableCompanion copyWith({
    Value<int>? snapshotUpperBoundId,
    Value<String>? clientId,
    Value<int>? rowid,
  }) {
    return ClientSnapshotEntriesTableCompanion(
      snapshotUpperBoundId: snapshotUpperBoundId ?? this.snapshotUpperBoundId,
      clientId: clientId ?? this.clientId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (snapshotUpperBoundId.present) {
      map['snapshot_upper_bound_id'] = Variable<int>(
        snapshotUpperBoundId.value,
      );
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientSnapshotEntriesTableCompanion(')
          ..write('snapshotUpperBoundId: $snapshotUpperBoundId, ')
          ..write('clientId: $clientId, ')
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
  late final $SyncLocksTableTable syncLocksTable = $SyncLocksTableTable(this);
  late final $LocalSalesTableTable localSalesTable = $LocalSalesTableTable(
    this,
  );
  late final $LocalSaleItemsTableTable localSaleItemsTable =
      $LocalSaleItemsTableTable(this);
  late final $ClientsTableTable clientsTable = $ClientsTableTable(this);
  late final $ClientSnapshotEntriesTableTable clientSnapshotEntriesTable =
      $ClientSnapshotEntriesTableTable(this);
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
    syncLocksTable,
    localSalesTable,
    localSaleItemsTable,
    clientsTable,
    clientSnapshotEntriesTable,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_sales',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('local_sale_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String id,
      Value<String?> clientRequestId,
      Value<String> operationType,
      Value<String?> localOperationId,
      Value<String> payloadJson,
      Value<int> payloadVersion,
      required String status,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      Value<String?> remoteIntentId,
      Value<String?> remoteSaleId,
      Value<String?> proposalJson,
      Value<int> proposalRevision,
      Value<String?> confirmationToken,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> id,
      Value<String?> clientRequestId,
      Value<String> operationType,
      Value<String?> localOperationId,
      Value<String> payloadJson,
      Value<int> payloadVersion,
      Value<String> status,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      Value<String?> remoteIntentId,
      Value<String?> remoteSaleId,
      Value<String?> proposalJson,
      Value<int> proposalRevision,
      Value<String?> confirmationToken,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
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

  ColumnFilters<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localOperationId => $composableBuilder(
    column: $table.localOperationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteIntentId => $composableBuilder(
    column: $table.remoteIntentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteSaleId => $composableBuilder(
    column: $table.remoteSaleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proposalJson => $composableBuilder(
    column: $table.proposalJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proposalRevision => $composableBuilder(
    column: $table.proposalRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmationToken => $composableBuilder(
    column: $table.confirmationToken,
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

  ColumnOrderings<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localOperationId => $composableBuilder(
    column: $table.localOperationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteIntentId => $composableBuilder(
    column: $table.remoteIntentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteSaleId => $composableBuilder(
    column: $table.remoteSaleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proposalJson => $composableBuilder(
    column: $table.proposalJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proposalRevision => $composableBuilder(
    column: $table.proposalRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmationToken => $composableBuilder(
    column: $table.confirmationToken,
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

  GeneratedColumn<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localOperationId => $composableBuilder(
    column: $table.localOperationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get remoteIntentId => $composableBuilder(
    column: $table.remoteIntentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteSaleId => $composableBuilder(
    column: $table.remoteSaleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proposalJson => $composableBuilder(
    column: $table.proposalJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get proposalRevision => $composableBuilder(
    column: $table.proposalRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confirmationToken => $composableBuilder(
    column: $table.confirmationToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
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
                Value<String?> clientRequestId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String?> localOperationId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> remoteIntentId = const Value.absent(),
                Value<String?> remoteSaleId = const Value.absent(),
                Value<String?> proposalJson = const Value.absent(),
                Value<int> proposalRevision = const Value.absent(),
                Value<String?> confirmationToken = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                id: id,
                clientRequestId: clientRequestId,
                operationType: operationType,
                localOperationId: localOperationId,
                payloadJson: payloadJson,
                payloadVersion: payloadVersion,
                status: status,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                remoteIntentId: remoteIntentId,
                remoteSaleId: remoteSaleId,
                proposalJson: proposalJson,
                proposalRevision: proposalRevision,
                confirmationToken: confirmationToken,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> clientRequestId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String?> localOperationId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                required String status,
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> remoteIntentId = const Value.absent(),
                Value<String?> remoteSaleId = const Value.absent(),
                Value<String?> proposalJson = const Value.absent(),
                Value<int> proposalRevision = const Value.absent(),
                Value<String?> confirmationToken = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                clientRequestId: clientRequestId,
                operationType: operationType,
                localOperationId: localOperationId,
                payloadJson: payloadJson,
                payloadVersion: payloadVersion,
                status: status,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                remoteIntentId: remoteIntentId,
                remoteSaleId: remoteSaleId,
                proposalJson: proposalJson,
                proposalRevision: proposalRevision,
                confirmationToken: confirmationToken,
                createdAt: createdAt,
                updatedAt: updatedAt,
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
typedef $$SyncLocksTableTableCreateCompanionBuilder =
    SyncLocksTableCompanion Function({
      required String name,
      required String ownerId,
      required int acquiredAt,
      required int expiresAt,
      Value<int> rowid,
    });
typedef $$SyncLocksTableTableUpdateCompanionBuilder =
    SyncLocksTableCompanion Function({
      Value<String> name,
      Value<String> ownerId,
      Value<int> acquiredAt,
      Value<int> expiresAt,
      Value<int> rowid,
    });

class $$SyncLocksTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLocksTableTable> {
  $$SyncLocksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncLocksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLocksTableTable> {
  $$SyncLocksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncLocksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLocksTableTable> {
  $$SyncLocksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<int> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$SyncLocksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncLocksTableTable,
          StoredSyncLock,
          $$SyncLocksTableTableFilterComposer,
          $$SyncLocksTableTableOrderingComposer,
          $$SyncLocksTableTableAnnotationComposer,
          $$SyncLocksTableTableCreateCompanionBuilder,
          $$SyncLocksTableTableUpdateCompanionBuilder,
          (
            StoredSyncLock,
            BaseReferences<_$AppDatabase, $SyncLocksTableTable, StoredSyncLock>,
          ),
          StoredSyncLock,
          PrefetchHooks Function()
        > {
  $$SyncLocksTableTableTableManager(
    _$AppDatabase db,
    $SyncLocksTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLocksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncLocksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncLocksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> name = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<int> acquiredAt = const Value.absent(),
                Value<int> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncLocksTableCompanion(
                name: name,
                ownerId: ownerId,
                acquiredAt: acquiredAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String name,
                required String ownerId,
                required int acquiredAt,
                required int expiresAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncLocksTableCompanion.insert(
                name: name,
                ownerId: ownerId,
                acquiredAt: acquiredAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncLocksTableTable, StoredSyncLock>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncLocksTableTable,
                    StoredSyncLock
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncLocksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncLocksTableTable,
      StoredSyncLock,
      $$SyncLocksTableTableFilterComposer,
      $$SyncLocksTableTableOrderingComposer,
      $$SyncLocksTableTableAnnotationComposer,
      $$SyncLocksTableTableCreateCompanionBuilder,
      $$SyncLocksTableTableUpdateCompanionBuilder,
      (
        StoredSyncLock,
        BaseReferences<_$AppDatabase, $SyncLocksTableTable, StoredSyncLock>,
      ),
      StoredSyncLock,
      PrefetchHooks Function()
    >;
typedef $$LocalSalesTableTableCreateCompanionBuilder =
    LocalSalesTableCompanion Function({
      required String id,
      required String clientRequestId,
      required String clientId,
      required String clientName,
      required DateTime soldAt,
      required String timezone,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalSalesTableTableUpdateCompanionBuilder =
    LocalSalesTableCompanion Function({
      Value<String> id,
      Value<String> clientRequestId,
      Value<String> clientId,
      Value<String> clientName,
      Value<DateTime> soldAt,
      Value<String> timezone,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$LocalSalesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $LocalSalesTableTable, StoredLocalSale> {
  $$LocalSalesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $LocalSaleItemsTableTable,
    List<StoredLocalSaleItem>
  >
  _localSaleItemsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.localSaleItemsTable,
        aliasName: 'local_sales__id__local_sale_items__sale_id',
      );

  $$LocalSaleItemsTableTableProcessedTableManager get localSaleItemsTableRefs {
    final manager = $$LocalSaleItemsTableTableTableManager(
      $_db,
      $_db.localSaleItemsTable,
    ).filter((f) => f.saleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _localSaleItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalSalesTableTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSalesTableTable> {
  $$LocalSalesTableTableFilterComposer({
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

  ColumnFilters<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
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

  Expression<bool> localSaleItemsTableRefs(
    Expression<bool> Function($$LocalSaleItemsTableTableFilterComposer f) f,
  ) {
    final $$LocalSaleItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.localSaleItemsTable,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalSaleItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.localSaleItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalSalesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSalesTableTable> {
  $$LocalSalesTableTableOrderingComposer({
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

  ColumnOrderings<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
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
}

class $$LocalSalesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSalesTableTable> {
  $$LocalSalesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get soldAt =>
      $composableBuilder(column: $table.soldAt, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> localSaleItemsTableRefs<T extends Object>(
    Expression<T> Function($$LocalSaleItemsTableTableAnnotationComposer a) f,
  ) {
    final $$LocalSaleItemsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.localSaleItemsTable,
          getReferencedColumn: (t) => t.saleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LocalSaleItemsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.localSaleItemsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LocalSalesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSalesTableTable,
          StoredLocalSale,
          $$LocalSalesTableTableFilterComposer,
          $$LocalSalesTableTableOrderingComposer,
          $$LocalSalesTableTableAnnotationComposer,
          $$LocalSalesTableTableCreateCompanionBuilder,
          $$LocalSalesTableTableUpdateCompanionBuilder,
          (StoredLocalSale, $$LocalSalesTableTableReferences),
          StoredLocalSale,
          PrefetchHooks Function({bool localSaleItemsTableRefs})
        > {
  $$LocalSalesTableTableTableManager(
    _$AppDatabase db,
    $LocalSalesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSalesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSalesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSalesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientRequestId = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> clientName = const Value.absent(),
                Value<DateTime> soldAt = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSalesTableCompanion(
                id: id,
                clientRequestId: clientRequestId,
                clientId: clientId,
                clientName: clientName,
                soldAt: soldAt,
                timezone: timezone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientRequestId,
                required String clientId,
                required String clientName,
                required DateTime soldAt,
                required String timezone,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalSalesTableCompanion.insert(
                id: id,
                clientRequestId: clientRequestId,
                clientId: clientId,
                clientName: clientName,
                soldAt: soldAt,
                timezone: timezone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSalesTableTable, StoredLocalSale>(table),
                  $$LocalSalesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({localSaleItemsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (localSaleItemsTableRefs) db.localSaleItemsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (localSaleItemsTableRefs)
                    await $_getPrefetchedData<
                      StoredLocalSale,
                      $LocalSalesTableTable,
                      StoredLocalSaleItem
                    >(
                      currentTable: table,
                      referencedTable: $$LocalSalesTableTableReferences
                          ._localSaleItemsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocalSalesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).localSaleItemsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.saleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocalSalesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSalesTableTable,
      StoredLocalSale,
      $$LocalSalesTableTableFilterComposer,
      $$LocalSalesTableTableOrderingComposer,
      $$LocalSalesTableTableAnnotationComposer,
      $$LocalSalesTableTableCreateCompanionBuilder,
      $$LocalSalesTableTableUpdateCompanionBuilder,
      (StoredLocalSale, $$LocalSalesTableTableReferences),
      StoredLocalSale,
      PrefetchHooks Function({bool localSaleItemsTableRefs})
    >;
typedef $$LocalSaleItemsTableTableCreateCompanionBuilder =
    LocalSaleItemsTableCompanion Function({
      Value<int> id,
      required String saleId,
      required String productId,
      required String productName,
      Value<String?> productSku,
      required int quantity,
      Value<double?> historicalUnitPrice,
    });
typedef $$LocalSaleItemsTableTableUpdateCompanionBuilder =
    LocalSaleItemsTableCompanion Function({
      Value<int> id,
      Value<String> saleId,
      Value<String> productId,
      Value<String> productName,
      Value<String?> productSku,
      Value<int> quantity,
      Value<double?> historicalUnitPrice,
    });

final class $$LocalSaleItemsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LocalSaleItemsTableTable,
          StoredLocalSaleItem
        > {
  $$LocalSaleItemsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalSalesTableTable _saleIdTable(_$AppDatabase db) => db
      .localSalesTable
      .createAlias('local_sale_items__sale_id__local_sales__id');

  $$LocalSalesTableTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<String>('sale_id')!;

    final manager = $$LocalSalesTableTableTableManager(
      $_db,
      $_db.localSalesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LocalSaleItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSaleItemsTableTable> {
  $$LocalSaleItemsTableTableFilterComposer({
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

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productSku => $composableBuilder(
    column: $table.productSku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get historicalUnitPrice => $composableBuilder(
    column: $table.historicalUnitPrice,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalSalesTableTableFilterComposer get saleId {
    final $$LocalSalesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.localSalesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalSalesTableTableFilterComposer(
            $db: $db,
            $table: $db.localSalesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalSaleItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSaleItemsTableTable> {
  $$LocalSaleItemsTableTableOrderingComposer({
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

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productSku => $composableBuilder(
    column: $table.productSku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get historicalUnitPrice => $composableBuilder(
    column: $table.historicalUnitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalSalesTableTableOrderingComposer get saleId {
    final $$LocalSalesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.localSalesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalSalesTableTableOrderingComposer(
            $db: $db,
            $table: $db.localSalesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalSaleItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSaleItemsTableTable> {
  $$LocalSaleItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productSku => $composableBuilder(
    column: $table.productSku,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get historicalUnitPrice => $composableBuilder(
    column: $table.historicalUnitPrice,
    builder: (column) => column,
  );

  $$LocalSalesTableTableAnnotationComposer get saleId {
    final $$LocalSalesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.localSalesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalSalesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.localSalesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalSaleItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSaleItemsTableTable,
          StoredLocalSaleItem,
          $$LocalSaleItemsTableTableFilterComposer,
          $$LocalSaleItemsTableTableOrderingComposer,
          $$LocalSaleItemsTableTableAnnotationComposer,
          $$LocalSaleItemsTableTableCreateCompanionBuilder,
          $$LocalSaleItemsTableTableUpdateCompanionBuilder,
          (StoredLocalSaleItem, $$LocalSaleItemsTableTableReferences),
          StoredLocalSaleItem,
          PrefetchHooks Function({bool saleId})
        > {
  $$LocalSaleItemsTableTableTableManager(
    _$AppDatabase db,
    $LocalSaleItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSaleItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSaleItemsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalSaleItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> productSku = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double?> historicalUnitPrice = const Value.absent(),
              }) => LocalSaleItemsTableCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                productName: productName,
                productSku: productSku,
                quantity: quantity,
                historicalUnitPrice: historicalUnitPrice,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String saleId,
                required String productId,
                required String productName,
                Value<String?> productSku = const Value.absent(),
                required int quantity,
                Value<double?> historicalUnitPrice = const Value.absent(),
              }) => LocalSaleItemsTableCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                productName: productName,
                productSku: productSku,
                quantity: quantity,
                historicalUnitPrice: historicalUnitPrice,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSaleItemsTableTable, StoredLocalSaleItem>(
                    table,
                  ),
                  $$LocalSaleItemsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({saleId = false}) {
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
                    if (saleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.saleId,
                                referencedTable:
                                    $$LocalSaleItemsTableTableReferences
                                        ._saleIdTable(db),
                                referencedColumn:
                                    $$LocalSaleItemsTableTableReferences
                                        ._saleIdTable(db)
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

typedef $$LocalSaleItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSaleItemsTableTable,
      StoredLocalSaleItem,
      $$LocalSaleItemsTableTableFilterComposer,
      $$LocalSaleItemsTableTableOrderingComposer,
      $$LocalSaleItemsTableTableAnnotationComposer,
      $$LocalSaleItemsTableTableCreateCompanionBuilder,
      $$LocalSaleItemsTableTableUpdateCompanionBuilder,
      (StoredLocalSaleItem, $$LocalSaleItemsTableTableReferences),
      StoredLocalSaleItem,
      PrefetchHooks Function({bool saleId})
    >;
typedef $$ClientsTableTableCreateCompanionBuilder =
    ClientsTableCompanion Function({
      required String id,
      required String name,
      Value<String?> city,
      Value<String?> state,
      Value<int> rowid,
    });
typedef $$ClientsTableTableUpdateCompanionBuilder =
    ClientsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> city,
      Value<String?> state,
      Value<int> rowid,
    });

class $$ClientsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTableTable> {
  $$ClientsTableTableFilterComposer({
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

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTableTable> {
  $$ClientsTableTableOrderingComposer({
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

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTableTable> {
  $$ClientsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);
}

class $$ClientsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTableTable,
          StoredClient,
          $$ClientsTableTableFilterComposer,
          $$ClientsTableTableOrderingComposer,
          $$ClientsTableTableAnnotationComposer,
          $$ClientsTableTableCreateCompanionBuilder,
          $$ClientsTableTableUpdateCompanionBuilder,
          (
            StoredClient,
            BaseReferences<_$AppDatabase, $ClientsTableTable, StoredClient>,
          ),
          StoredClient,
          PrefetchHooks Function()
        > {
  $$ClientsTableTableTableManager(_$AppDatabase db, $ClientsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsTableCompanion(
                id: id,
                name: name,
                city: city,
                state: state,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsTableCompanion.insert(
                id: id,
                name: name,
                city: city,
                state: state,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClientsTableTable, StoredClient>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ClientsTableTable,
                    StoredClient
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTableTable,
      StoredClient,
      $$ClientsTableTableFilterComposer,
      $$ClientsTableTableOrderingComposer,
      $$ClientsTableTableAnnotationComposer,
      $$ClientsTableTableCreateCompanionBuilder,
      $$ClientsTableTableUpdateCompanionBuilder,
      (
        StoredClient,
        BaseReferences<_$AppDatabase, $ClientsTableTable, StoredClient>,
      ),
      StoredClient,
      PrefetchHooks Function()
    >;
typedef $$ClientSnapshotEntriesTableTableCreateCompanionBuilder =
    ClientSnapshotEntriesTableCompanion Function({
      required int snapshotUpperBoundId,
      required String clientId,
      Value<int> rowid,
    });
typedef $$ClientSnapshotEntriesTableTableUpdateCompanionBuilder =
    ClientSnapshotEntriesTableCompanion Function({
      Value<int> snapshotUpperBoundId,
      Value<String> clientId,
      Value<int> rowid,
    });

class $$ClientSnapshotEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ClientSnapshotEntriesTableTable> {
  $$ClientSnapshotEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get snapshotUpperBoundId => $composableBuilder(
    column: $table.snapshotUpperBoundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientSnapshotEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientSnapshotEntriesTableTable> {
  $$ClientSnapshotEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get snapshotUpperBoundId => $composableBuilder(
    column: $table.snapshotUpperBoundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientSnapshotEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientSnapshotEntriesTableTable> {
  $$ClientSnapshotEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get snapshotUpperBoundId => $composableBuilder(
    column: $table.snapshotUpperBoundId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);
}

class $$ClientSnapshotEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientSnapshotEntriesTableTable,
          ClientSnapshotEntriesTableData,
          $$ClientSnapshotEntriesTableTableFilterComposer,
          $$ClientSnapshotEntriesTableTableOrderingComposer,
          $$ClientSnapshotEntriesTableTableAnnotationComposer,
          $$ClientSnapshotEntriesTableTableCreateCompanionBuilder,
          $$ClientSnapshotEntriesTableTableUpdateCompanionBuilder,
          (
            ClientSnapshotEntriesTableData,
            BaseReferences<
              _$AppDatabase,
              $ClientSnapshotEntriesTableTable,
              ClientSnapshotEntriesTableData
            >,
          ),
          ClientSnapshotEntriesTableData,
          PrefetchHooks Function()
        > {
  $$ClientSnapshotEntriesTableTableTableManager(
    _$AppDatabase db,
    $ClientSnapshotEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientSnapshotEntriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ClientSnapshotEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ClientSnapshotEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> snapshotUpperBoundId = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientSnapshotEntriesTableCompanion(
                snapshotUpperBoundId: snapshotUpperBoundId,
                clientId: clientId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int snapshotUpperBoundId,
                required String clientId,
                Value<int> rowid = const Value.absent(),
              }) => ClientSnapshotEntriesTableCompanion.insert(
                snapshotUpperBoundId: snapshotUpperBoundId,
                clientId: clientId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ClientSnapshotEntriesTableTable,
                    ClientSnapshotEntriesTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ClientSnapshotEntriesTableTable,
                    ClientSnapshotEntriesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientSnapshotEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientSnapshotEntriesTableTable,
      ClientSnapshotEntriesTableData,
      $$ClientSnapshotEntriesTableTableFilterComposer,
      $$ClientSnapshotEntriesTableTableOrderingComposer,
      $$ClientSnapshotEntriesTableTableAnnotationComposer,
      $$ClientSnapshotEntriesTableTableCreateCompanionBuilder,
      $$ClientSnapshotEntriesTableTableUpdateCompanionBuilder,
      (
        ClientSnapshotEntriesTableData,
        BaseReferences<
          _$AppDatabase,
          $ClientSnapshotEntriesTableTable,
          ClientSnapshotEntriesTableData
        >,
      ),
      ClientSnapshotEntriesTableData,
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
  $$SyncLocksTableTableTableManager get syncLocksTable =>
      $$SyncLocksTableTableTableManager(_db, _db.syncLocksTable);
  $$LocalSalesTableTableTableManager get localSalesTable =>
      $$LocalSalesTableTableTableManager(_db, _db.localSalesTable);
  $$LocalSaleItemsTableTableTableManager get localSaleItemsTable =>
      $$LocalSaleItemsTableTableTableManager(_db, _db.localSaleItemsTable);
  $$ClientsTableTableTableManager get clientsTable =>
      $$ClientsTableTableTableManager(_db, _db.clientsTable);
  $$ClientSnapshotEntriesTableTableTableManager
  get clientSnapshotEntriesTable =>
      $$ClientSnapshotEntriesTableTableTableManager(
        _db,
        _db.clientSnapshotEntriesTable,
      );
}
