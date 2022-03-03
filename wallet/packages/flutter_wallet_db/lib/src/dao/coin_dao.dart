part of 'dao.dart';

/// 币种Dao
@dao
abstract class CoinDao {
  /// 查询全部
  @Query('SELECT * FROM tb_coin ORDER BY sort_index')
  Future<List<Coin>> findAll();

  /// 根据[id]查询
  @Query('SELECT * FROM tb_coin WHERE _id = :id')
  Future<Coin?> findById(int id);

  /// 根据[coinType]查询
  @Query(
    'SELECT * FROM tb_coin WHERE coin_type = :coinType ORDER BY sort_index',
  )
  Future<List<Coin>> findAllByCoinType(String coinType);

  /// 根据[coinType]查询
  @Query(
    'SELECT * FROM tb_coin WHERE wallet_id = :wallet_id ORDER BY sort_index',
  )
  Future<List<Coin>> findAllByWalletId(int wallet_id);

  /// 根据[coinAddress]查询
  @Query(
    '''
    SELECT * FROM tb_coin
    WHERE coin_type = :coinType AND coin_address = :coinAddress
    ORDER BY sort_index
    ''',
  )
  Future<List<Coin>> findAllByCoinAddress(String coinType, String coinAddress);

  /// 保存
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> saveAndReturnId(Coin coin);

  /// 删除
  @delete
  Future<int> deleteAndReturnChangedRows(Coin coin);
}
