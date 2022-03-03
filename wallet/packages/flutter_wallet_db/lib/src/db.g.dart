// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorWalletDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$WalletDatabaseBuilder databaseBuilder(String name,
          [String? password]) =>
      _$WalletDatabaseBuilder(name, password);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$WalletDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$WalletDatabaseBuilder(null, null);
}

class _$WalletDatabaseBuilder {
  _$WalletDatabaseBuilder(this.name, this.password);

  final String? name;

  final String? password;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$WalletDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$WalletDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<WalletDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$WalletDatabase();
    database.database = await database.open(
      path,
      password,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$WalletDatabase extends WalletDatabase {
  _$WalletDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AddressDao? _addressDaoInstance;

  CoinDao? _coinDaoInstance;

  TokenDao? _tokenDaoInstance;

  TxDao? _txDaoInstance;

  WalletDao? _walletDaoInstance;

  Future<sqflite.Database> open(
      String path, String? password, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.SqlCipherOpenDatabaseOptions(
      version: 1,
      password: password,
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
            'CREATE TABLE IF NOT EXISTS `tb_address` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `coin_type` TEXT, `coin_address` TEXT, `remark` TEXT, `create_time` INTEGER, `update_time` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tb_coin` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `wallet_id` INTEGER, `private_key` TEXT, `public_key` TEXT, `coin_type` TEXT, `coin_name` TEXT, `coin_address` TEXT, `coin_unit` TEXT, `coin_decimals` INTEGER, `sort_index` INTEGER, `create_time` INTEGER, `update_time` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tb_tx` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `coin_id` INTEGER, `coin_type` TEXT, `token_id` INTEGER, `token_type` TEXT, `tx_hash` TEXT, `tx_time` INTEGER, `from_address` TEXT, `to_address` TEXT, `amount` TEXT, `fee` TEXT, `remark` TEXT, `tx_index` INTEGER, `tx_status` INTEGER, `block_number` INTEGER, `block_hash` TEXT, `trx_net_usage` INTEGER, `trx_enery_usage` INTEGER, `trx_net_fee` INTEGER, `create_time` INTEGER, `update_time` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tb_token` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `coin_id` INTEGER, `coin_type` TEXT, `token_name` TEXT, `token_type` TEXT, `contract_address` TEXT, `token_icon` TEXT, `token_unit` TEXT, `token_decimals` INTEGER, `author` TEXT, `platform` TEXT, `description` TEXT, `dapp_url` TEXT, `token_url` TEXT, `sort_index` INTEGER, `create_time` INTEGER, `update_time` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tb_wallet` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `wallet_name` TEXT, `wallet_type` INTEGER, `mnemonic` TEXT, `wallet_source` INTEGER, `create_time` INTEGER, `update_time` INTEGER)');
        await database.execute(
            'CREATE INDEX `index_tb_coin_wallet_id` ON `tb_coin` (`wallet_id`)');
        await database.execute(
            'CREATE INDEX `index_tb_tx_coin_id` ON `tb_tx` (`coin_id`)');
        await database.execute(
            'CREATE INDEX `index_tb_tx_token_id` ON `tb_tx` (`token_id`)');
        await database.execute(
            'CREATE INDEX `index_tb_token_coin_id` ON `tb_token` (`coin_id`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AddressDao get addressDao {
    return _addressDaoInstance ??= _$AddressDao(database, changeListener);
  }

  @override
  CoinDao get coinDao {
    return _coinDaoInstance ??= _$CoinDao(database, changeListener);
  }

  @override
  TokenDao get tokenDao {
    return _tokenDaoInstance ??= _$TokenDao(database, changeListener);
  }

  @override
  TxDao get txDao {
    return _txDaoInstance ??= _$TxDao(database, changeListener);
  }

  @override
  WalletDao get walletDao {
    return _walletDaoInstance ??= _$WalletDao(database, changeListener);
  }
}

class _$AddressDao extends AddressDao {
  _$AddressDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _addressInsertionAdapter = InsertionAdapter(
            database,
            'tb_address',
            (Address item) => <String, Object?>{
                  '_id': item.id,
                  'name': item.name,
                  'coin_type': item.coinType,
                  'coin_address': item.coinAddress,
                  'remark': item.remark,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                }),
        _addressDeletionAdapter = DeletionAdapter(
            database,
            'tb_address',
            ['_id'],
            (Address item) => <String, Object?>{
                  '_id': item.id,
                  'name': item.name,
                  'coin_type': item.coinType,
                  'coin_address': item.coinAddress,
                  'remark': item.remark,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Address> _addressInsertionAdapter;

  final DeletionAdapter<Address> _addressDeletionAdapter;

  @override
  Future<List<Address>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM tb_address',
        mapper: (Map<String, Object?> row) => Address(
            id: row['_id'] as int?,
            name: row['name'] as String?,
            coinType: row['coin_type'] as String?,
            coinAddress: row['coin_address'] as String?,
            remark: row['remark'] as String?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)));
  }

  @override
  Future<Address?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM tb_address WHERE _id = ?1',
        mapper: (Map<String, Object?> row) => Address(
            id: row['_id'] as int?,
            name: row['name'] as String?,
            coinType: row['coin_type'] as String?,
            coinAddress: row['coin_address'] as String?,
            remark: row['remark'] as String?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [id]);
  }

  @override
  Future<List<Address>> findByType(String coin_type) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_address WHERE coin_type = ?1',
        mapper: (Map<String, Object?> row) => Address(
            id: row['_id'] as int?,
            name: row['name'] as String?,
            coinType: row['coin_type'] as String?,
            coinAddress: row['coin_address'] as String?,
            remark: row['remark'] as String?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [coin_type]);
  }

