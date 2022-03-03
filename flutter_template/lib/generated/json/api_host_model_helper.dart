import 'package:flutter_template/apis/api_host_model.dart';

apiHostModelFromJson(ApiHostModel data, Map<String, dynamic> json) {
	if (json['apiHost'] != null) {
		data.apiHost = json['apiHost'].toString();
	}
	if (json['wsHost'] != null) {
		data.wsHost = json['wsHost'].toString();
	}
	return data;
}

Map<String, dynamic> apiHostModelToJson(ApiHostModel entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['apiHost'] = entity.apiHost;
	data['wsHost'] = entity.wsHost;
	return data;
}
