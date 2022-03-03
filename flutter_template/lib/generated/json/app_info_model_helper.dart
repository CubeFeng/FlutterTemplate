import 'package:flutter_template/models/app_info_model.dart';

appInfoModelFromJson(AppInfoModel data, Map<String, dynamic> json) {
	if (json['channelType'] != null) {
		data.channelType = json['channelType'].toString();
	}
	if (json['channelName'] != null) {
		data.channelName = json['channelName'].toString();
	}
	if (json['channelVersion'] != null) {
		data.channelVersion = json['channelVersion'].toString();
	}
	if (json['buildTime'] != null) {
		data.buildTime = json['buildTime'].toString();
	}
	if (json['commitId'] != null) {
		data.commitId = json['commitId'].toString();
	}
	if (json['branch'] != null) {
		data.branch = json['branch'].toString();
	}
	if (json['version'] != null) {
		data.version = json['version'].toString();
	}
	if (json['buildVersion'] != null) {
		data.buildVersion = json['buildVersion'].toString();
	}
	if (json['packageName'] != null) {
		data.packageName = json['packageName'].toString();
	}
	if (json['deviceId'] != null) {
		data.deviceId = json['deviceId'].toString();
	}
	return data;
}

Map<String, dynamic> appInfoModelToJson(AppInfoModel entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['channelType'] = entity.channelType;
	data['channelName'] = entity.channelName;
	data['channelVersion'] = entity.channelVersion;
	data['buildTime'] = entity.buildTime;
	data['commitId'] = entity.commitId;
	data['branch'] = entity.branch;
	data['version'] = entity.version;
	data['buildVersion'] = entity.buildVersion;
	data['packageName'] = entity.packageName;
	data['deviceId'] = entity.deviceId;
	return data;
}
