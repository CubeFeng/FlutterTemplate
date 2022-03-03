import 'dart:convert';

import 'package:floor/floor.dart';

@entity
class MessageEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'create_time')
  late DateTime createTime;

  @ColumnInfo(name: 'update_time')
  late DateTime updateTime;

  @ColumnInfo(name: 'app_id')
  late String appId;

  @ColumnInfo(name: 'app_name')
  late String appName;

  late String icon;

  late String reciver;

  late String sender;

  @ColumnInfo(name: 'is_read')
  bool isRead = false;

  @ColumnInfo(name: 'msg_id')
  late String msgId;

  /// 数据库版本2新增字段
  @ColumnInfo(name: 'user_id')
  late String userId;

  late MessageContent vo;

  MessageEntity(
    this.id,
    this.appId,
    this.appName,
    this.icon,
    this.reciver,
    this.sender,
    this.isRead,
    this.msgId,
    this.userId,
    this.vo,
    this.createTime,
    this.updateTime,
  );

  MessageEntity.fromJson(Map<String, dynamic> json) {
    this.createTime = DateTime.now();
    this.updateTime = DateTime.now();
    this.appId = json['appId'];
    this.appName = json['appName'];
    this.icon = json['icon'];
    this.reciver = json['recver'];
    this.sender = json['sender'];
    this.isRead = false;
    this.msgId = json['msgId'];
    this.userId = json['userId'];
    this.vo = MessageContent.fromStr(json['vo']);
  }
}

class MessageContent {
  MessageContent({
    required this.title,
    required this.content,
  });

  late final String title;
  late final String content;

  MessageContent.fromStr(String str) {
    var map = json.decode(str);
    title = map['title'];
    content = map['content'];
  }

  String toString() {
    return '{"title": "$title", "content": "$content"}';
  }

  MessageContent.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
  }

  String toJsonString() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['content'] = content;
    return json.encode(_data);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['content'] = content;
    return _data;
  }
}
