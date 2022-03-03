
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class ResourceCode extends $pb.ProtobufEnum {
  static const ResourceCode BANDWIDTH = ResourceCode._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BANDWIDTH');
  static const ResourceCode ENERGY = ResourceCode._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ENERGY');

  static const $core.List<ResourceCode> values = <ResourceCode> [
    BANDWIDTH,
    ENERGY,
  ];

  static final $core.Map<$core.int, ResourceCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ResourceCode valueOf($core.int value) => _byValue[value]!;

  const ResourceCode._($core.int v, $core.String n) : super(v, n);
}

