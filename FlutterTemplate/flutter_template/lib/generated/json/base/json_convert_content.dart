// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutter_template/models/app_info_model.dart';
import 'package:flutter_template/generated/json/app_info_model_helper.dart';
import 'package:flutter_template/apis/api_host_model.dart';
import 'package:flutter_template/generated/json/api_host_model_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
		switch (type) {
			case AppInfoModel:
				return appInfoModelFromJson(data as AppInfoModel, json) as T;
			case ApiHostModel:
				return apiHostModelFromJson(data as ApiHostModel, json) as T;    }
		return data as T;
	}

  static _getToJson<T>(Type type, data) {
		switch (type) {
			case AppInfoModel:
				return appInfoModelToJson(data as AppInfoModel);
			case ApiHostModel:
				return apiHostModelToJson(data as ApiHostModel);
			}
			return data as T;
		}
  //Go back to a single instance by type
	static _fromJsonSingle<M>( json) {
		String type = M.toString();
		if(type == (AppInfoModel).toString()){
			return AppInfoModel().fromJson(json);
		}
		if(type == (ApiHostModel).toString()){
			return ApiHostModel().fromJson(json);
		}

		return null;
	}

  //list is returned by type
	static M _getListChildType<M>(List data) {
		if(<AppInfoModel>[] is M){
			return data.map<AppInfoModel>((e) => AppInfoModel().fromJson(e)).toList() as M;
		}
		if(<ApiHostModel>[] is M){
			return data.map<ApiHostModel>((e) => ApiHostModel().fromJson(e)).toList() as M;
		}

		throw Exception("not found");
	}

  static M fromJsonAsT<M>(json) {
		if (json is List) {
			return _getListChildType<M>(json);
		} else {
			return _fromJsonSingle<M>(json) as M;
		}
	}
}