  @override
  Future<int> saveAndReturnId(Address address) {
    return _addressInsertionAdapter.insertAndReturnId(
        address, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteAndReturnChangedRows(Address address) {
    return _addressDeletionAdapter.deleteAndReturnChangedRows(address);
  }
}

class _$CoinDao extends CoinDao {
  _$CoinDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _coinInsertionAdapter = InsertionAdapter(
            database,
            'tb_coin',
            (Coin item) => <String, Object?>{
                  '_id': item.id,
                  'wallet_id': item.walletId,
                  'private_key': item.privateKey,
                  'public_key': item.publicKey,
                  'coin_type': item.coinType,
                  'coin_name': item.coinName,
                  'coin_address': item.coinAddress,
                  'coin_unit': item.coinUnit,
                  'coin_decimals': item.coinDecimals,
                  'sort_index': item.sortIndex,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                }),
        _coinDeletionAdapter = DeletionAdapter(
            database,
            'tb_coin',
            ['_id'],
            (Coin item) => <String, Object?>{
                  '_id': item.id,
                  'wallet_id': item.walletId,
                  'private_key': item.privateKey,
                  'public_key': item.publicKey,
                  'coin_type': item.coinType,
                  'coin_name': item.coinName,
                  'coin_address': item.coinAddress,
                  'coin_unit': item.coinUnit,
                  'coin_decimals': item.coinDecimals,
                  'sort_index': item.sortIndex,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Coin> _coinInsertionAdapter;

  final DeletionAdapter<Coin> _coinDeletionAdapter;

  @override
  Future<List<Coin>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM tb_coin ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Coin(
            id: row['_id'] as int?,
            walletId: row['wallet_id'] as int?,
            privateKey: row['private_key'] as String?,
            publicKey: row['public_key'] as String?,
            coinType: row['coin_type'] as String?,
            coinName: row['coin_name'] as String?,
            coinAddress: row['coin_address'] as String?,
            coinUnit: row['coin_unit'] as String?,
            coinDecimals: row['coin_decimals'] as int?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)));
  }

  @override
  Future<Coin?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM tb_coin WHERE _id = ?1',
        mapper: (Map<String, Object?> row) => Coin(
            id: row['_id'] as int?,
            walletId: row['wallet_id'] as int?,
            privateKey: row['private_key'] as String?,
            publicKey: row['public_key'] as String?,
            coinType: row['coin_type'] as String?,
            coinName: row['coin_name'] as String?,
            coinAddress: row['coin_address'] as String?,
            coinUnit: row['coin_unit'] as String?,
            coinDecimals: row['coin_decimals'] as int?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [id]);
  }

