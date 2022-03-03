import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class VersionInfoModel {
  String? versionNo;

  String? minVersionNo;

  String? h5Url;

  String? serialNo;

  String? versionContent;

  String? downloadUrl;

  bool? forceUpdate;
}
