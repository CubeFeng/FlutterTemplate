import 'package:floor/floor.dart';
import 'package:flutter_ucore/database/entity/entity.dart';

@dao
abstract class MessageDao {
  @Query(
      'SELECT * FROM MessageEntity WHERE user_id=:userId ORDER BY create_time DESC')
  Future<List<MessageEntity>> findAllByUserId(String userId);

  @Query('SELECT * FROM MessageEntity WHERE id = :id')
  Future<MessageEntity?> findMessageById(int id);

  @insert
  Future<int> insertMessage(MessageEntity message);

  @update
  Future<int> updateMessage(List<MessageEntity> messages);

  @update
  Future<int> updateMessag(MessageEntity message);
}