  @override
  Future<List<Coin>> findAllByCoinType(String coinType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_coin WHERE coin_type = ?1 ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Coin(
            id: row['_id'] as int?,
            walletId: row['wallet_id'] as int?,
            privateKey: row['private_key'] as String?,
            publicKey: row['public_key'] as String?,
            coinType: row['coin_type'] as String?,
            coinName: row['coin_name'] as String?,
            coinAddress: row['coin_address'] as String?,
            coinUnit: row['coin_unit'] as String?,
            coinDecimals: row['coin_decimals'] as int?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [coinType]);
  }

  @override
  Future<List<Coin>> findAllByWalletId(int wallet_id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_coin WHERE wallet_id = ?1 ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Coin(
            id: row['_id'] as int?,
            walletId: row['wallet_id'] as int?,
            privateKey: row['private_key'] as String?,
            publicKey: row['public_key'] as String?,
            coinType: row['coin_type'] as String?,
            coinName: row['coin_name'] as String?,
            coinAddress: row['coin_address'] as String?,
            coinUnit: row['coin_unit'] as String?,
            coinDecimals: row['coin_decimals'] as int?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [wallet_id]);
  }

  @override
  Future<List<Coin>> findAllByCoinAddress(
      String coinType, String coinAddress) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_coin     WHERE coin_type = ?1 AND coin_address = ?2     ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Coin(id: row['_id'] as int?, walletId: row['wallet_id'] as int?, privateKey: row['private_key'] as String?, publicKey: row['public_key'] as String?, coinType: row['coin_type'] as String?, coinName: row['coin_name'] as String?, coinAddress: row['coin_address'] as String?, coinUnit: row['coin_unit'] as String?, coinDecimals: row['coin_decimals'] as int?, sortIndex: row['sort_index'] as int?, createTime: _dateTimeConverter.decode(row['create_time'] as int?), updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [coinType, coinAddress]);
  }

  @override
  Future<int> saveAndReturnId(Coin coin) {
    return _coinInsertionAdapter.insertAndReturnId(
        coin, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteAndReturnChangedRows(Coin coin) {
    return _coinDeletionAdapter.deleteAndReturnChangedRows(coin);
  }
}

class _$TokenDao extends TokenDao {
  _$TokenDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tokenInsertionAdapter = InsertionAdapter(
            database,
            'tb_token',
            (Token item) => <String, Object?>{
                  '_id': item.id,
                  'coin_id': item.coinId,
                  'coin_type': item.coinType,
                  'token_name': item.tokenName,
                  'token_type': item.tokenType,
                  'contract_address': item.contractAddress,
                  'token_icon': item.tokenIcon,
                  'token_unit': item.tokenUnit,
                  'token_decimals': item.tokenDecimals,
                  'author': item.author,
                  'platform': item.platform,
                  'description': item.description,
                  'dapp_url': item.dappUrl,
                  'token_url': item.tokenUrl,
                  'sort_index': item.sortIndex,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                }),
        _tokenDeletionAdapter = DeletionAdapter(
            database,
            'tb_token',
            ['_id'],
            (Token item) => <String, Object?>{
                  '_id': item.id,
                  'coin_id': item.coinId,
                  'coin_type': item.coinType,
                  'token_name': item.tokenName,
                  'token_type': item.tokenType,
                  'contract_address': item.contractAddress,
                  'token_icon': item.tokenIcon,
                  'token_unit': item.tokenUnit,
                  'token_decimals': item.tokenDecimals,
                  'author': item.author,
                  'platform': item.platform,
                  'description': item.description,
                  'dapp_url': item.dappUrl,
                  'token_url': item.tokenUrl,
                  'sort_index': item.sortIndex,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Token> _tokenInsertionAdapter;

  final DeletionAdapter<Token> _tokenDeletionAdapter;

  @override
  Future<List<Token>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM tb_token ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Token(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenName: row['token_name'] as String?,
            tokenType: row['token_type'] as String?,
            contractAddress: row['contract_address'] as String?,
            tokenIcon: row['token_icon'] as String?,
            tokenUnit: row['token_unit'] as String?,
            tokenDecimals: row['token_decimals'] as int?,
            author: row['author'] as String?,
            platform: row['platform'] as String?,
            description: row['description'] as String?,
            dappUrl: row['dapp_url'] as String?,
            tokenUrl: row['token_url'] as String?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)));
  }

  @override
  Future<Token?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM tb_token WHERE _id = ?1',
        mapper: (Map<String, Object?> row) => Token(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenName: row['token_name'] as String?,
            tokenType: row['token_type'] as String?,
            contractAddress: row['contract_address'] as String?,
            tokenIcon: row['token_icon'] as String?,
            tokenUnit: row['token_unit'] as String?,
            tokenDecimals: row['token_decimals'] as int?,
            author: row['author'] as String?,
            platform: row['platform'] as String?,
            description: row['description'] as String?,
            dappUrl: row['dapp_url'] as String?,
            tokenUrl: row['token_url'] as String?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [id]);
  }

  @override
  Future<List<Token>> findAllByCoinId(int coinId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_token WHERE coin_id = ?1 ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Token(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenName: row['token_name'] as String?,
            tokenType: row['token_type'] as String?,
            contractAddress: row['contract_address'] as String?,
            tokenIcon: row['token_icon'] as String?,
            tokenUnit: row['token_unit'] as String?,
            tokenDecimals: row['token_decimals'] as int?,
            author: row['author'] as String?,
            platform: row['platform'] as String?,
            description: row['description'] as String?,
            dappUrl: row['dapp_url'] as String?,
            tokenUrl: row['token_url'] as String?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [coinId]);
  }

  @override
  Future<List<Token>> findAllByCoinType(String coinType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_token WHERE coin_type = ?1 ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Token(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenName: row['token_name'] as String?,
            tokenType: row['token_type'] as String?,
            contractAddress: row['contract_address'] as String?,
            tokenIcon: row['token_icon'] as String?,
            tokenUnit: row['token_unit'] as String?,
            tokenDecimals: row['token_decimals'] as int?,
            author: row['author'] as String?,
            platform: row['platform'] as String?,
            description: row['description'] as String?,
            dappUrl: row['dapp_url'] as String?,
            tokenUrl: row['token_url'] as String?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [coinType]);
  }

  @override
  Future<List<Token>> findAllByTokenType(String tokenType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_token WHERE token_type = ?1 ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Token(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenName: row['token_name'] as String?,
            tokenType: row['token_type'] as String?,
            contractAddress: row['contract_address'] as String?,
            tokenIcon: row['token_icon'] as String?,
            tokenUnit: row['token_unit'] as String?,
            tokenDecimals: row['token_decimals'] as int?,
            author: row['author'] as String?,
            platform: row['platform'] as String?,
            description: row['description'] as String?,
            dappUrl: row['dapp_url'] as String?,
            tokenUrl: row['token_url'] as String?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [tokenType]);
  }

  @override
  Future<List<Token>> findAllByCoinTypeAndTokenType(
      String coinType, String tokenType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_token WHERE coin_type = ?1 AND token_type = ?2 ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Token(id: row['_id'] as int?, coinId: row['coin_id'] as int?, coinType: row['coin_type'] as String?, tokenName: row['token_name'] as String?, tokenType: row['token_type'] as String?, contractAddress: row['contract_address'] as String?, tokenIcon: row['token_icon'] as String?, tokenUnit: row['token_unit'] as String?, tokenDecimals: row['token_decimals'] as int?, author: row['author'] as String?, platform: row['platform'] as String?, description: row['description'] as String?, dappUrl: row['dapp_url'] as String?, tokenUrl: row['token_url'] as String?, sortIndex: row['sort_index'] as int?, createTime: _dateTimeConverter.decode(row['create_time'] as int?), updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [coinType, tokenType]);
  }

  @override
  Future<List<Token>> findAllByCoinAddress(String coinAddress) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_coin WHERE coin_address = ?1 ORDER BY sort_index',
        mapper: (Map<String, Object?> row) => Token(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenName: row['token_name'] as String?,
            tokenType: row['token_type'] as String?,
            contractAddress: row['contract_address'] as String?,
            tokenIcon: row['token_icon'] as String?,
            tokenUnit: row['token_unit'] as String?,
            tokenDecimals: row['token_decimals'] as int?,
            author: row['author'] as String?,
            platform: row['platform'] as String?,
            description: row['description'] as String?,
            dappUrl: row['dapp_url'] as String?,
            tokenUrl: row['token_url'] as String?,
            sortIndex: row['sort_index'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [coinAddress]);
  }

  @override
  Future<int> saveAndReturnId(Token user) {
    return _tokenInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteAndReturnChangedRows(Token user) {
    return _tokenDeletionAdapter.deleteAndReturnChangedRows(user);
  }
}

