# 钱包App

Flutter 钱包

## 目录结构

```bash
├── .fvm                                # flutter version manager
├── android                             # 安卓原生工程目录
├── ios                                 # iOS原生工程目录
├── fastlane                            # Fastlane（打包）
├── assets                              # 资源目录, 如果需要打包进App, 需要在 pubspec.yaml 中配置
│   ├── config                              # 应用配置目录
│   │   ├── api.config.json                     # api 接口配置
│   │   └── app.config.json                     # app 信息配置（部分内容由ci生成）
│   ├── fonts                               # 字体包, 如果需要打包进App, 需要在 pubspec.yaml 中配置
│   ├── icons                               # app icon图标与启动页（此项非必需配置在pubspec.yaml）
│   └── images                              # 图片资源, 需要在 pubspec.yaml 中配置
├── lib                                 # dart、flutter 相关源码文件
│   ├── apis                            # 网络相关
│   │   ├── api_host_model.dart             # host model
│   │   ├── api_urls.dart                   # api 接口声明
│   │   ├── interceptor                     # 网络拦截器
│   │   └── transformer                     # response data 解析器
│   ├── common                          # 公用的keys等
│   ├── generated                       # 由 build_runner 自动生成的文件
│   ├── i18n                            # 国际化配置
│   ├── middleware                      # 中间件
│   ├── models                          # 全局model类
│   ├── modules                         # 模块
│   │   └── dashboard                       # 模块名称
│   ├── routes                          # 路由配置
│   │   ├── app_pages.dart                  # 路由配置
│   │   └── app_routes.dart                 # 路由key配置
│   ├── services                        # 应用服务类
│   ├── utils                           # 工具类
│   ├── widgets                         # 通用组件
│   └── main.dart                       # 主入口类
├── web                                 # web 工程目录
├── pubspec.yaml                        # 依赖配置
├── analysis_options.yaml               # 代码分析配置
├── .gitlab-ci.yml                      # 持续集成配置文件
├── test                                # 单元测试目录
├── test_driver                         # 集成测试目录
└── README.md
```



##  i18n_runner插件使用

将语言包文件 `i18n.json` 拷贝到 `lib/i18n/` 目录中,然后执行 `flutter pub run i18n_runner` 命令，此工具会根据语言包文件自动生成`lib/i18n/translations/xxx.dart` 语言包代码和 `lib\generated\i18n_keys.dart` 词条资源引用。


```json
// i18n.json文件内容
[
  {
    "id": 200000,
    "key": "home",
    "zhCN": "主页",
    "zhTW": "主頁",
    "en": "homepage",
    "ko": "홈 페이지",
    "ja": "ホームページ",
    "fr": "Page d'accueil",
    "es": "Página principal"
  }
]
```

## 更改包名、app名称

```bash
flutter pub run flutter_rename_app
```

详细参数请参考：pubspec.yaml

```yaml
flutter_rename_app:
  application_name: UCore
  dart_package_name: flutter_ucore
  application_id: com.android.bank
  bundle_id: com.ios.bank
  android_package_name: com.bank.app
```

## 生成 Icon

```bash
flutter pub run flutter_launcher_icons:main
```

详细参数请参考：pubspec.yaml

```yaml
flutter_icons:
  ios: true
  android: true
  image_path_ios: "assets/icons/app_icon_ios.png"
  image_path_android: "assets/icons/app_icon_ad.png"
#  adaptive_icon_background: "assets/icons/adaptive_icon_background.png" # for Android 8.0+ devices
#  adaptive_icon_foreground: "assets/icons/adaptive_icon_foreground.png" # for Android 8.0+ devices
```

## 生成启动页

```bash
flutter pub run flutter_native_splash:create
```

详细参数请参考：pubspec.yaml

```yaml
flutter_native_splash:
  #  color: "#FFFE9A4E"
  background_image: "assets/icons/splash.png"
  #image: assets/splash.png
  #color_dark: "#042a49"
  #background_image_dark: "assets/dark-background.png"
  #image_dark: assets/splash-invert.png
  #android_gravity: center
  #ios_content_mode: center
  android: true
  ios: true
  fullscreen: true
```

# 自动翻译语言

example:

1. 如下为要添加的词条：

```
一条小团团
一堆小垃圾
```

2. 打开 `app/lib/i18n/translator.json` 进行编辑

```json
[
  {"zhCN": "一条小团团"},
  {"zhCN": "一堆小垃圾"}
]
```

3. 进入 **app** 目录下, 执行以下命令

```shell
flutter pub run flutter_baidu_translator_runner
```

4. 如上命令会使用翻译好的内容重写 `app/lib/i18n/translator.json`

内容如下：

```json
[
  {
    "zhCN": "一条小团团",
    "ko": "뭉 게 뭉 게",
    "ja": "小さな団塊一つ",
    "zhTW": "一條小團團",
    "en": "A small ball",
    "key": "aSmallBall"
  },
  {
    "zhCN": "一堆小垃圾",
    "ko": "작은 쓰레기 더미",
    "ja": "小さなゴミの山",
    "zhTW": "一堆小垃圾",
    "en": "A pile of little garbage",
    "key": "aPileOfLittleGarbage"
  }
]
```

5. 将如上内容复制到 `app/lib/i18n/i18n.json` 文件里

6. 生成 i18n 相关文件, 在 **app** 目录下执行

```shell
flutter pub run i18n_runner
```

7. 如上命令会在以下目录生成对应文件

```
├── ...
├── lib
│   ├── generated
│   │   └── i18n_keys.dart      # 使用时需要引入此文件
│   ├── i18n
│   │   └── i18n.dart
│   ├── translations
│   │   ├── en_US.dart
│   │   ├── ja.dart
│   │   ├── ko.dart
│   │   ├── zh_CN.dart
│   │   └── zh_TW.dart
│   └── ...
└── ...
```
