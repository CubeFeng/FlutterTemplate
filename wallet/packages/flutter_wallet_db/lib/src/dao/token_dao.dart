part of 'dao.dart';

/// 代币Dao
@dao
abstract class TokenDao {
  /// 查询全部
  @Query('SELECT * FROM tb_token ORDER BY sort_index')
  Future<List<Token>> findAll();

  /// 根据[id]查询
  @Query('SELECT * FROM tb_token WHERE _id = :id')
  Future<Token?> findById(int id);

  /// 根据[coinId]查询
  @Query(
    'SELECT * FROM tb_token WHERE coin_id = :coinId ORDER BY sort_index',
  )
  Future<List<Token>> findAllByCoinId(int coinId);

  /// 根据[coinType]查询
  @Query(
    'SELECT * FROM tb_token WHERE coin_type = :coinType ORDER BY sort_index',
  )
  Future<List<Token>> findAllByCoinType(String coinType);

  /// 根据[tokenType]查询
  @Query(
    'SELECT * FROM tb_token WHERE token_type = :tokenType ORDER BY sort_index',
  )
  Future<List<Token>> findAllByTokenType(String tokenType);

  /// 根据[coinType]和[tokenType]查询
  @Query('''
SELECT * FROM tb_token
WHERE coin_type = :coinType AND token_type = :tokenType
ORDER BY sort_index
    ''')
  Future<List<Token>> findAllByCoinTypeAndTokenType(
    String coinType,
    String tokenType,
  );

  /// 根据[coinAddress]查询
  @Query(
    'SELECT * FROM tb_coin WHERE coin_address = :coinAddress ORDER BY sort_index',
  )
  Future<List<Token>> findAllByCoinAddress(String coinAddress);

  /// 保存
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> saveAndReturnId(Token user);

  /// 删除
  @delete
  Future<int> deleteAndReturnChangedRows(Token user);
}