class _$TxDao extends TxDao {
  _$TxDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _txInsertionAdapter = InsertionAdapter(
            database,
            'tb_tx',
            (Tx item) => <String, Object?>{
                  '_id': item.id,
                  'coin_id': item.coinId,
                  'coin_type': item.coinType,
                  'token_id': item.tokenId,
                  'token_type': item.tokenType,
                  'tx_hash': item.txHash,
                  'tx_time': _dateTimeConverter.encode(item.txTime),
                  'from_address': item.fromAddress,
                  'to_address': item.toAddress,
                  'amount': _bigIntConverter.encode(item.amount),
                  'fee': _bigIntConverter.encode(item.fee),
                  'remark': item.remark,
                  'tx_index': item.txIndex,
                  'tx_status': _txStatusConverter.encode(item.txStatus),
                  'block_number': item.blockNumber,
                  'block_hash': item.blockHash,
                  'trx_net_usage': item.trxNetUsage,
                  'trx_enery_usage': item.trxEneryUsage,
                  'trx_net_fee': item.trxNetFee,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                }),
        _txDeletionAdapter = DeletionAdapter(
            database,
            'tb_tx',
            ['_id'],
            (Tx item) => <String, Object?>{
                  '_id': item.id,
                  'coin_id': item.coinId,
                  'coin_type': item.coinType,
                  'token_id': item.tokenId,
                  'token_type': item.tokenType,
                  'tx_hash': item.txHash,
                  'tx_time': _dateTimeConverter.encode(item.txTime),
                  'from_address': item.fromAddress,
                  'to_address': item.toAddress,
                  'amount': _bigIntConverter.encode(item.amount),
                  'fee': _bigIntConverter.encode(item.fee),
                  'remark': item.remark,
                  'tx_index': item.txIndex,
                  'tx_status': _txStatusConverter.encode(item.txStatus),
                  'block_number': item.blockNumber,
                  'block_hash': item.blockHash,
                  'trx_net_usage': item.trxNetUsage,
                  'trx_enery_usage': item.trxEneryUsage,
                  'trx_net_fee': item.trxNetFee,
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tx> _txInsertionAdapter;

  final DeletionAdapter<Tx> _txDeletionAdapter;

  @override
  Future<List<Tx>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM tb_tx',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)));
  }

  @override
  Future<Tx?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM tb_tx WHERE _id = ?1',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [id]);
  }

