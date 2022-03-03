part of 'dao.dart';

/// 交易记录Dao
@dao
abstract class TxDao {
  /// 查询全部
  @Query('SELECT * FROM tb_tx')
  Future<List<Tx>> findAll();

  /// 根据[id]查询
  @Query('SELECT * FROM tb_tx WHERE _id = :id')
  Future<Tx?> findById(int id);


  /// 根据[txHash]查询
  @Query('SELECT * FROM tb_tx WHERE tx_hash = :txHash')
  Future<List<Tx>> findByTXHash(String txHash);

  /// 查询币种交易记录
  @Query('SELECT * FROM tb_tx WHERE coin_type = :coin_type')
  Future<List<Tx>> findByCoinType(String coin_type);

  /// 查询币种交易记录
  @Query('SELECT * FROM tb_tx WHERE coin_type = :coin_type AND (from_address = :address or to_address = :address) AND tx_time > :from AND tx_time < :to order by tx_time desc')
  Future<List<Tx>> findByCoinTypeAndTime(String coin_type, String address, DateTime from, DateTime to);

  /// 查询币种交易记录
  @Query('SELECT * FROM tb_tx WHERE coin_type = :coin_type AND from_address = :address AND tx_time > :from AND tx_time < :to order by tx_time desc')
  Future<List<Tx>> findTOutByCoinTypeAndTime(String coin_type, String address, DateTime from, DateTime to);

  /// 查询币种交易记录
  @Query('SELECT * FROM tb_tx WHERE coin_type = :coin_type AND to_address = :address AND tx_time > :from AND tx_time < :to order by tx_time desc')
  Future<List<Tx>> findTInByCoinTypeAndTime(String coin_type, String address, DateTime from, DateTime to);

  /// 查询币种交易记录
  @Query('SELECT * FROM tb_tx WHERE coin_type = :coin_type AND token_type = :contractAddress AND (from_address = :address or to_address = :address) AND tx_time > :from AND tx_time < :to order by tx_time desc')
  Future<List<Tx>> findByTokenAndTime(String coin_type, String contractAddress, String address, DateTime from, DateTime to);

  /// 查询币种交易记录
  @Query('SELECT * FROM tb_tx WHERE coin_type = :coin_type AND token_type = :contractAddress AND from_address = :address AND tx_time > :from AND tx_time < :to order by tx_time desc')
  Future<List<Tx>> findTOutByTokenAndTime(String coin_type, String contractAddress, String address, DateTime from, DateTime to);

  /// 查询币种交易记录
  @Query('SELECT * FROM tb_tx WHERE coin_type = :coin_type AND token_type = :contractAddress AND to_address =:address AND tx_time > :from AND tx_time < :to order by tx_time desc')
  Future<List<Tx>> findTInByTokenAndTime(String coin_type, String contractAddress, String address, DateTime from, DateTime to);

  /// 查询币种交易记录
  @Query('SELECT * FROM tb_tx WHERE coin_type = :coin_type AND token_type = :contractAddress order     by tx_time desc')
  Future<List<Tx>> findNft(String coin_type, String contractAddress);

  /// 保存
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> saveAndReturnId(Tx tx);

  /// 删除
  @delete
  Future<int> deleteAndReturnChangedRows(Tx tx);
}
