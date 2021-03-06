// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

import 'package:flutter_ucore/apis/api_host_model.dart';
import 'package:flutter_ucore/generated/json/api_host_model_helper.dart';
import 'package:flutter_ucore/generated/json/app_info_model_helper.dart';
import 'package:flutter_ucore/generated/json/app_information_model_helper.dart';
import 'package:flutter_ucore/generated/json/category_model_helper.dart';
import 'package:flutter_ucore/generated/json/check_version_model_entity_helper.dart';
import 'package:flutter_ucore/generated/json/news_model_helper.dart';
import 'package:flutter_ucore/generated/json/oauth_app_info_model_helper.dart';
import 'package:flutter_ucore/generated/json/read_and_rss_num_model_helper.dart';
import 'package:flutter_ucore/generated/json/refresh_token_model_entity_helper.dart';
import 'package:flutter_ucore/generated/json/rss_model_helper.dart';
import 'package:flutter_ucore/generated/json/user_head_name_model_entity_helper.dart';
import 'package:flutter_ucore/generated/json/user_message_model_entity_helper.dart';
import 'package:flutter_ucore/generated/json/user_model_helper.dart';
import 'package:flutter_ucore/generated/json/user_state_model_entity_helper.dart';
import 'package:flutter_ucore/models/app_info_model.dart';
import 'package:flutter_ucore/models/news/category_model.dart';
import 'package:flutter_ucore/models/news/news_model.dart';
import 'package:flutter_ucore/models/news/read_and_rss_num_model.dart';
import 'package:flutter_ucore/models/news/rss_model.dart';
import 'package:flutter_ucore/models/user/app_information_model.dart';
import 'package:flutter_ucore/models/user/check_version_model_entity.dart';
// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutter_ucore/models/user/oauth_app_info_model.dart';
import 'package:flutter_ucore/models/user/refresh_token_model_entity.dart';
import 'package:flutter_ucore/models/user/user_head_name_model_entity.dart';
import 'package:flutter_ucore/models/user/user_message_model_entity.dart';
import 'package:flutter_ucore/models/user/user_state_model_entity.dart';
import 'package:flutter_ucore/models/user_model.dart';

class JsonConvert<T> {
  T fromJson(Map<String, dynamic> json) {
    return _getFromJson<T>(runtimeType, this, json);
  }

  Map<String, dynamic> toJson() {
    return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {
      case OauthAppInfoModel:
        return oauthAppInfoModelFromJson(data as OauthAppInfoModel, json) as T;
      case CategoryModel:
        return categoryModelFromJson(data as CategoryModel, json) as T;
      case UserStateModelEntity:
        return userStateModelEntityFromJson(data as UserStateModelEntity, json) as T;
      case NewsItemModel:
        return newsItemModelFromJson(data as NewsItemModel, json) as T;
      case PagedNewsItemModel:
        return pagedNewsItemModelFromJson(data as PagedNewsItemModel, json) as T;
      case WithBgPagedNewsItemModel:
        return withBgPagedNewsItemModelFromJson(data as WithBgPagedNewsItemModel, json) as T;
      case ReadAndRssNumModel:
        return readAndRssNumModelFromJson(data as ReadAndRssNumModel, json) as T;
      case CheckVersionModelEntity:
        return checkVersionModelEntityFromJson(data as CheckVersionModelEntity, json) as T;
      case AppInfoModel:
        return appInfoModelFromJson(data as AppInfoModel, json) as T;
      case ApiHostModel:
        return apiHostModelFromJson(data as ApiHostModel, json) as T;
      case UserMessageModelEntity:
        return userMessageModelEntityFromJson(data as UserMessageModelEntity, json) as T;
      case UserHeadNameModelEntity:
        return userHeadNameModelEntityFromJson(data as UserHeadNameModelEntity, json) as T;
      case RefreshTokenModelEntity:
        return refreshTokenModelEntityFromJson(data as RefreshTokenModelEntity, json) as T;
      case AppInformationModel:
        return appInformationModelFromJson(data as AppInformationModel, json) as T;
      case UserModel:
        return userModelFromJson(data as UserModel, json) as T;
      case RssModel:
        return rssModelFromJson(data as RssModel, json) as T;
      case PagedRssModel:
        return pagedRssModelFromJson(data as PagedRssModel, json) as T;
    }
    return data as T;
  }

  static _getToJson<T>(Type type, data) {
    switch (type) {
      case OauthAppInfoModel:
        return oauthAppInfoModelToJson(data as OauthAppInfoModel);
      case CategoryModel:
        return categoryModelToJson(data as CategoryModel);
      case UserStateModelEntity:
        return userStateModelEntityToJson(data as UserStateModelEntity);
      case NewsItemModel:
        return newsItemModelToJson(data as NewsItemModel);
      case PagedNewsItemModel:
        return pagedNewsItemModelToJson(data as PagedNewsItemModel);
      case WithBgPagedNewsItemModel:
        return withBgPagedNewsItemModelToJson(data as WithBgPagedNewsItemModel);
      case ReadAndRssNumModel:
        return readAndRssNumModelToJson(data as ReadAndRssNumModel);
      case CheckVersionModelEntity:
        return checkVersionModelEntityToJson(data as CheckVersionModelEntity);
      case AppInfoModel:
        return appInfoModelToJson(data as AppInfoModel);
      case ApiHostModel:
        return apiHostModelToJson(data as ApiHostModel);
      case UserMessageModelEntity:
        return userMessageModelEntityToJson(data as UserMessageModelEntity);
      case UserHeadNameModelEntity:
        return userHeadNameModelEntityToJson(data as UserHeadNameModelEntity);
      case RefreshTokenModelEntity:
        return refreshTokenModelEntityToJson(data as RefreshTokenModelEntity);
      case AppInformationModel:
        return appInformationModelToJson(data as AppInformationModel);
      case UserModel:
        return userModelToJson(data as UserModel);
      case RssModel:
        return rssModelToJson(data as RssModel);
      case PagedRssModel:
        return pagedRssModelToJson(data as PagedRssModel);
    }
    return data as T;
  }