  @override
  Future<List<Tx>> findByTXHash(String txHash) async {
    return _queryAdapter.queryList('SELECT * FROM tb_tx WHERE tx_hash = ?1',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [txHash]);
  }

  @override
  Future<List<Tx>> findByCoinType(String coin_type) async {
    return _queryAdapter.queryList('SELECT * FROM tb_tx WHERE coin_type = ?1',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [coin_type]);
  }

  @override
  Future<List<Tx>> findByCoinTypeAndTime(
      String coin_type, String address, DateTime from, DateTime to) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_tx WHERE coin_type = ?1 AND (from_address = ?2 or to_address = ?2) AND tx_time > ?3 AND tx_time < ?4 order by tx_time desc',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [
          coin_type,
          address,
          _dateTimeNotNullConverter.encode(from),
          _dateTimeNotNullConverter.encode(to)
        ]);
  }

  @override
  Future<List<Tx>> findTOutByCoinTypeAndTime(
      String coin_type, String address, DateTime from, DateTime to) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_tx WHERE coin_type = ?1 AND from_address = ?2 AND tx_time > ?3 AND tx_time < ?4 order by tx_time desc',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [
          coin_type,
          address,
          _dateTimeNotNullConverter.encode(from),
          _dateTimeNotNullConverter.encode(to)
        ]);
  }

  @override
  Future<List<Tx>> findTInByCoinTypeAndTime(
      String coin_type, String address, DateTime from, DateTime to) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_tx WHERE coin_type = ?1 AND to_address = ?2 AND tx_time > ?3 AND tx_time < ?4 order by tx_time desc',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [
          coin_type,
          address,
          _dateTimeNotNullConverter.encode(from),
          _dateTimeNotNullConverter.encode(to)
        ]);
  }

  @override
  Future<List<Tx>> findByTokenAndTime(String coin_type, String contractAddress,
      String address, DateTime from, DateTime to) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_tx WHERE coin_type = ?1 AND token_type = ?2 AND (from_address = ?3 or to_address = ?3) AND tx_time > ?4 AND tx_time < ?5 order by tx_time desc',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [
          coin_type,
          contractAddress,
          address,
          _dateTimeNotNullConverter.encode(from),
          _dateTimeNotNullConverter.encode(to)
        ]);
  }

  @override
  Future<List<Tx>> findTOutByTokenAndTime(
      String coin_type,
      String contractAddress,
      String address,
      DateTime from,
      DateTime to) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_tx WHERE coin_type = ?1 AND token_type = ?2 AND from_address = ?3 AND tx_time > ?4 AND tx_time < ?5 order by tx_time desc',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [
          coin_type,
          contractAddress,
          address,
          _dateTimeNotNullConverter.encode(from),
          _dateTimeNotNullConverter.encode(to)
        ]);
  }

  @override
  Future<List<Tx>> findTInByTokenAndTime(
      String coin_type,
      String contractAddress,
      String address,
      DateTime from,
      DateTime to) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_tx WHERE coin_type = ?1 AND token_type = ?2 AND to_address =?3 AND tx_time > ?4 AND tx_time < ?5 order by tx_time desc',
        mapper: (Map<String, Object?> row) => Tx(
            id: row['_id'] as int?,
            coinId: row['coin_id'] as int?,
            coinType: row['coin_type'] as String?,
            tokenId: row['token_id'] as int?,
            tokenType: row['token_type'] as String?,
            txHash: row['tx_hash'] as String?,
            txTime: _dateTimeConverter.decode(row['tx_time'] as int?),
            fromAddress: row['from_address'] as String?,
            toAddress: row['to_address'] as String?,
            amount: _bigIntConverter.decode(row['amount'] as String?),
            fee: _bigIntConverter.decode(row['fee'] as String?),
            remark: row['remark'] as String?,
            txIndex: row['tx_index'] as int?,
            txStatus: _txStatusConverter.decode(row['tx_status'] as int?),
            blockNumber: row['block_number'] as int?,
            blockHash: row['block_hash'] as String?,
            trxNetUsage: row['trx_net_usage'] as int?,
            trxEneryUsage: row['trx_enery_usage'] as int?,
            trxNetFee: row['trx_net_fee'] as int?,
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [
          coin_type,
          contractAddress,
          address,
          _dateTimeNotNullConverter.encode(from),
          _dateTimeNotNullConverter.encode(to)
        ]);
  }

  @override
  Future<List<Tx>> findNft(String coin_type, String contractAddress) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_tx WHERE coin_type = ?1 AND token_type = ?2 order by tx_time desc',
        mapper: (Map<String, Object?> row) => Tx(id: row['_id'] as int?, coinId: row['coin_id'] as int?, coinType: row['coin_type'] as String?, tokenId: row['token_id'] as int?, tokenType: row['token_type'] as String?, txHash: row['tx_hash'] as String?, txTime: _dateTimeConverter.decode(row['tx_time'] as int?), fromAddress: row['from_address'] as String?, toAddress: row['to_address'] as String?, amount: _bigIntConverter.decode(row['amount'] as String?), fee: _bigIntConverter.decode(row['fee'] as String?), remark: row['remark'] as String?, txIndex: row['tx_index'] as int?, txStatus: _txStatusConverter.decode(row['tx_status'] as int?), blockNumber: row['block_number'] as int?, blockHash: row['block_hash'] as String?, trxNetUsage: row['trx_net_usage'] as int?, trxEneryUsage: row['trx_enery_usage'] as int?, trxNetFee: row['trx_net_fee'] as int?, createTime: _dateTimeConverter.decode(row['create_time'] as int?), updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [coin_type, contractAddress]);
  }

  @override
  Future<int> saveAndReturnId(Tx tx) {
    return _txInsertionAdapter.insertAndReturnId(
        tx, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteAndReturnChangedRows(Tx tx) {
    return _txDeletionAdapter.deleteAndReturnChangedRows(tx);
  }
}

class _$WalletDao extends WalletDao {
  _$WalletDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _walletInsertionAdapter = InsertionAdapter(
            database,
            'tb_wallet',
            (Wallet item) => <String, Object?>{
                  '_id': item.id,
                  'wallet_name': item.walletName,
                  'wallet_type': _walletTypeConverter.encode(item.walletType),
                  'mnemonic': item.mnemonic,
                  'wallet_source':
                      _walletSourceConverter.encode(item.walletSource),
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                }),
        _walletDeletionAdapter = DeletionAdapter(
            database,
            'tb_wallet',
            ['_id'],
            (Wallet item) => <String, Object?>{
                  '_id': item.id,
                  'wallet_name': item.walletName,
                  'wallet_type': _walletTypeConverter.encode(item.walletType),
                  'mnemonic': item.mnemonic,
                  'wallet_source':
                      _walletSourceConverter.encode(item.walletSource),
                  'create_time': _dateTimeConverter.encode(item.createTime),
                  'update_time': _dateTimeConverter.encode(item.updateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Wallet> _walletInsertionAdapter;

  final DeletionAdapter<Wallet> _walletDeletionAdapter;

  @override
  Future<List<Wallet>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM tb_wallet',
        mapper: (Map<String, Object?> row) => Wallet(
            id: row['_id'] as int?,
            walletName: row['wallet_name'] as String?,
            walletType: _walletTypeConverter.decode(row['wallet_type'] as int?),
            mnemonic: row['mnemonic'] as String?,
            walletSource:
                _walletSourceConverter.decode(row['wallet_source'] as int?),
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)));
  }

  @override
  Future<Wallet?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM tb_wallet WHERE _id = ?1',
        mapper: (Map<String, Object?> row) => Wallet(
            id: row['_id'] as int?,
            walletName: row['wallet_name'] as String?,
            walletType: _walletTypeConverter.decode(row['wallet_type'] as int?),
            mnemonic: row['mnemonic'] as String?,
            walletSource:
                _walletSourceConverter.decode(row['wallet_source'] as int?),
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [id]);
  }

  @override
  Future<Wallet?> findByMnemonic(String mnemonic) async {
    return _queryAdapter.query(
        'SELECT * FROM tb_wallet WHERE mnemonic = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => Wallet(
            id: row['_id'] as int?,
            walletName: row['wallet_name'] as String?,
            walletType: _walletTypeConverter.decode(row['wallet_type'] as int?),
            mnemonic: row['mnemonic'] as String?,
            walletSource:
                _walletSourceConverter.decode(row['wallet_source'] as int?),
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [mnemonic]);
  }

  @override
  Future<List<Wallet>> findAllByMnemonic(String mnemonic) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tb_wallet WHERE mnemonic = ?1',
        mapper: (Map<String, Object?> row) => Wallet(
            id: row['_id'] as int?,
            walletName: row['wallet_name'] as String?,
            walletType: _walletTypeConverter.decode(row['wallet_type'] as int?),
            mnemonic: row['mnemonic'] as String?,
            walletSource:
                _walletSourceConverter.decode(row['wallet_source'] as int?),
            createTime: _dateTimeConverter.decode(row['create_time'] as int?),
            updateTime: _dateTimeConverter.decode(row['update_time'] as int?)),
        arguments: [mnemonic]);
  }

  @override
  Future<int> saveAndReturnId(Wallet wallet) {
    return _walletInsertionAdapter.insertAndReturnId(
        wallet, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteAndReturnChangedRows(Wallet wallet) {
    return _walletDeletionAdapter.deleteAndReturnChangedRows(wallet);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _dateTimeNotNullConverter = DateTimeNotNullConverter();
final _bigIntConverter = BigIntConverter();
final _walletSourceConverter = WalletSourceConverter();
final _walletTypeConverter = WalletTypeConverter();
final _txStatusConverter = TxStatusConverter();
