part of 'dao.dart';

/// 地址簿Dao
@dao
abstract class AddressDao {
  /// 查询全部
  @Query('SELECT * FROM tb_address')
  Future<List<Address>> findAll();

  /// 根据[id]查询
  @Query('SELECT * FROM tb_address WHERE _id = :id')
  Future<Address?> findById(int id);

  /// 根据[id]查询
  @Query('SELECT * FROM tb_address WHERE coin_type = :coin_type')
  Future<List<Address>> findByType(String coin_type);

  /// 保存
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> saveAndReturnId(Address address);

  /// 删除
  @delete
  Future<int> deleteAndReturnChangedRows(Address address);
}