  //Go back to a single instance by type
  static _fromJsonSingle<M>(json) {
    String type = M.toString();
    if (type == (OauthAppInfoModel).toString()) {
      return OauthAppInfoModel().fromJson(json);
    }
    if (type == (CategoryModel).toString()) {
      return CategoryModel().fromJson(json);
    }
    if (type == (UserStateModelEntity).toString()) {
      return UserStateModelEntity().fromJson(json);
    }
    if (type == (NewsItemModel).toString()) {
      return NewsItemModel().fromJson(json);
    }
    if (type == (PagedNewsItemModel).toString()) {
      return PagedNewsItemModel().fromJson(json);
    }
    if (type == (WithBgPagedNewsItemModel).toString()) {
      return WithBgPagedNewsItemModel().fromJson(json);
    }
    if (type == (ReadAndRssNumModel).toString()) {
      return ReadAndRssNumModel().fromJson(json);
    }
    if (type == (CheckVersionModelEntity).toString()) {
      return CheckVersionModelEntity().fromJson(json);
    }
    if (type == (AppInfoModel).toString()) {
      return AppInfoModel().fromJson(json);
    }
    if (type == (ApiHostModel).toString()) {
      return ApiHostModel().fromJson(json);
    }
    if (type == (UserMessageModelEntity).toString()) {
      return UserMessageModelEntity().fromJson(json);
    }
    if (type == (UserHeadNameModelEntity).toString()) {
      return UserHeadNameModelEntity().fromJson(json);
    }
    if (type == (RefreshTokenModelEntity).toString()) {
      return RefreshTokenModelEntity().fromJson(json);
    }
    if (type == (AppInformationModel).toString()) {
      return AppInformationModel().fromJson(json);
    }
    if (type == (UserModel).toString()) {
      return UserModel().fromJson(json);
    }
    if (type == (RssModel).toString()) {
      return RssModel().fromJson(json);
    }
    if (type == (PagedRssModel).toString()) {
      return PagedRssModel().fromJson(json);
    }

    return null;
  }

  //list is returned by type
  static M _getListChildType<M>(List data) {
    if (<OauthAppInfoModel>[] is M) {
      return data.map<OauthAppInfoModel>((e) => OauthAppInfoModel().fromJson(e)).toList() as M;
    }
    if (<CategoryModel>[] is M) {
      return data.map<CategoryModel>((e) => CategoryModel().fromJson(e)).toList() as M;
    }
    if (<UserStateModelEntity>[] is M) {
      return data.map<UserStateModelEntity>((e) => UserStateModelEntity().fromJson(e)).toList() as M;
    }
    if (<NewsItemModel>[] is M) {
      return data.map<NewsItemModel>((e) => NewsItemModel().fromJson(e)).toList() as M;
    }
    if (<PagedNewsItemModel>[] is M) {
      return data.map<PagedNewsItemModel>((e) => PagedNewsItemModel().fromJson(e)).toList() as M;
    }
    if (<WithBgPagedNewsItemModel>[] is M) {
      return data.map<WithBgPagedNewsItemModel>((e) => WithBgPagedNewsItemModel().fromJson(e)).toList() as M;
    }
    if (<ReadAndRssNumModel>[] is M) {
      return data.map<ReadAndRssNumModel>((e) => ReadAndRssNumModel().fromJson(e)).toList() as M;
    }
    if (<CheckVersionModelEntity>[] is M) {
      return data.map<CheckVersionModelEntity>((e) => CheckVersionModelEntity().fromJson(e)).toList() as M;
    }
    if (<AppInfoModel>[] is M) {
      return data.map<AppInfoModel>((e) => AppInfoModel().fromJson(e)).toList() as M;
    }
    if (<ApiHostModel>[] is M) {
      return data.map<ApiHostModel>((e) => ApiHostModel().fromJson(e)).toList() as M;
    }
    if (<UserMessageModelEntity>[] is M) {
      return data.map<UserMessageModelEntity>((e) => UserMessageModelEntity().fromJson(e)).toList() as M;
    }
    if (<UserHeadNameModelEntity>[] is M) {
      return data.map<UserHeadNameModelEntity>((e) => UserHeadNameModelEntity().fromJson(e)).toList() as M;
    }
    if (<RefreshTokenModelEntity>[] is M) {
      return data.map<RefreshTokenModelEntity>((e) => RefreshTokenModelEntity().fromJson(e)).toList() as M;
    }
    if (<AppInformationModel>[] is M) {
      return data.map<AppInformationModel>((e) => AppInformationModel().fromJson(e)).toList() as M;
    }
    if (<UserModel>[] is M) {
      return data.map<UserModel>((e) => UserModel().fromJson(e)).toList() as M;
    }
    if (<RssModel>[] is M) {
      return data.map<RssModel>((e) => RssModel().fromJson(e)).toList() as M;
    }
    if (<PagedRssModel>[] is M) {
      return data.map<PagedRssModel>((e) => PagedRssModel().fromJson(e)).toList() as M;
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
