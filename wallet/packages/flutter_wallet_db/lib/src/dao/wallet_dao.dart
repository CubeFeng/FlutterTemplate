part of 'dao.dart';

/// 钱包Dao
@dao
abstract class WalletDao {
  /// 查询全部
  @Query('SELECT * FROM tb_wallet')
  Future<List<Wallet>> findAll();

  /// 根据[id]查询
  @Query('SELECT * FROM tb_wallet WHERE _id = :id')
  Future<Wallet?> findById(int id);

  /// 根据[mnemonic]查询单个
  @Query('SELECT * FROM tb_wallet WHERE mnemonic = :mnemonic LIMIT 1')
  Future<Wallet?> findByMnemonic(String mnemonic);

  /// 根据[mnemonic]查询全部
  @Query('SELECT * FROM tb_wallet WHERE mnemonic = :mnemonic')
  Future<List<Wallet>> findAllByMnemonic(String mnemonic);

  /// 保存
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> saveAndReturnId(Wallet wallet);

  /// 删除
  @delete
  Future<int> deleteAndReturnChangedRows(Wallet wallet);
}
