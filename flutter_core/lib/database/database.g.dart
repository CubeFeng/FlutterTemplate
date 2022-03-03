// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MessageDao? _messageDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MessageEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `create_time` INTEGER NOT NULL, `update_time` INTEGER NOT NULL, `app_id` TEXT NOT NULL, `app_name` TEXT NOT NULL, `icon` TEXT NOT NULL, `reciver` TEXT NOT NULL, `sender` TEXT NOT NULL, `is_read` INTEGER NOT NULL, `msg_id` TEXT NOT NULL, `user_id` TEXT NOT NULL, `vo` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MessageDao get messageDao {
    return _messageDaoInstance ??= _$MessageDao(database, changeListener);
  }
}

class _$MessageDao extends MessageDao {
  _$MessageDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _messageEntityInsertionAdapter = InsertionAdapter(
            database,
            'MessageEntity',
            (MessageEntity item) => <String, Object?>{
                  'id': item.id,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime),
                  'app_id': item.appId,
                  'app_name': item.appName,
                  'icon': item.icon,
                  'reciver': item.reciver,
                  'sender': item.sender,
                  'is_read': item.isRead ? 1 : 0,
                  'msg_id': item.msgId,
                  'user_id': item.userId,
                  'vo': _messageContentConverter.encode(item.vo)
                }),
        _messageEntityUpdateAdapter = UpdateAdapter(
            database,
            'MessageEntity',
            ['id'],
            (MessageEntity item) => <String, Object?>{
                  'id': item.id,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime),
                  'app_id': item.appId,
                  'app_name': item.appName,
                  'icon': item.icon,
                  'reciver': item.reciver,
                  'sender': item.sender,
                  'is_read': item.isRead ? 1 : 0,
                  'msg_id': item.msgId,
                  'user_id': item.userId,
                  'vo': _messageContentConverter.encode(item.vo)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MessageEntity> _messageEntityInsertionAdapter;

  final UpdateAdapter<MessageEntity> _messageEntityUpdateAdapter;

  @override
  Future<List<MessageEntity>> findAllByUserId(String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MessageEntity WHERE user_id=?1 ORDER BY create_time DESC',
        mapper: (Map<String, Object?> row) => MessageEntity(row['id'] as int?, row['app_id'] as String, row['app_name'] as String, row['icon'] as String, row['reciver'] as String, row['sender'] as String, (row['is_read'] as int) != 0, row['msg_id'] as String, row['user_id'] as String, _messageContentConverter.decode(row['vo'] as String), _dateTimeConverter.decode(row['create_time'] as int), _dateTimeConverter.decode(row['update_time'] as int)),
        arguments: [userId]);
  }

  @override
  Future<MessageEntity?> findMessageById(int id) async {
    return _queryAdapter.query('SELECT * FROM MessageEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MessageEntity(
            row['id'] as int?,
            row['app_id'] as String,
            row['app_name'] as String,
            row['icon'] as String,
            row['reciver'] as String,
            row['sender'] as String,
            (row['is_read'] as int) != 0,
            row['msg_id'] as String,
            row['user_id'] as String,
            _messageContentConverter.decode(row['vo'] as String),
            _dateTimeConverter.decode(row['create_time'] as int),
            _dateTimeConverter.decode(row['update_time'] as int)),
        arguments: [id]);
  }

  @override
  Future<int> insertMessage(MessageEntity message) {
    return _messageEntityInsertionAdapter.insertAndReturnId(
        message, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateMessage(List<MessageEntity> messages) {
    return _messageEntityUpdateAdapter.updateListAndReturnChangedRows(
        messages, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateMessag(MessageEntity message) {
    return _messageEntityUpdateAdapter.updateAndReturnChangedRows(
        message, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _messageContentConverter = MessageContentConverter();
